using System;
using System.Windows.Media.Imaging;
using System.Windows;
using System.Windows.Controls;

namespace Travel_Planner;

public partial class CatalogPage : Window
{
    public CatalogPage()
    {
        InitializeComponent();

        if (!UserSession.IsAuthenticated)
        {
            LoginPage loginPage = new();
            loginPage.Show();
            Close();
            return;
        }

        ApplyRoleVisibility();
        LoadCatalog();
    }

    private void ApplyRoleVisibility()
    {
        bool canManage = UserSession.IsManagerOrAdmin;

        AddButton.Visibility = canManage ? Visibility.Visible : Visibility.Collapsed;
        EditButton.Visibility = canManage ? Visibility.Visible : Visibility.Collapsed;
        DeleteButton.Visibility = canManage ? Visibility.Visible : Visibility.Collapsed;
        AdminPanelButton.Visibility = UserSession.IsAdmin ? Visibility.Visible : Visibility.Collapsed;

        string roleLabel = UserSession.CurrentUser?.RoleNameRu ?? "Пользователь";
        HeaderTextBlock.Text = $"Каталог поездок ({roleLabel})";
    }

    private void LoadCatalog()
    {
        try
        {
            BitmapImage placeholderImage = new(new Uri("pack://application:,,,/Assets/logo.png", UriKind.Absolute));
            string search = SearchTextBox?.Text?.Trim() ?? string.Empty;
            string difficulty = (DifficultyFilterComboBox?.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "Все";
            string sortField = (SortFieldComboBox?.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "Название";
            string direction = (SortDirectionComboBox?.SelectedItem as ComboBoxItem)?.Content?.ToString() ?? "По возрастанию";
            bool sortDescending = direction == "По убыванию";

            var items = DatabaseService.GetTripCatalogItems(search, difficulty, sortField, sortDescending);

            foreach (TripCatalogItem item in items)
            {
                item.Image ??= placeholderImage;
            }

            CatalogListView.ItemsSource = items;
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка загрузки каталога: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void LogoutButton_Click(object sender, RoutedEventArgs e)
    {
        UserSession.Logout();
        LoginPage loginPage = new();
        loginPage.Show();
        Close();
    }

    private void AdminPanelButton_Click(object sender, RoutedEventArgs e)
    {
        AdminPanelPage adminPage = new();
        adminPage.ShowDialog();
    }

    private bool EnsureManagerAccess()
    {
        if (UserSession.IsManagerOrAdmin)
        {
            return true;
        }

        MessageBox.Show("Недостаточно прав для выполнения операции.", "Доступ запрещен", MessageBoxButton.OK, MessageBoxImage.Warning);
        return false;
    }

    private void AddButton_Click(object sender, RoutedEventArgs e)
    {
        if (!EnsureManagerAccess())
        {
            return;
        }

        AddEditPage page = new();
        if (page.ShowDialog() == true)
        {
            LoadCatalog();
        }
    }

    private void EditButton_Click(object sender, RoutedEventArgs e)
    {
        if (!EnsureManagerAccess())
        {
            return;
        }

        if (CatalogListView.SelectedItem is not TripCatalogItem selectedItem)
        {
            MessageBox.Show("Выберите запись для редактирования.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Information);
            return;
        }

        var dbItem = DatabaseService.GetTripById(selectedItem.Id);
        if (dbItem is null)
        {
            MessageBox.Show("Запись не найдена.", "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            return;
        }

        AddEditPage page = new(dbItem);
        if (page.ShowDialog() == true)
        {
            LoadCatalog();
        }
    }

    private void DeleteButton_Click(object sender, RoutedEventArgs e)
    {
        if (!EnsureManagerAccess())
        {
            return;
        }

        if (CatalogListView.SelectedItem is not TripCatalogItem selectedItem)
        {
            MessageBox.Show("Выберите запись для удаления.", "Внимание", MessageBoxButton.OK, MessageBoxImage.Information);
            return;
        }

        MessageBoxResult result = MessageBox.Show(
            $"Удалить запись \"{selectedItem.Title}\"?",
            "Подтверждение удаления",
            MessageBoxButton.YesNo,
            MessageBoxImage.Warning);

        if (result != MessageBoxResult.Yes)
        {
            return;
        }

        try
        {
            DatabaseService.DeleteTrip(selectedItem.Id);
            LoadCatalog();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка удаления: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private void FilterOrSortChanged(object sender, RoutedEventArgs e)
    {
        if (!IsLoaded)
        {
            return;
        }

        LoadCatalog();
    }
}
