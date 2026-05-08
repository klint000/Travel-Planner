using System;
using System.Windows;
using System.Windows.Controls;

namespace Travel_Planner;

public partial class AdminPanelPage : Window
{
    public AdminPanelPage()
    {
        InitializeComponent();

        if (!UserSession.IsAdmin)
        {
            MessageBox.Show("Доступ к админ-панели разрешен только администраторам.", "Доступ запрещен", MessageBoxButton.OK, MessageBoxImage.Warning);
            Close();
            return;
        }

        LoadUsers();
        LoadAnalytics();
    }

    private void LoadUsers()
    {
        try
        {
            string search = UserSearchTextBox.Text.Trim();
            UsersDataGrid.ItemsSource = DatabaseService.GetUsersForAdmin(search);
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка загрузки пользователей: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void LoadAnalytics()
    {
        try
        {
            AdminAnalytics analytics = DatabaseService.GetAdminAnalytics();
            TotalTripsTextBlock.Text = $"Общее количество поездок: {analytics.TotalTrips}";
            CategoryStatsListView.ItemsSource = analytics.TripsByDifficulty;
            TopTripsListView.ItemsSource = analytics.TopTrips;
            UserStatsTextBlock.Text =
                $"Всего зарегистрировано пользователей: {analytics.TotalUsers}\n" +
                $"Пользователи: {analytics.UsersCount}\n" +
                $"Менеджеры: {analytics.ManagersCount}\n" +
                $"Администраторы: {analytics.AdminsCount}";
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка загрузки аналитики: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private UserManagementItem? GetSelectedUser()
    {
        if (UsersDataGrid.SelectedItem is UserManagementItem user)
        {
            return user;
        }

        MessageBox.Show("Выберите пользователя в таблице.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Information);
        return null;
    }

    private void UserSearchTextBox_TextChanged(object sender, TextChangedEventArgs e)
    {
        if (!IsLoaded)
        {
            return;
        }

        LoadUsers();
    }

    private void RefreshUsersButton_Click(object sender, RoutedEventArgs e)
    {
        LoadUsers();
        LoadAnalytics();
    }

    private void ApplyRoleButton_Click(object sender, RoutedEventArgs e)
    {
        UserManagementItem? selectedUser = GetSelectedUser();
        if (selectedUser is null)
        {
            return;
        }

        if (RoleComboBox.SelectedItem is not ComboBoxItem comboItem || comboItem.Tag is null)
        {
            return;
        }

        int newRoleId = Convert.ToInt32(comboItem.Tag);

        try
        {
            DatabaseService.UpdateUserRole(selectedUser.Id, newRoleId);
            LoadUsers();
            LoadAnalytics();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка изменения роли: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void ToggleBlockButton_Click(object sender, RoutedEventArgs e)
    {
        UserManagementItem? selectedUser = GetSelectedUser();
        if (selectedUser is null)
        {
            return;
        }

        bool newBlockedState = !selectedUser.IsBlocked;
        try
        {
            DatabaseService.SetUserBlocked(selectedUser.Id, newBlockedState);
            LoadUsers();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка изменения блокировки: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}
