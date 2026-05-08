using System.Security.Cryptography;

namespace Travel_Planner;

public static class PasswordHasher
{
    public static byte[] HashPassword(string password, byte[] salt)
    {
        return Rfc2898DeriveBytes.Pbkdf2(password, salt, 100_000, HashAlgorithmName.SHA256, 32);
    }
}
