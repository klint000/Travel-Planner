using System;
using Microsoft.Data.SqlClient;
using System.Security.Cryptography;

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
}
