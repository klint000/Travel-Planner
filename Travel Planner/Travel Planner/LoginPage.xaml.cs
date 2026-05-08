using System;
using System.Windows;

namespace Travel_Planner;

public partial class LoginPage : Window
{
    public LoginPage()
    {
        InitializeComponent();
    }

    private void LoginButton_Click(object sender, RoutedEventArgs e)
    {
        string login = LoginTextBox.Text.Trim();
        string password = PasswordBox.Password;

        if (string.IsNullOrWhiteSpace(login) || string.IsNullOrWhiteSpace(password))
        {
            MessageBox.Show("Введите логин/email и пароль.", "Вход", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        try
        {
            AuthenticatedUser? user = DatabaseService.AuthenticateUser(login, password);
            if (user is null)
            {
                MessageBox.Show("Неверный логин/email или пароль.", "Вход", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (user.IsBlocked)
            {
                MessageBox.Show("Учетная запись заблокирована администратором.", "Вход запрещен", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            UserSession.SetCurrentUser(user);

            MessageBox.Show($"Вход выполнен успешно. Роль: {user.RoleNameRu}.", "Вход", MessageBoxButton.OK, MessageBoxImage.Information);
            CatalogPage catalogPage = new();
            catalogPage.Show();
            Close();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка при входе: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void OpenRegistrationButton_Click(object sender, RoutedEventArgs e)
    {
        RegistrationPage registrationPage = new();
        registrationPage.Show();
        Close();
    }
}
