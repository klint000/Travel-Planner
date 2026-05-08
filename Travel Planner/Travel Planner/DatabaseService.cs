using System;
using System.Collections.Generic;
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

    public static void RegisterUser(string username, string email, string password)
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
        }
        catch
        {
            transaction.Rollback();
            throw;
        }
    }

    public static bool ValidateUserCredentials(string loginOrEmail, string password)
    {
        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
SELECT c.password_salt, c.password_hash
FROM dbo.users u
INNER JOIN dbo.user_credentials c ON u.id = c.user_id
WHERE u.username = @login OR u.email = @login";

        using SqlCommand command = new(sql, connection);
        command.Parameters.AddWithValue("@login", loginOrEmail);

        using SqlDataReader reader = command.ExecuteReader();
        if (!reader.Read())
        {
            return false;
        }

        byte[] salt = (byte[])reader["password_salt"];
        byte[] storedHash = (byte[])reader["password_hash"];
        byte[] candidateHash = PasswordHasher.HashPassword(password, salt);

        return CryptographicOperations.FixedTimeEquals(storedHash, candidateHash);
    }

    public static List<TripCatalogItem> GetTripCatalogItems()
    {
        List<TripCatalogItem> items = [];

        using SqlConnection connection = new(ConnectionString);
        connection.Open();

        const string sql = @"
SELECT TOP (200) id, name, start_date, end_date, budget, image
FROM dbo.trips
ORDER BY start_date DESC, id DESC";

        using SqlCommand command = new(sql, connection);
        using SqlDataReader reader = command.ExecuteReader();

        while (reader.Read())
        {
            int id = reader.GetInt32(0);
            string name = reader.GetString(1);
            DateTime startDate = reader.GetDateTime(2);
            DateTime endDate = reader.GetDateTime(3);
            decimal? budget = reader.IsDBNull(4) ? null : reader.GetDecimal(4);
            byte[]? imageBytes = reader.IsDBNull(5) ? null : (byte[])reader[5];

            int durationDays = Math.Max(1, (endDate - startDate).Days + 1);
            string durationText = $"{durationDays} дн.";
            string budgetText = budget.HasValue ? $"{budget.Value:N0} ₽" : "Бюджет не указан";
            string difficulty = durationDays switch
            {
                <= 3 => "Легко",
                <= 7 => "Средне",
                _ => "Сложно"
            };

            items.Add(new TripCatalogItem
            {
                Id = id,
                Title = name,
                Description = $"{startDate:dd.MM.yyyy} - {endDate:dd.MM.yyyy}",
                Budget = budgetText,
                Duration = durationText,
                Difficulty = difficulty,
                Rating = Math.Min(5, Math.Max(1, (durationDays + 1) / 2)),
                Image = ToBitmapImage(imageBytes)
            });
        }

        return items;
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

public sealed class TripCatalogItem
{
    public int Id { get; init; }
    public string Title { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
    public string Budget { get; init; } = string.Empty;
    public string Duration { get; init; } = string.Empty;
    public string Difficulty { get; init; } = string.Empty;
    public int Rating { get; init; }
    public BitmapImage? Image { get; set; }
}
