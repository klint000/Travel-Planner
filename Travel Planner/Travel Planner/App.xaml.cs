using System;
using System.Windows;

namespace Travel_Planner;

public partial class App : Application
{
    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);

        try
        {
            DatabaseService.Initialize();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Не удалось подключиться к БД travel_planner.\\n{ex.Message}", "Ошибка БД", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}
