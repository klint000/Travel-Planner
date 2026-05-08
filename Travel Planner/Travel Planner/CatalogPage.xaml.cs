using System;
using System.Windows.Media.Imaging;
using System.Windows;

namespace Travel_Planner;

public partial class CatalogPage : Window
{
    public CatalogPage()
    {
        InitializeComponent();
        LoadCatalog();
    }

    private void LoadCatalog()
    {
        try
        {
            BitmapImage placeholderImage = new(new Uri("pack://application:,,,/Assets/logo.png", UriKind.Absolute));
            var items = DatabaseService.GetTripCatalogItems();

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
        LoginPage loginPage = new();
        loginPage.Show();
        Close();
    }
}
