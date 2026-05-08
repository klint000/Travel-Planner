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
            bool isValid = DatabaseService.ValidateUserCredentials(login, password);
            if (!isValid)
            {
                MessageBox.Show("Неверный логин/email или пароль.", "Вход", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            MessageBox.Show("Вход выполнен успешно.", "Вход", MessageBoxButton.OK, MessageBoxImage.Information);
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
