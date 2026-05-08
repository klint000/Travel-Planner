namespace Travel_Planner;

public static class UserSession
{
    public static AuthenticatedUser? CurrentUser { get; private set; }

    public static bool IsAuthenticated => CurrentUser is not null;
    public static bool IsManagerOrAdmin => CurrentUser?.RoleName is "Manager" or "Admin";
    public static bool IsAdmin => CurrentUser?.RoleName == "Admin";

    public static void SetCurrentUser(AuthenticatedUser user)
    {
        CurrentUser = user;
    }

    public static void Logout()
    {
        CurrentUser = null;
    }
}
