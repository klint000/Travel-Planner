using System;
using System.Collections.Generic;
using System.Globalization;
using Microsoft.Data.SqlClient;
using System.Security.Cryptography;
using System.Windows.Media.Imaging;
using System.IO;

namespace Travel_Planner;

public static class DatabaseService
{
    private const string ConnectionString = "Server=localhost;Database=travel_planner;User Id=sa;password=123;Integrated Security=True;TrustServerCertificate=True;Encrypt=False";

    public static void Initialize()
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
IF OBJECT_ID('dbo.user_credentials', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.user_credentials
    (
        user_id INT NOT NULL PRIMARY KEY,
        password_salt VARBINARY(16) NOT NULL,
        password_hash VARBINARY(32) NOT NULL,
        CONSTRAINT FK_user_credentials_users FOREIGN KEY (user_id) REFERENCES dbo.users(id) ON DELETE CASCADE
    );
END

IF COL_LENGTH('dbo.users', 'is_blocked') IS NULL
BEGIN
    ALTER TABLE dbo.users ADD is_blocked BIT NOT NULL CONSTRAINT DF_users_is_blocked DEFAULT(0);
END";

        using SqlCommand command = new(sql, connection);
        command.ExecuteNonQuery();
    }

    public static bool UserExists(string username, string email)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"SELECT COUNT(1) FROM dbo.users WHERE username = @username OR email = @email";
        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@username", username);
        command.Parameters.AddWithValue("@email", email);

        int count = Convert.ToInt32(command.ExecuteScalar());
        return count > 0;
    }

    public static AuthenticatedUser RegisterUser(string username, string email, string password)
    {
        byte[] salt = RandomNumberGenerator.GetBytes(16);
        byte[] hash = PasswordHasher.HashPassword(password, salt);

        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        using SqlTransaction transaction = connection.BeginTransaction();
        try
        {
            const string insertUserSql = @"
INSERT INTO dbo.users (username, email, role_id, created_at)
VALUES (@username, @email, 1, GETDATE());
SELECT CAST(SCOPE_IDENTITY() AS INT);";

            using SqlCommand insertUserCommand = new(insertUserSql, connection, transaction);
            insertUserCommand.Parameters.AddWithValue("@username", username);
            insertUserCommand.Parameters.AddWithValue("@email", email);

            int userId = Convert.ToInt32(insertUserCommand.ExecuteScalar());

            const string insertCredentialsSql = @"
INSERT INTO dbo.user_credentials (user_id, password_salt, password_hash)
VALUES (@user_id, @salt, @hash);";

            using SqlCommand insertCredentialsCommand = new(insertCredentialsSql, connection, transaction);
            insertCredentialsCommand.Parameters.AddWithValue("@user_id", userId);
            insertCredentialsCommand.Parameters.AddWithValue("@salt", salt);
            insertCredentialsCommand.Parameters.AddWithValue("@hash", hash);
            insertCredentialsCommand.ExecuteNonQuery();

            transaction.Commit();
            return new AuthenticatedUser
            {
                Id = userId,
                FullName = username,
                Email = email,
                RoleId = 1,
                RoleName = "User",
                IsBlocked = false
            };
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public static AuthenticatedUser? AuthenticateUser(string loginOrEmail, string password)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
SELECT TOP (1) u.id,
               u.username,
               u.email,
               u.role_id,
               ISNULL(r.name, 'User') AS role_name,
               ISNULL(u.is_blocked, 0) AS is_blocked,
               c.password_salt,
               c.password_hash
FROM dbo.users u
INNER JOIN dbo.user_credentials c ON u.id = c.user_id
LEFT JOIN dbo.roles r ON r.id = u.role_id
WHERE u.username = @login OR u.email = @login";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@login", loginOrEmail);

        using SqlDataReader reader = command.ExecuteReader();
        if (!reader.Read())
        {
            return null;
        }

        byte[] salt = (byte[])reader["password_salt"];
        byte[] storedHash = (byte[])reader["password_hash"];
        byte[] candidateHash = PasswordHasher.HashPassword(password, salt);

        if (!CryptographicOperations.FixedTimeEquals(storedHash, candidateHash))
        {
            return null;
        }

        return new AuthenticatedUser
        {
            Id = reader.GetInt32(reader.GetOrdinal("id")),
            FullName = reader.GetString(reader.GetOrdinal("username")),
            Email = reader.GetString(reader.GetOrdinal("email")),
            RoleId = reader.GetInt32(reader.GetOrdinal("role_id")),
            RoleName = reader.GetString(reader.GetOrdinal("role_name")),
            IsBlocked = reader.GetBoolean(reader.GetOrdinal("is_blocked"))
        };
    }

    public static List<TripCatalogItem> GetTripCatalogItems()
    {
        return GetTripCatalogItems(string.Empty, "Все", "Название", false);
    }

    public static List<TripCatalogItem> GetTripCatalogItems(string searchText, string difficultyFilter, string sortField, bool sortDescending)
    {
        List<TripCatalogItem> items = [];
        string orderBy = sortField switch
        {
            "Дата начала" => "start_date",
            "Бюджет" => "budget",
            _ => "name"
        };

        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        string sql = $@"
SELECT TOP (200) id, user_id, name, start_date, end_date, budget, image
FROM dbo.trips
WHERE (@search = '' OR name LIKE @searchPattern)
ORDER BY {orderBy} {(sortDescending ? "DESC" : "ASC")}, id DESC";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@search", searchText ?? string.Empty);
        command.Parameters.AddWithValue("@searchPattern", $"%{searchText?.Trim() ?? string.Empty}%");
        using SqlDataReader reader = command.ExecuteReader();

        while (reader.Read())
        {
            int id = reader.GetInt32(0);
            int userId = reader.GetInt32(1);
            string name = reader.GetString(2);
            DateTime startDate = reader.GetDateTime(3);
            DateTime endDate = reader.GetDateTime(4);
            decimal? budget = reader.IsDBNull(5) ? null : reader.GetDecimal(5);
            byte[]? imageBytes = reader.IsDBNull(6) ? null : (byte[])reader[6];

            int durationDays = Math.Max(1, (endDate - startDate).Days + 1);
            string durationText = $"{durationDays} дн.";
            string budgetText = budget.HasValue ? $"{budget.Value:N0} ₽" : "Бюджет не указан";
            string difficulty = durationDays switch
            {
                <= 3 => "Легко",
                <= 7 => "Средне",
                _ => "Сложно"
            };

            TripCatalogItem item = new()
            {
                Id = id,
                Title = name,
                Name = name,
                UserId = userId,
                StartDate = startDate,
                EndDate = endDate,
                BudgetValue = budget,
                ImageBytes = imageBytes,
                Description = $"{startDate:dd.MM.yyyy} - {endDate:dd.MM.yyyy}",
                Budget = budgetText,
                Duration = durationText,
                Difficulty = difficulty,
                Rating = Math.Min(5, Math.Max(1, (durationDays + 1) / 2)),
                Image = ToBitmapImage(imageBytes)
            };

            if (difficultyFilter == "Все" || item.Difficulty == difficultyFilter)
            {
                items.Add(item);
            }
        }

        return items;
    }

    public static void AddTrip(TripCatalogItem trip)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
INSERT INTO dbo.trips (user_id, name, start_date, end_date, budget, image)
VALUES (@user_id, @name, @start_date, @end_date, @budget, @image)";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@user_id", trip.UserId);
        command.Parameters.AddWithValue("@name", trip.Name);
        command.Parameters.AddWithValue("@start_date", trip.StartDate.Date);
        command.Parameters.AddWithValue("@end_date", trip.EndDate.Date);
        command.Parameters.AddWithValue("@budget", trip.BudgetValue is null ? DBNull.Value : trip.BudgetValue.Value);
        command.Parameters.AddWithValue("@image", trip.ImageBytes is null ? DBNull.Value : trip.ImageBytes);
        command.ExecuteNonQuery();
    }

    public static void UpdateTrip(TripCatalogItem trip)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
UPDATE dbo.trips
SET user_id = @user_id,
    name = @name,
    start_date = @start_date,
    end_date = @end_date,
    budget = @budget,
    image = @image
WHERE id = @id";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@id", trip.Id);
        command.Parameters.AddWithValue("@user_id", trip.UserId);
        command.Parameters.AddWithValue("@name", trip.Name);
        command.Parameters.AddWithValue("@start_date", trip.StartDate.Date);
        command.Parameters.AddWithValue("@end_date", trip.EndDate.Date);
        command.Parameters.AddWithValue("@budget", trip.BudgetValue is null ? DBNull.Value : trip.BudgetValue.Value);
        command.Parameters.AddWithValue("@image", trip.ImageBytes is null ? DBNull.Value : trip.ImageBytes);
        command.ExecuteNonQuery();
    }

    public static void DeleteTrip(int id)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = "DELETE FROM dbo.trips WHERE id = @id";
        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@id", id);
        command.ExecuteNonQuery();
    }

    public static TripCatalogItem? GetTripById(int id)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
SELECT TOP (1) id, user_id, name, start_date, end_date, budget, image
FROM dbo.trips
WHERE id = @id";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@id", id);
        using SqlDataReader reader = command.ExecuteReader();

        if (!reader.Read())
        {
            return null;
        }

        int tripId = reader.GetInt32(0);
        int userId = reader.GetInt32(1);
        string name = reader.GetString(2);
        DateTime startDate = reader.GetDateTime(3);
        DateTime endDate = reader.GetDateTime(4);
        decimal? budget = reader.IsDBNull(5) ? null : reader.GetDecimal(5);
        byte[]? imageBytes = reader.IsDBNull(6) ? null : (byte[])reader[6];

        int durationDays = Math.Max(1, (endDate - startDate).Days + 1);
        return new TripCatalogItem
        {
            Id = tripId,
            UserId = userId,
            Name = name,
            StartDate = startDate,
            EndDate = endDate,
            BudgetValue = budget,
            ImageBytes = imageBytes,
            Title = name,
            Description = $"{startDate:dd.MM.yyyy} - {endDate:dd.MM.yyyy}",
            Budget = budget.HasValue ? $"{budget.Value:N0} ₽" : "Бюджет не указан",
            Duration = $"{durationDays} дн.",
            Difficulty = durationDays switch
            {
                <= 3 => "Легко",
                <= 7 => "Средне",
                _ => "Сложно"
            },
            Rating = Math.Min(5, Math.Max(1, (durationDays + 1) / 2)),
            Image = ToBitmapImage(imageBytes)
        };
    }

    public static List<UserManagementItem> GetUsersForAdmin(string search)
    {
        List<UserManagementItem> users = [];

        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
SELECT u.id,
       u.username,
       u.email,
       u.role_id,
       ISNULL(r.name, 'User') AS role_name,
       ISNULL(u.is_blocked, 0) AS is_blocked
FROM dbo.users u
LEFT JOIN dbo.roles r ON r.id = u.role_id
WHERE (@search = '' OR u.username LIKE @searchPattern OR u.email LIKE @searchPattern)
ORDER BY u.id";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@search", search ?? string.Empty);
        command.Parameters.AddWithValue("@searchPattern", $"%{search?.Trim() ?? string.Empty}%");

        using SqlDataReader reader = command.ExecuteReader();
        while (reader.Read())
        {
            users.Add(new UserManagementItem
            {
                Id = reader.GetInt32(0),
                FullName = reader.GetString(1),
                Email = reader.GetString(2),
                RoleId = reader.GetInt32(3),
                RoleName = reader.GetString(4),
                IsBlocked = reader.GetBoolean(5)
            });
        }

        return users;
    }

    public static void UpdateUserRole(int userId, int roleId)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = "UPDATE dbo.users SET role_id = @role_id WHERE id = @id";
        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@id", userId);
        command.Parameters.AddWithValue("@role_id", roleId);
        command.ExecuteNonQuery();
    }

    public static void SetUserBlocked(int userId, bool isBlocked)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = "UPDATE dbo.users SET is_blocked = @is_blocked WHERE id = @id";
        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@id", userId);
        command.Parameters.AddWithValue("@is_blocked", isBlocked);
        command.ExecuteNonQuery();
    }

    public static AdminAnalytics GetAdminAnalytics()
    {
        AdminAnalytics analytics = new();

        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string totalTripsSql = "SELECT COUNT(1) FROM dbo.trips";
        using (SqlCommand command = new(totalTripsSql, connection))
        {
            analytics.TotalTrips = Convert.ToInt32(command.ExecuteScalar());
        }

        const string byDifficultySql = @"
SELECT CASE
           WHEN DATEDIFF(DAY, start_date, end_date) + 1 <= 3 THEN N'Легко'
           WHEN DATEDIFF(DAY, start_date, end_date) + 1 <= 7 THEN N'Средне'
           ELSE N'Сложно'
       END AS difficulty,
       COUNT(1) AS total
FROM dbo.trips
GROUP BY CASE
           WHEN DATEDIFF(DAY, start_date, end_date) + 1 <= 3 THEN N'Легко'
           WHEN DATEDIFF(DAY, start_date, end_date) + 1 <= 7 THEN N'Средне'
           ELSE N'Сложно'
         END
ORDER BY total DESC";

        using (SqlCommand command = new(byDifficultySql, connection))
        using (SqlDataReader reader = command.ExecuteReader())
        {
            while (reader.Read())
            {
                analytics.TripsByDifficulty.Add(new CategoryStat
                {
                    Name = reader.GetString(0),
                    Count = reader.GetInt32(1)
                });
            }
        }

        const string topTripsSql = @"
SELECT TOP (5) id, name, start_date
FROM dbo.trips
ORDER BY id DESC";

        using (SqlCommand command = new(topTripsSql, connection))
        using (SqlDataReader reader = command.ExecuteReader())
        {
            while (reader.Read())
            {
                analytics.TopTrips.Add(new TopTripItem
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    StartDate = reader.GetDateTime(2)
                });
            }
        }

        const string usersSummarySql = @"
SELECT COUNT(1) AS total_users,
       SUM(CASE WHEN role_id = 1 THEN 1 ELSE 0 END) AS users_count,
       SUM(CASE WHEN role_id = 2 THEN 1 ELSE 0 END) AS managers_count,
       SUM(CASE WHEN role_id = 3 THEN 1 ELSE 0 END) AS admins_count
FROM dbo.users";

        using (SqlCommand command = new(usersSummarySql, connection))
        using (SqlDataReader reader = command.ExecuteReader())
        {
            if (reader.Read())
            {
                analytics.TotalUsers = reader.GetInt32(0);
                analytics.UsersCount = reader.GetInt32(1);
                analytics.ManagersCount = reader.GetInt32(2);
                analytics.AdminsCount = reader.GetInt32(3);
            }
        }

        return analytics;
    }

    private static BitmapImage? ToBitmapImage(byte[]? bytes)
    {
        if (bytes is null || bytes.Length == 0)
        {
            return null;
        }

        try
        {
            using MemoryStream stream = new(bytes);
            BitmapImage image = new();
            image.BeginInit();
            image.CacheOption = BitmapCacheOption.OnLoad;
            image.StreamSource = stream;
            image.EndInit();
            image.Freeze();
            return image;
        }
        catch
        {
            return null;
        }
    }
}

public sealed class AuthenticatedUser
{
    public int Id { get; init; }
    public string FullName { get; init; } = string.Empty;
    public string Email { get; init; } = string.Empty;
    public int RoleId { get; init; }
    public string RoleName { get; init; } = string.Empty;
    public bool IsBlocked { get; init; }

    public string RoleNameRu => RoleName switch
    {
        "Admin" => "Администратор",
        "Manager" => "Менеджер",
        _ => "Пользователь"
    };
}

public sealed class UserManagementItem
{
    public int Id { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public int RoleId { get; set; }
    public string RoleName { get; set; } = string.Empty;
    public bool IsBlocked { get; set; }

    public string RoleNameRu
    {
        get => RoleName switch
        {
            "Admin" => "Администратор",
            "Manager" => "Менеджер",
            _ => "Пользователь"
        };
        set => RoleName = value;
    }
}

public sealed class AdminAnalytics
{
    public int TotalTrips { get; set; }
    public List<CategoryStat> TripsByDifficulty { get; } = [];
    public List<TopTripItem> TopTrips { get; } = [];
    public int TotalUsers { get; set; }
    public int UsersCount { get; set; }
    public int ManagersCount { get; set; }
    public int AdminsCount { get; set; }
}

public sealed class CategoryStat
{
    public string Name { get; set; } = string.Empty;
    public int Count { get; set; }
}

public sealed class TopTripItem
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
}

public sealed class TripCatalogItem
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime StartDate { get; set; } = DateTime.Today;
    public DateTime EndDate { get; set; } = DateTime.Today;
    public decimal? BudgetValue { get; set; }
    public byte[]? ImageBytes { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Budget { get; set; } = string.Empty;
    public string Duration { get; set; } = string.Empty;
    public string Difficulty { get; set; } = string.Empty;
    public int Rating { get; set; }
    public BitmapImage? Image { get; set; }
}
