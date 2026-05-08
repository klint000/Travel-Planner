using System;
using System.Windows;

namespace Travel_Planner;

public partial class RegistrationPage : Window
{
    public RegistrationPage()
    {
        InitializeComponent();
    }

    private void RegisterButton_Click(object sender, RoutedEventArgs e)
    {
        string fullName = FullNameTextBox.Text.Trim();
        string email = EmailTextBox.Text.Trim();
        string username = UsernameTextBox.Text.Trim();
        string password = PasswordBox.Password;
        string confirmPassword = ConfirmPasswordBox.Password;

        if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
        {
            MessageBox.Show("Заполните все обязательные поля.", "Регистрация", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        if (password != confirmPassword)
        {
            MessageBox.Show("Пароли не совпадают.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        try
        {
            if (DatabaseService.UserExists(username, email))
            {
                MessageBox.Show("Пользователь с таким логином или email уже существует.", "Регистрация", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            DatabaseService.RegisterUser(username, email, password);
            MessageBox.Show("Регистрация успешно выполнена.", "Регистрация", MessageBoxButton.OK, MessageBoxImage.Information);

            CatalogPage catalogPage = new();
            catalogPage.Show();
            Close();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка регистрации: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void BackToLoginButton_Click(object sender, RoutedEventArgs e)
    {
        LoginPage loginPage = new();
        loginPage.Show();
        Close();
    }
}
