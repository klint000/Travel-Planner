using Microsoft.Win32;
using System;
using System.Globalization;
using System.IO;
using System.Windows;
using System.Windows.Media.Imaging;

namespace Travel_Planner;

public partial class AddEditPage : Window
{
    private readonly bool _isEditMode;
    private readonly int _tripId;
    private byte[]? _imageBytes;

    public AddEditPage()
    {
        InitializeComponent();
        UserIdTextBox.Text = "1";
        StartDatePicker.SelectedDate = DateTime.Today;
        EndDatePicker.SelectedDate = DateTime.Today;
    }

    public AddEditPage(TripCatalogItem item) : this()
    {
        _isEditMode = true;
        _tripId = item.Id;
        TitleTextBlock.Text = "Редактирование записи";
        UserIdTextBox.Text = item.UserId.ToString(CultureInfo.InvariantCulture);
        NameTextBox.Text = item.Name;
        StartDatePicker.SelectedDate = item.StartDate;
        EndDatePicker.SelectedDate = item.EndDate;
        BudgetTextBox.Text = item.BudgetValue?.ToString("0.##", CultureInfo.InvariantCulture) ?? string.Empty;
        _imageBytes = item.ImageBytes;
        if (_imageBytes is not null)
        {
            PreviewImage.Source = ToBitmapImage(_imageBytes);
        }
    }

    private void UploadImageButton_Click(object sender, RoutedEventArgs e)
    {
        OpenFileDialog dialog = new()
        {
            Filter = "Изображения|*.png;*.jpg;*.jpeg;*.bmp;*.gif",
            Multiselect = false
        };

        if (dialog.ShowDialog() != true)
        {
            return;
        }

        _imageBytes = File.ReadAllBytes(dialog.FileName);
        PreviewImage.Source = ToBitmapImage(_imageBytes);
    }

    private void ClearImageButton_Click(object sender, RoutedEventArgs e)
    {
        _imageBytes = null;
        PreviewImage.Source = null;
    }

    private void SaveButton_Click(object sender, RoutedEventArgs e)
    {
        if (!ValidateInput(out int userId, out DateTime startDate, out DateTime endDate, out decimal? budget))
        {
            return;
        }

        try
        {
            TripCatalogItem item = new()
            {
                Id = _tripId,
                UserId = userId,
                Name = NameTextBox.Text.Trim(),
                StartDate = startDate,
                EndDate = endDate,
                BudgetValue = budget,
                ImageBytes = _imageBytes
            };

            if (_isEditMode)
            {
                DatabaseService.UpdateTrip(item);
            }
            else
            {
                DatabaseService.AddTrip(item);
            }

            DialogResult = true;
            Close();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Ошибка сохранения: {ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }

    private bool ValidateInput(out int userId, out DateTime startDate, out DateTime endDate, out decimal? budget)
    {
        userId = 0;
        startDate = DateTime.Today;
        endDate = DateTime.Today;
        budget = null;

        if (!int.TryParse(UserIdTextBox.Text.Trim(), out userId) || userId <= 0)
        {
            MessageBox.Show("Введите корректный ID пользователя.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        if (string.IsNullOrWhiteSpace(NameTextBox.Text))
        {
            MessageBox.Show("Поле \"Название\" обязательно.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        if (StartDatePicker.SelectedDate is null || EndDatePicker.SelectedDate is null)
        {
            MessageBox.Show("Укажите даты начала и окончания.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        startDate = StartDatePicker.SelectedDate.Value;
        endDate = EndDatePicker.SelectedDate.Value;

        if (endDate < startDate)
        {
            MessageBox.Show("Дата окончания не может быть раньше даты начала.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        string budgetText = BudgetTextBox.Text.Trim();
        if (!string.IsNullOrWhiteSpace(budgetText))
        {
            if (!decimal.TryParse(budgetText, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal parsedBudget) && 
                !decimal.TryParse(budgetText, NumberStyles.Number, CultureInfo.CurrentCulture, out parsedBudget))
            {
                MessageBox.Show("Бюджет должен быть числом.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
                return false;
            }

            if (parsedBudget < 0)
            {
                MessageBox.Show("Бюджет не может быть отрицательным.", "Проверка данных", MessageBoxButton.OK, MessageBoxImage.Warning);
                return false;
            }

            budget = parsedBudget;
        }

        return true;
    }

    private void CancelButton_Click(object sender, RoutedEventArgs e)
    {
        DialogResult = false;
        Close();
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
