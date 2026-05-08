USE [master]
GO
/****** Object:  Database [travel_planner]    Script Date: 08.05.2026 15:17:12 ******/
CREATE DATABASE [travel_planner]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'travel_planner', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\travel_planner.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'travel_planner_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\travel_planner_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [travel_planner] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [travel_planner].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [travel_planner] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [travel_planner] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [travel_planner] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [travel_planner] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [travel_planner] SET ARITHABORT OFF 
GO
ALTER DATABASE [travel_planner] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [travel_planner] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [travel_planner] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [travel_planner] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [travel_planner] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [travel_planner] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [travel_planner] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [travel_planner] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [travel_planner] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [travel_planner] SET  ENABLE_BROKER 
GO
ALTER DATABASE [travel_planner] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [travel_planner] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [travel_planner] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [travel_planner] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [travel_planner] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [travel_planner] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [travel_planner] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [travel_planner] SET RECOVERY FULL 
GO
ALTER DATABASE [travel_planner] SET  MULTI_USER 
GO
ALTER DATABASE [travel_planner] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [travel_planner] SET DB_CHAINING OFF 
GO
ALTER DATABASE [travel_planner] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [travel_planner] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [travel_planner] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [travel_planner] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [travel_planner] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [travel_planner] SET QUERY_STORE = ON
GO
ALTER DATABASE [travel_planner] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [travel_planner]
GO
/****** Object:  Table [dbo].[users]    Script Date: 08.05.2026 15:17:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](100) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[role_id] [int] NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trips]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trips](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
	[budget] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_user_trips]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================
-- 5. Создание представлений для разграничения доступа
-- =====================================================

-- Представление для пользователя (только свои поездки)
CREATE VIEW [dbo].[v_user_trips] AS
SELECT t.*, u.username as owner_name
FROM trips t
JOIN users u ON t.user_id = u.id;

GO
/****** Object:  Table [dbo].[expenses]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[expenses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[amount] [decimal](10, 2) NOT NULL,
	[expense_date] [date] NOT NULL,
	[description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_manager_stats]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Представление для менеджера (все поездки + статистика)
CREATE VIEW [dbo].[v_manager_stats] AS
SELECT 
    u.id as user_id,
    u.username,
    COUNT(DISTINCT t.id) as total_trips,
    ISNULL(SUM(e.amount), 0) as total_expenses,
    ISNULL(AVG(t.budget), 0) as avg_budget
FROM users u
LEFT JOIN trips t ON u.id = t.user_id
LEFT JOIN expenses e ON t.id = e.trip_id
GROUP BY u.id, u.username;

GO
/****** Object:  Table [dbo].[attractions]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[attractions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](200) NOT NULL,
	[city] [nvarchar](100) NULL,
	[country] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[booking_statuses]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[booking_statuses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[booking_types]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[booking_types](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bookings]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bookings](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[booking_type_id] [int] NOT NULL,
	[status_id] [int] NOT NULL,
	[title] [nvarchar](200) NOT NULL,
	[price] [decimal](10, 2) NULL,
	[booking_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[documents]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[documents](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[doc_type] [nvarchar](50) NULL,
	[doc_number] [nvarchar](100) NULL,
	[expiry_date] [date] NULL,
	[file_path] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[expense_categories]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[expense_categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roles]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[route_items]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[route_items](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[route_id] [int] NOT NULL,
	[attraction_id] [int] NOT NULL,
	[order_index] [int] NOT NULL,
	[planned_time] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[routes]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[routes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[day_number] [int] NOT NULL,
	[date] [date] NOT NULL,
	[notes] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[travel_notes]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[travel_notes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[trip_id] [int] NOT NULL,
	[note_date] [datetime] NULL,
	[content] [nvarchar](max) NULL,
	[photo_path] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[attractions] ON 
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (1, N'Эйфелева башня', N'Париж', N'Франция')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (2, N'Лувр', N'Париж', N'Франция')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (3, N'Колизей', N'Рим', N'Италия')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (4, N'Собор Святого Петра', N'Ватикан', N'Ватикан')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (5, N'Биг Бен', N'Лондон', N'Великобритания')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (6, N'Тауэр', N'Лондон', N'Великобритания')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (7, N'Бранденбургские ворота', N'Берлин', N'Германия')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (8, N'Саграда Фамилия', N'Барселона', N'Испания')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (9, N'Альгамбра', N'Гранада', N'Испания')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (10, N'Красная площадь', N'Москва', N'Россия')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (11, N'Эрмитаж', N'Санкт-Петербург', N'Россия')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (12, N'Статуя Свободы', N'Нью-Йорк', N'США')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (13, N'Гранд Каньон', N'Аризона', N'США')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (14, N'Мачу-Пикчу', N'Куско', N'Перу')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (15, N'Петра', N'Маан', N'Иордания')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (16, N'Тадж-Махал', N'Агра', N'Индия')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (17, N'Бурдж-Халифа', N'Дубай', N'ОАЭ')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (18, N'Опера Сиднея', N'Сидней', N'Австралия')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (19, N'Фудзияма', N'Токио', N'Япония')
GO
INSERT [dbo].[attractions] ([id], [name], [city], [country]) VALUES (20, N'Великая Китайская стена', N'Пекин', N'Китай')
GO
SET IDENTITY_INSERT [dbo].[attractions] OFF
GO
SET IDENTITY_INSERT [dbo].[booking_statuses] ON 
GO
INSERT [dbo].[booking_statuses] ([id], [name]) VALUES (4, N'Завершено')
GO
INSERT [dbo].[booking_statuses] ([id], [name]) VALUES (1, N'Ожидание')
GO
INSERT [dbo].[booking_statuses] ([id], [name]) VALUES (3, N'Отменено')
GO
INSERT [dbo].[booking_statuses] ([id], [name]) VALUES (2, N'Подтверждено')
GO
SET IDENTITY_INSERT [dbo].[booking_statuses] OFF
GO
SET IDENTITY_INSERT [dbo].[booking_types] ON 
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (2, N'Авиабилет')
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (5, N'Аренда авто')
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (7, N'Другое')
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (1, N'Отель')
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (3, N'Поезд')
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (6, N'Ресторан')
GO
INSERT [dbo].[booking_types] ([id], [name]) VALUES (4, N'Экскурсия')
GO
SET IDENTITY_INSERT [dbo].[booking_types] OFF
GO
SET IDENTITY_INSERT [dbo].[bookings] ON 
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (1, 1, 1, 1, N'Бронирование для Путешествие в Дубай #1', CAST(749.00 AS Decimal(10, 2)), CAST(N'2023-10-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (2, 2, 5, 1, N'Бронирование для Путешествие в Москву #2', CAST(213.00 AS Decimal(10, 2)), CAST(N'2023-02-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (3, 3, 1, 3, N'Бронирование для Путешествие в Токио #3', CAST(719.00 AS Decimal(10, 2)), CAST(N'2023-11-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (4, 4, 7, 2, N'Бронирование для Путешествие в Барселону #4', CAST(156.00 AS Decimal(10, 2)), CAST(N'2023-12-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (5, 5, 6, 3, N'Бронирование для Путешествие в  #5', CAST(916.00 AS Decimal(10, 2)), CAST(N'2024-05-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (6, 6, 2, 2, N'Бронирование для Путешествие в Париж #6', CAST(732.00 AS Decimal(10, 2)), CAST(N'2023-09-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (7, 7, 1, 4, N'Бронирование для Путешествие в  #7', CAST(1007.00 AS Decimal(10, 2)), CAST(N'2023-02-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (8, 8, 1, 2, N'Бронирование для Путешествие в  #8', CAST(387.00 AS Decimal(10, 2)), CAST(N'2024-06-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (9, 9, 5, 3, N'Бронирование для Путешествие в Париж #9', CAST(901.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (10, 10, 3, 2, N'Бронирование для Путешествие в Лондон #10', CAST(521.00 AS Decimal(10, 2)), CAST(N'2024-03-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (11, 11, 3, 4, N'Бронирование для Путешествие в Берлин #11', CAST(947.00 AS Decimal(10, 2)), CAST(N'2023-04-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (12, 12, 4, 4, N'Бронирование для Путешествие в Дубай #12', CAST(563.00 AS Decimal(10, 2)), CAST(N'2024-11-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (13, 13, 4, 2, N'Бронирование для Путешествие в  #13', CAST(299.00 AS Decimal(10, 2)), CAST(N'2023-12-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (14, 14, 6, 3, N'Бронирование для Путешествие в  #14', CAST(711.00 AS Decimal(10, 2)), CAST(N'2023-01-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (15, 15, 6, 4, N'Бронирование для Путешествие в Барселону #15', CAST(903.00 AS Decimal(10, 2)), CAST(N'2023-06-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (16, 16, 1, 1, N'Бронирование для Путешествие в Берлин #16', CAST(234.00 AS Decimal(10, 2)), CAST(N'2024-03-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (17, 17, 6, 3, N'Бронирование для Путешествие в Дубай #17', CAST(839.00 AS Decimal(10, 2)), CAST(N'2024-12-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (18, 18, 1, 2, N'Бронирование для Путешествие в Пекин #18', CAST(981.00 AS Decimal(10, 2)), CAST(N'2023-05-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (19, 19, 1, 2, N'Бронирование для Путешествие в Лондон #19', CAST(330.00 AS Decimal(10, 2)), CAST(N'2023-09-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (20, 20, 6, 2, N'Бронирование для Путешествие в Нью-Йорк #20', CAST(454.00 AS Decimal(10, 2)), CAST(N'2023-08-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (21, 21, 5, 3, N'Бронирование для Путешествие в Лондон #21', CAST(1006.00 AS Decimal(10, 2)), CAST(N'2023-05-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (22, 22, 2, 3, N'Бронирование для Путешествие в  #22', CAST(451.00 AS Decimal(10, 2)), CAST(N'2023-06-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (23, 23, 7, 2, N'Бронирование для Путешествие в Рим #23', CAST(383.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (24, 24, 7, 1, N'Бронирование для Путешествие в  #24', CAST(71.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (25, 25, 7, 1, N'Бронирование для Путешествие в Париж #25', CAST(945.00 AS Decimal(10, 2)), CAST(N'2023-02-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (26, 26, 5, 4, N'Бронирование для Путешествие в Берлин #26', CAST(418.00 AS Decimal(10, 2)), CAST(N'2024-05-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (27, 27, 5, 1, N'Бронирование для Путешествие в Париж #27', CAST(668.00 AS Decimal(10, 2)), CAST(N'2023-03-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (28, 28, 6, 4, N'Бронирование для Путешествие в  #28', CAST(252.00 AS Decimal(10, 2)), CAST(N'2024-01-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (29, 29, 4, 4, N'Бронирование для Путешествие в  #29', CAST(64.00 AS Decimal(10, 2)), CAST(N'2023-09-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (30, 30, 4, 1, N'Бронирование для Путешествие в Лондон #30', CAST(274.00 AS Decimal(10, 2)), CAST(N'2024-08-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (31, 31, 2, 2, N'Бронирование для Путешествие в  #31', CAST(270.00 AS Decimal(10, 2)), CAST(N'2023-02-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (32, 32, 3, 4, N'Бронирование для Путешествие в Рим #32', CAST(781.00 AS Decimal(10, 2)), CAST(N'2024-10-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (33, 33, 4, 4, N'Бронирование для Путешествие в Париж #33', CAST(143.00 AS Decimal(10, 2)), CAST(N'2023-07-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (34, 34, 2, 3, N'Бронирование для Путешествие в Барселону #34', CAST(633.00 AS Decimal(10, 2)), CAST(N'2023-08-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (35, 35, 3, 2, N'Бронирование для Путешествие в Рим #35', CAST(125.00 AS Decimal(10, 2)), CAST(N'2024-06-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (36, 36, 6, 4, N'Бронирование для Путешествие в  #36', CAST(51.00 AS Decimal(10, 2)), CAST(N'2024-10-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (37, 37, 2, 4, N'Бронирование для Путешествие в Париж #37', CAST(167.00 AS Decimal(10, 2)), CAST(N'2023-12-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (38, 38, 1, 4, N'Бронирование для Путешествие в Нью-Йорк #38', CAST(678.00 AS Decimal(10, 2)), CAST(N'2024-10-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (39, 39, 6, 4, N'Бронирование для Путешествие в  #39', CAST(964.00 AS Decimal(10, 2)), CAST(N'2024-08-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (40, 40, 3, 3, N'Бронирование для Путешествие в  #40', CAST(805.00 AS Decimal(10, 2)), CAST(N'2023-10-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (41, 41, 7, 3, N'Бронирование для Путешествие в  #41', CAST(880.00 AS Decimal(10, 2)), CAST(N'2024-11-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (42, 42, 2, 4, N'Бронирование для Путешествие в Дубай #42', CAST(632.00 AS Decimal(10, 2)), CAST(N'2023-07-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (43, 43, 6, 3, N'Бронирование для Путешествие в Пекин #43', CAST(494.00 AS Decimal(10, 2)), CAST(N'2024-12-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (44, 44, 3, 1, N'Бронирование для Путешествие в  #44', CAST(1000.00 AS Decimal(10, 2)), CAST(N'2023-10-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (45, 45, 6, 4, N'Бронирование для Путешествие в Нью-Йорк #45', CAST(839.00 AS Decimal(10, 2)), CAST(N'2024-06-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (46, 46, 2, 2, N'Бронирование для Путешествие в  #46', CAST(833.00 AS Decimal(10, 2)), CAST(N'2023-11-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (47, 47, 4, 3, N'Бронирование для Путешествие в Лондон #47', CAST(1048.00 AS Decimal(10, 2)), CAST(N'2024-06-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (48, 48, 7, 3, N'Бронирование для Путешествие в Нью-Йорк #48', CAST(145.00 AS Decimal(10, 2)), CAST(N'2023-02-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (49, 49, 4, 2, N'Бронирование для Путешествие в Лондон #49', CAST(963.00 AS Decimal(10, 2)), CAST(N'2024-08-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (50, 50, 4, 2, N'Бронирование для Путешествие в Берлин #50', CAST(301.00 AS Decimal(10, 2)), CAST(N'2023-10-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (51, 51, 2, 3, N'Бронирование для Путешествие в Токио #51', CAST(510.00 AS Decimal(10, 2)), CAST(N'2024-05-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (52, 52, 1, 1, N'Бронирование для Путешествие в  #52', CAST(524.00 AS Decimal(10, 2)), CAST(N'2023-05-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (53, 53, 6, 2, N'Бронирование для Путешествие в  #53', CAST(605.00 AS Decimal(10, 2)), CAST(N'2024-03-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (54, 54, 2, 3, N'Бронирование для Путешествие в  #54', CAST(812.00 AS Decimal(10, 2)), CAST(N'2024-07-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (55, 55, 1, 4, N'Бронирование для Путешествие в Нью-Йорк #55', CAST(305.00 AS Decimal(10, 2)), CAST(N'2023-12-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (56, 56, 6, 3, N'Бронирование для Путешествие в Пекин #56', CAST(109.00 AS Decimal(10, 2)), CAST(N'2024-07-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (57, 57, 3, 3, N'Бронирование для Путешествие в  #57', CAST(205.00 AS Decimal(10, 2)), CAST(N'2023-02-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (58, 58, 3, 4, N'Бронирование для Путешествие в  #58', CAST(92.00 AS Decimal(10, 2)), CAST(N'2024-09-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (59, 59, 3, 4, N'Бронирование для Путешествие в Нью-Йорк #59', CAST(148.00 AS Decimal(10, 2)), CAST(N'2024-06-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (60, 60, 2, 2, N'Бронирование для Путешествие в Берлин #60', CAST(64.00 AS Decimal(10, 2)), CAST(N'2023-11-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (61, 61, 2, 2, N'Бронирование для Путешествие в Дубай #61', CAST(696.00 AS Decimal(10, 2)), CAST(N'2024-12-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (62, 62, 4, 2, N'Бронирование для Путешествие в Берлин #62', CAST(919.00 AS Decimal(10, 2)), CAST(N'2024-07-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (63, 63, 7, 3, N'Бронирование для Путешествие в Париж #63', CAST(953.00 AS Decimal(10, 2)), CAST(N'2024-06-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (64, 64, 3, 3, N'Бронирование для Путешествие в  #64', CAST(186.00 AS Decimal(10, 2)), CAST(N'2024-10-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (65, 65, 6, 3, N'Бронирование для Путешествие в Рим #65', CAST(608.00 AS Decimal(10, 2)), CAST(N'2023-12-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (66, 66, 5, 2, N'Бронирование для Путешествие в Париж #66', CAST(484.00 AS Decimal(10, 2)), CAST(N'2024-09-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (67, 67, 3, 2, N'Бронирование для Путешествие в Дубай #67', CAST(838.00 AS Decimal(10, 2)), CAST(N'2024-06-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (68, 68, 6, 4, N'Бронирование для Путешествие в  #68', CAST(59.00 AS Decimal(10, 2)), CAST(N'2023-05-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (69, 69, 4, 2, N'Бронирование для Путешествие в  #69', CAST(330.00 AS Decimal(10, 2)), CAST(N'2024-12-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (70, 70, 1, 1, N'Бронирование для Путешествие в  #70', CAST(426.00 AS Decimal(10, 2)), CAST(N'2023-02-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (71, 71, 5, 3, N'Бронирование для Путешествие в Берлин #71', CAST(646.00 AS Decimal(10, 2)), CAST(N'2023-04-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (72, 72, 4, 2, N'Бронирование для Путешествие в  #72', CAST(300.00 AS Decimal(10, 2)), CAST(N'2023-01-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (73, 73, 5, 3, N'Бронирование для Путешествие в Пекин #73', CAST(917.00 AS Decimal(10, 2)), CAST(N'2024-05-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (74, 74, 4, 3, N'Бронирование для Путешествие в  #74', CAST(610.00 AS Decimal(10, 2)), CAST(N'2024-10-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (75, 75, 7, 4, N'Бронирование для Путешествие в  #75', CAST(189.00 AS Decimal(10, 2)), CAST(N'2023-08-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (76, 76, 2, 1, N'Бронирование для Путешествие в Токио #76', CAST(1049.00 AS Decimal(10, 2)), CAST(N'2023-10-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (77, 77, 7, 3, N'Бронирование для Путешествие в  #77', CAST(677.00 AS Decimal(10, 2)), CAST(N'2023-07-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (78, 78, 2, 1, N'Бронирование для Путешествие в Лондон #78', CAST(706.00 AS Decimal(10, 2)), CAST(N'2024-11-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (79, 79, 7, 4, N'Бронирование для Путешествие в  #79', CAST(803.00 AS Decimal(10, 2)), CAST(N'2023-12-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (80, 80, 3, 2, N'Бронирование для Путешествие в  #80', CAST(332.00 AS Decimal(10, 2)), CAST(N'2023-05-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (81, 81, 3, 2, N'Бронирование для Путешествие в Нью-Йорк #81', CAST(656.00 AS Decimal(10, 2)), CAST(N'2024-06-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (82, 82, 3, 1, N'Бронирование для Путешествие в  #82', CAST(908.00 AS Decimal(10, 2)), CAST(N'2024-01-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (83, 83, 1, 1, N'Бронирование для Путешествие в Берлин #83', CAST(450.00 AS Decimal(10, 2)), CAST(N'2023-05-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (84, 84, 6, 2, N'Бронирование для Путешествие в Рим #84', CAST(1006.00 AS Decimal(10, 2)), CAST(N'2023-11-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (85, 85, 5, 3, N'Бронирование для Путешествие в  #85', CAST(952.00 AS Decimal(10, 2)), CAST(N'2024-02-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (86, 86, 1, 4, N'Бронирование для Путешествие в Дубай #86', CAST(714.00 AS Decimal(10, 2)), CAST(N'2023-05-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (87, 87, 3, 3, N'Бронирование для Путешествие в Лондон #87', CAST(656.00 AS Decimal(10, 2)), CAST(N'2023-10-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (88, 88, 4, 4, N'Бронирование для Путешествие в  #88', CAST(664.00 AS Decimal(10, 2)), CAST(N'2023-06-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (89, 89, 1, 4, N'Бронирование для Путешествие в  #89', CAST(884.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (90, 90, 7, 1, N'Бронирование для Путешествие в  #90', CAST(851.00 AS Decimal(10, 2)), CAST(N'2023-06-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (91, 91, 1, 1, N'Бронирование для Путешествие в  #91', CAST(606.00 AS Decimal(10, 2)), CAST(N'2023-09-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (92, 92, 5, 4, N'Бронирование для Путешествие в  #92', CAST(984.00 AS Decimal(10, 2)), CAST(N'2024-08-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (93, 93, 2, 4, N'Бронирование для Путешествие в Лондон #93', CAST(258.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (94, 94, 5, 2, N'Бронирование для Путешествие в Москву #94', CAST(363.00 AS Decimal(10, 2)), CAST(N'2023-07-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (95, 95, 7, 1, N'Бронирование для Путешествие в Нью-Йорк #95', CAST(174.00 AS Decimal(10, 2)), CAST(N'2024-03-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (96, 96, 4, 1, N'Бронирование для Путешествие в Берлин #96', CAST(793.00 AS Decimal(10, 2)), CAST(N'2024-06-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (97, 97, 7, 2, N'Бронирование для Путешествие в Лондон #97', CAST(759.00 AS Decimal(10, 2)), CAST(N'2024-10-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (98, 98, 5, 1, N'Бронирование для Путешествие в Пекин #98', CAST(252.00 AS Decimal(10, 2)), CAST(N'2023-11-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (99, 99, 6, 4, N'Бронирование для Путешествие в  #99', CAST(681.00 AS Decimal(10, 2)), CAST(N'2023-03-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (100, 100, 2, 4, N'Бронирование для Путешествие в  #100', CAST(688.00 AS Decimal(10, 2)), CAST(N'2023-02-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (101, 101, 4, 2, N'Бронирование для Путешествие в Дубай #101', CAST(830.00 AS Decimal(10, 2)), CAST(N'2024-01-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (102, 102, 1, 4, N'Бронирование для Путешествие в Нью-Йорк #102', CAST(524.00 AS Decimal(10, 2)), CAST(N'2023-01-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (103, 103, 2, 2, N'Бронирование для Путешествие в  #103', CAST(1020.00 AS Decimal(10, 2)), CAST(N'2023-08-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (104, 104, 2, 4, N'Бронирование для Путешествие в  #104', CAST(575.00 AS Decimal(10, 2)), CAST(N'2023-03-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (105, 105, 4, 1, N'Бронирование для Путешествие в Берлин #105', CAST(506.00 AS Decimal(10, 2)), CAST(N'2024-07-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (106, 106, 3, 2, N'Бронирование для Путешествие в  #106', CAST(853.00 AS Decimal(10, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (107, 107, 6, 2, N'Бронирование для Путешествие в Лондон #107', CAST(159.00 AS Decimal(10, 2)), CAST(N'2024-08-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (108, 108, 4, 3, N'Бронирование для Путешествие в Париж #108', CAST(627.00 AS Decimal(10, 2)), CAST(N'2024-06-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (109, 109, 4, 2, N'Бронирование для Путешествие в  #109', CAST(681.00 AS Decimal(10, 2)), CAST(N'2023-05-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (110, 110, 6, 1, N'Бронирование для Путешествие в  #110', CAST(198.00 AS Decimal(10, 2)), CAST(N'2022-12-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (111, 111, 3, 4, N'Бронирование для Путешествие в  #111', CAST(226.00 AS Decimal(10, 2)), CAST(N'2023-01-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (112, 112, 7, 4, N'Бронирование для Путешествие в Рим #112', CAST(473.00 AS Decimal(10, 2)), CAST(N'2024-10-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (113, 113, 5, 2, N'Бронирование для Путешествие в Дубай #113', CAST(285.00 AS Decimal(10, 2)), CAST(N'2023-05-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (114, 114, 2, 3, N'Бронирование для Путешествие в Париж #114', CAST(754.00 AS Decimal(10, 2)), CAST(N'2023-06-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (115, 115, 1, 4, N'Бронирование для Путешествие в Дубай #115', CAST(103.00 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (116, 116, 3, 4, N'Бронирование для Путешествие в  #116', CAST(540.00 AS Decimal(10, 2)), CAST(N'2023-06-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (117, 117, 7, 1, N'Бронирование для Путешествие в Барселону #117', CAST(979.00 AS Decimal(10, 2)), CAST(N'2024-01-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (118, 118, 4, 4, N'Бронирование для Путешествие в Лондон #118', CAST(302.00 AS Decimal(10, 2)), CAST(N'2023-07-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (119, 119, 4, 1, N'Бронирование для Путешествие в Нью-Йорк #119', CAST(851.00 AS Decimal(10, 2)), CAST(N'2023-11-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (120, 120, 3, 1, N'Бронирование для Путешествие в  #120', CAST(396.00 AS Decimal(10, 2)), CAST(N'2023-03-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (121, 1, 1, 4, N'Бронирование для Путешествие в Дубай #1', CAST(115.00 AS Decimal(10, 2)), CAST(N'2023-10-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (122, 2, 4, 4, N'Бронирование для Путешествие в Москву #2', CAST(276.00 AS Decimal(10, 2)), CAST(N'2023-02-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (123, 3, 7, 1, N'Бронирование для Путешествие в Токио #3', CAST(675.00 AS Decimal(10, 2)), CAST(N'2023-10-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (124, 4, 5, 1, N'Бронирование для Путешествие в Барселону #4', CAST(772.00 AS Decimal(10, 2)), CAST(N'2023-11-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (125, 5, 5, 4, N'Бронирование для Путешествие в  #5', CAST(214.00 AS Decimal(10, 2)), CAST(N'2024-04-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (126, 6, 6, 3, N'Бронирование для Путешествие в Париж #6', CAST(1021.00 AS Decimal(10, 2)), CAST(N'2023-10-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (127, 7, 3, 1, N'Бронирование для Путешествие в  #7', CAST(490.00 AS Decimal(10, 2)), CAST(N'2023-02-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (128, 8, 6, 2, N'Бронирование для Путешествие в  #8', CAST(704.00 AS Decimal(10, 2)), CAST(N'2024-06-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (129, 9, 3, 1, N'Бронирование для Путешествие в Париж #9', CAST(395.00 AS Decimal(10, 2)), CAST(N'2023-09-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (130, 10, 6, 2, N'Бронирование для Путешествие в Лондон #10', CAST(698.00 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (131, 11, 3, 3, N'Бронирование для Путешествие в Берлин #11', CAST(1013.00 AS Decimal(10, 2)), CAST(N'2023-05-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (132, 12, 4, 3, N'Бронирование для Путешествие в Дубай #12', CAST(130.00 AS Decimal(10, 2)), CAST(N'2024-11-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (133, 13, 6, 1, N'Бронирование для Путешествие в  #13', CAST(455.00 AS Decimal(10, 2)), CAST(N'2024-01-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (134, 14, 1, 4, N'Бронирование для Путешествие в  #14', CAST(469.00 AS Decimal(10, 2)), CAST(N'2023-01-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (135, 15, 4, 2, N'Бронирование для Путешествие в Барселону #15', CAST(409.00 AS Decimal(10, 2)), CAST(N'2023-06-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (136, 16, 5, 2, N'Бронирование для Путешествие в Берлин #16', CAST(329.00 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (137, 17, 3, 4, N'Бронирование для Путешествие в Дубай #17', CAST(297.00 AS Decimal(10, 2)), CAST(N'2024-12-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (138, 18, 2, 1, N'Бронирование для Путешествие в Пекин #18', CAST(178.00 AS Decimal(10, 2)), CAST(N'2023-05-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (139, 19, 6, 3, N'Бронирование для Путешествие в Лондон #19', CAST(1013.00 AS Decimal(10, 2)), CAST(N'2023-09-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (140, 20, 6, 2, N'Бронирование для Путешествие в Нью-Йорк #20', CAST(95.00 AS Decimal(10, 2)), CAST(N'2023-07-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (141, 21, 4, 3, N'Бронирование для Путешествие в Лондон #21', CAST(699.00 AS Decimal(10, 2)), CAST(N'2023-05-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (142, 22, 7, 1, N'Бронирование для Путешествие в  #22', CAST(755.00 AS Decimal(10, 2)), CAST(N'2023-06-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (143, 23, 3, 2, N'Бронирование для Путешествие в Рим #23', CAST(719.00 AS Decimal(10, 2)), CAST(N'2024-05-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (144, 24, 4, 3, N'Бронирование для Путешествие в  #24', CAST(858.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (145, 25, 6, 1, N'Бронирование для Путешествие в Париж #25', CAST(856.00 AS Decimal(10, 2)), CAST(N'2023-02-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (146, 26, 3, 1, N'Бронирование для Путешествие в Берлин #26', CAST(342.00 AS Decimal(10, 2)), CAST(N'2024-04-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (147, 27, 3, 2, N'Бронирование для Путешествие в Париж #27', CAST(118.00 AS Decimal(10, 2)), CAST(N'2023-03-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (148, 28, 7, 4, N'Бронирование для Путешествие в  #28', CAST(459.00 AS Decimal(10, 2)), CAST(N'2024-01-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (149, 29, 7, 1, N'Бронирование для Путешествие в  #29', CAST(122.00 AS Decimal(10, 2)), CAST(N'2023-09-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (150, 30, 6, 3, N'Бронирование для Путешествие в Лондон #30', CAST(916.00 AS Decimal(10, 2)), CAST(N'2024-08-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (151, 31, 3, 4, N'Бронирование для Путешествие в  #31', CAST(239.00 AS Decimal(10, 2)), CAST(N'2023-02-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (152, 32, 1, 4, N'Бронирование для Путешествие в Рим #32', CAST(89.00 AS Decimal(10, 2)), CAST(N'2024-10-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (153, 33, 1, 2, N'Бронирование для Путешествие в Париж #33', CAST(700.00 AS Decimal(10, 2)), CAST(N'2023-07-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (154, 34, 6, 4, N'Бронирование для Путешествие в Барселону #34', CAST(535.00 AS Decimal(10, 2)), CAST(N'2023-08-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (155, 35, 7, 4, N'Бронирование для Путешествие в Рим #35', CAST(371.00 AS Decimal(10, 2)), CAST(N'2024-06-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (156, 36, 5, 4, N'Бронирование для Путешествие в  #36', CAST(50.00 AS Decimal(10, 2)), CAST(N'2024-10-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (157, 37, 4, 2, N'Бронирование для Путешествие в Париж #37', CAST(1048.00 AS Decimal(10, 2)), CAST(N'2023-12-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (158, 38, 5, 1, N'Бронирование для Путешествие в Нью-Йорк #38', CAST(291.00 AS Decimal(10, 2)), CAST(N'2024-10-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (159, 39, 4, 2, N'Бронирование для Путешествие в  #39', CAST(964.00 AS Decimal(10, 2)), CAST(N'2024-09-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (160, 40, 2, 2, N'Бронирование для Путешествие в  #40', CAST(414.00 AS Decimal(10, 2)), CAST(N'2023-10-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (161, 41, 4, 4, N'Бронирование для Путешествие в  #41', CAST(884.00 AS Decimal(10, 2)), CAST(N'2024-11-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (162, 42, 5, 4, N'Бронирование для Путешествие в Дубай #42', CAST(465.00 AS Decimal(10, 2)), CAST(N'2023-07-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (163, 43, 3, 4, N'Бронирование для Путешествие в Пекин #43', CAST(970.00 AS Decimal(10, 2)), CAST(N'2024-11-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (164, 44, 7, 2, N'Бронирование для Путешествие в  #44', CAST(79.00 AS Decimal(10, 2)), CAST(N'2023-10-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (165, 45, 6, 1, N'Бронирование для Путешествие в Нью-Йорк #45', CAST(877.00 AS Decimal(10, 2)), CAST(N'2024-06-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (166, 46, 5, 4, N'Бронирование для Путешествие в  #46', CAST(842.00 AS Decimal(10, 2)), CAST(N'2023-11-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (167, 47, 6, 2, N'Бронирование для Путешествие в Лондон #47', CAST(555.00 AS Decimal(10, 2)), CAST(N'2024-06-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (168, 48, 1, 3, N'Бронирование для Путешествие в Нью-Йорк #48', CAST(820.00 AS Decimal(10, 2)), CAST(N'2023-02-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (169, 49, 4, 4, N'Бронирование для Путешествие в Лондон #49', CAST(436.00 AS Decimal(10, 2)), CAST(N'2024-08-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (170, 50, 7, 4, N'Бронирование для Путешествие в Берлин #50', CAST(845.00 AS Decimal(10, 2)), CAST(N'2023-10-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (171, 51, 5, 2, N'Бронирование для Путешествие в Токио #51', CAST(869.00 AS Decimal(10, 2)), CAST(N'2024-06-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (172, 52, 5, 1, N'Бронирование для Путешествие в  #52', CAST(419.00 AS Decimal(10, 2)), CAST(N'2023-05-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (173, 53, 7, 2, N'Бронирование для Путешествие в  #53', CAST(957.00 AS Decimal(10, 2)), CAST(N'2024-04-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (174, 54, 4, 4, N'Бронирование для Путешествие в  #54', CAST(139.00 AS Decimal(10, 2)), CAST(N'2024-06-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (175, 55, 6, 4, N'Бронирование для Путешествие в Нью-Йорк #55', CAST(81.00 AS Decimal(10, 2)), CAST(N'2023-12-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (176, 56, 1, 2, N'Бронирование для Путешествие в Пекин #56', CAST(802.00 AS Decimal(10, 2)), CAST(N'2024-07-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (177, 57, 1, 4, N'Бронирование для Путешествие в  #57', CAST(564.00 AS Decimal(10, 2)), CAST(N'2023-02-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (178, 58, 1, 4, N'Бронирование для Путешествие в  #58', CAST(1047.00 AS Decimal(10, 2)), CAST(N'2024-08-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (179, 59, 4, 3, N'Бронирование для Путешествие в Нью-Йорк #59', CAST(437.00 AS Decimal(10, 2)), CAST(N'2024-06-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (180, 60, 7, 2, N'Бронирование для Путешествие в Берлин #60', CAST(172.00 AS Decimal(10, 2)), CAST(N'2023-12-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (181, 61, 1, 2, N'Бронирование для Путешествие в Дубай #61', CAST(123.00 AS Decimal(10, 2)), CAST(N'2024-12-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (182, 62, 4, 2, N'Бронирование для Путешествие в Берлин #62', CAST(924.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (183, 63, 1, 4, N'Бронирование для Путешествие в Париж #63', CAST(647.00 AS Decimal(10, 2)), CAST(N'2024-07-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (184, 64, 4, 2, N'Бронирование для Путешествие в  #64', CAST(938.00 AS Decimal(10, 2)), CAST(N'2024-10-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (185, 65, 2, 1, N'Бронирование для Путешествие в Рим #65', CAST(952.00 AS Decimal(10, 2)), CAST(N'2023-12-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (186, 66, 1, 4, N'Бронирование для Путешествие в Париж #66', CAST(702.00 AS Decimal(10, 2)), CAST(N'2024-10-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (187, 67, 6, 1, N'Бронирование для Путешествие в Дубай #67', CAST(226.00 AS Decimal(10, 2)), CAST(N'2024-05-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (188, 68, 7, 1, N'Бронирование для Путешествие в  #68', CAST(899.00 AS Decimal(10, 2)), CAST(N'2023-04-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (189, 69, 5, 3, N'Бронирование для Путешествие в  #69', CAST(527.00 AS Decimal(10, 2)), CAST(N'2024-11-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (190, 70, 1, 3, N'Бронирование для Путешествие в  #70', CAST(626.00 AS Decimal(10, 2)), CAST(N'2023-01-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (191, 71, 3, 4, N'Бронирование для Путешествие в Берлин #71', CAST(542.00 AS Decimal(10, 2)), CAST(N'2023-04-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (192, 72, 7, 1, N'Бронирование для Путешествие в  #72', CAST(451.00 AS Decimal(10, 2)), CAST(N'2023-01-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (193, 73, 5, 1, N'Бронирование для Путешествие в Пекин #73', CAST(261.00 AS Decimal(10, 2)), CAST(N'2024-05-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (194, 74, 5, 3, N'Бронирование для Путешествие в  #74', CAST(330.00 AS Decimal(10, 2)), CAST(N'2024-09-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (195, 75, 3, 4, N'Бронирование для Путешествие в  #75', CAST(281.00 AS Decimal(10, 2)), CAST(N'2023-08-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (196, 76, 5, 4, N'Бронирование для Путешествие в Токио #76', CAST(1040.00 AS Decimal(10, 2)), CAST(N'2023-11-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (197, 77, 4, 4, N'Бронирование для Путешествие в  #77', CAST(220.00 AS Decimal(10, 2)), CAST(N'2023-08-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (198, 78, 7, 3, N'Бронирование для Путешествие в Лондон #78', CAST(480.00 AS Decimal(10, 2)), CAST(N'2024-11-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (199, 79, 4, 2, N'Бронирование для Путешествие в  #79', CAST(849.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (200, 80, 5, 3, N'Бронирование для Путешествие в  #80', CAST(51.00 AS Decimal(10, 2)), CAST(N'2023-05-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (201, 81, 5, 1, N'Бронирование для Путешествие в Нью-Йорк #81', CAST(664.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (202, 82, 5, 1, N'Бронирование для Путешествие в  #82', CAST(988.00 AS Decimal(10, 2)), CAST(N'2024-01-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (203, 83, 7, 3, N'Бронирование для Путешествие в Берлин #83', CAST(935.00 AS Decimal(10, 2)), CAST(N'2023-06-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (204, 84, 2, 3, N'Бронирование для Путешествие в Рим #84', CAST(481.00 AS Decimal(10, 2)), CAST(N'2023-11-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (205, 85, 7, 3, N'Бронирование для Путешествие в  #85', CAST(801.00 AS Decimal(10, 2)), CAST(N'2024-02-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (206, 86, 6, 4, N'Бронирование для Путешествие в Дубай #86', CAST(358.00 AS Decimal(10, 2)), CAST(N'2023-05-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (207, 87, 5, 4, N'Бронирование для Путешествие в Лондон #87', CAST(592.00 AS Decimal(10, 2)), CAST(N'2023-09-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (208, 88, 7, 2, N'Бронирование для Путешествие в  #88', CAST(655.00 AS Decimal(10, 2)), CAST(N'2023-06-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (209, 89, 4, 3, N'Бронирование для Путешествие в  #89', CAST(406.00 AS Decimal(10, 2)), CAST(N'2024-04-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (210, 90, 1, 1, N'Бронирование для Путешествие в  #90', CAST(181.00 AS Decimal(10, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (211, 91, 2, 2, N'Бронирование для Путешествие в  #91', CAST(662.00 AS Decimal(10, 2)), CAST(N'2023-09-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (212, 92, 4, 3, N'Бронирование для Путешествие в  #92', CAST(501.00 AS Decimal(10, 2)), CAST(N'2024-08-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (213, 93, 7, 1, N'Бронирование для Путешествие в Лондон #93', CAST(248.00 AS Decimal(10, 2)), CAST(N'2024-02-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (214, 94, 2, 3, N'Бронирование для Путешествие в Москву #94', CAST(222.00 AS Decimal(10, 2)), CAST(N'2023-07-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (215, 95, 2, 3, N'Бронирование для Путешествие в Нью-Йорк #95', CAST(786.00 AS Decimal(10, 2)), CAST(N'2024-02-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (216, 96, 5, 1, N'Бронирование для Путешествие в Берлин #96', CAST(259.00 AS Decimal(10, 2)), CAST(N'2024-07-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (217, 97, 6, 3, N'Бронирование для Путешествие в Лондон #97', CAST(174.00 AS Decimal(10, 2)), CAST(N'2024-10-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (218, 98, 4, 1, N'Бронирование для Путешествие в Пекин #98', CAST(264.00 AS Decimal(10, 2)), CAST(N'2023-11-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (219, 99, 4, 4, N'Бронирование для Путешествие в  #99', CAST(340.00 AS Decimal(10, 2)), CAST(N'2023-03-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (220, 100, 7, 4, N'Бронирование для Путешествие в  #100', CAST(779.00 AS Decimal(10, 2)), CAST(N'2023-01-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (221, 101, 3, 3, N'Бронирование для Путешествие в Дубай #101', CAST(187.00 AS Decimal(10, 2)), CAST(N'2024-01-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (222, 102, 7, 4, N'Бронирование для Путешествие в Нью-Йорк #102', CAST(375.00 AS Decimal(10, 2)), CAST(N'2023-01-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (223, 103, 1, 1, N'Бронирование для Путешествие в  #103', CAST(937.00 AS Decimal(10, 2)), CAST(N'2023-07-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (224, 104, 6, 1, N'Бронирование для Путешествие в  #104', CAST(413.00 AS Decimal(10, 2)), CAST(N'2023-03-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (225, 105, 7, 4, N'Бронирование для Путешествие в Берлин #105', CAST(984.00 AS Decimal(10, 2)), CAST(N'2024-07-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (226, 106, 6, 2, N'Бронирование для Путешествие в  #106', CAST(1001.00 AS Decimal(10, 2)), CAST(N'2023-05-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (227, 107, 1, 1, N'Бронирование для Путешествие в Лондон #107', CAST(203.00 AS Decimal(10, 2)), CAST(N'2024-08-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (228, 108, 7, 3, N'Бронирование для Путешествие в Париж #108', CAST(166.00 AS Decimal(10, 2)), CAST(N'2024-06-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (229, 109, 5, 4, N'Бронирование для Путешествие в  #109', CAST(527.00 AS Decimal(10, 2)), CAST(N'2023-04-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (230, 110, 4, 1, N'Бронирование для Путешествие в  #110', CAST(996.00 AS Decimal(10, 2)), CAST(N'2022-12-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (231, 111, 1, 1, N'Бронирование для Путешествие в  #111', CAST(152.00 AS Decimal(10, 2)), CAST(N'2023-02-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (232, 112, 1, 1, N'Бронирование для Путешествие в Рим #112', CAST(914.00 AS Decimal(10, 2)), CAST(N'2024-11-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (233, 113, 6, 3, N'Бронирование для Путешествие в Дубай #113', CAST(698.00 AS Decimal(10, 2)), CAST(N'2023-04-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (234, 114, 1, 4, N'Бронирование для Путешествие в Париж #114', CAST(382.00 AS Decimal(10, 2)), CAST(N'2023-06-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (235, 115, 4, 2, N'Бронирование для Путешествие в Дубай #115', CAST(617.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (236, 116, 4, 3, N'Бронирование для Путешествие в  #116', CAST(454.00 AS Decimal(10, 2)), CAST(N'2023-06-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (237, 117, 7, 2, N'Бронирование для Путешествие в Барселону #117', CAST(171.00 AS Decimal(10, 2)), CAST(N'2024-01-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (238, 118, 2, 1, N'Бронирование для Путешествие в Лондон #118', CAST(404.00 AS Decimal(10, 2)), CAST(N'2023-07-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (239, 119, 3, 2, N'Бронирование для Путешествие в Нью-Йорк #119', CAST(142.00 AS Decimal(10, 2)), CAST(N'2023-11-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (240, 120, 2, 1, N'Бронирование для Путешествие в  #120', CAST(901.00 AS Decimal(10, 2)), CAST(N'2023-04-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (241, 1, 3, 3, N'Бронирование для Путешествие в Дубай #1', CAST(930.00 AS Decimal(10, 2)), CAST(N'2023-10-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (242, 2, 6, 3, N'Бронирование для Путешествие в Москву #2', CAST(730.00 AS Decimal(10, 2)), CAST(N'2023-02-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (243, 3, 5, 4, N'Бронирование для Путешествие в Токио #3', CAST(331.00 AS Decimal(10, 2)), CAST(N'2023-11-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (244, 4, 5, 3, N'Бронирование для Путешествие в Барселону #4', CAST(644.00 AS Decimal(10, 2)), CAST(N'2023-11-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (245, 5, 4, 1, N'Бронирование для Путешествие в  #5', CAST(935.00 AS Decimal(10, 2)), CAST(N'2024-04-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (246, 6, 6, 4, N'Бронирование для Путешествие в Париж #6', CAST(288.00 AS Decimal(10, 2)), CAST(N'2023-10-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (247, 7, 2, 1, N'Бронирование для Путешествие в  #7', CAST(448.00 AS Decimal(10, 2)), CAST(N'2023-02-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (248, 8, 4, 3, N'Бронирование для Путешествие в  #8', CAST(601.00 AS Decimal(10, 2)), CAST(N'2024-06-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (249, 9, 7, 1, N'Бронирование для Путешествие в Париж #9', CAST(979.00 AS Decimal(10, 2)), CAST(N'2023-08-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (250, 10, 5, 3, N'Бронирование для Путешествие в Лондон #10', CAST(321.00 AS Decimal(10, 2)), CAST(N'2024-03-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (251, 11, 1, 1, N'Бронирование для Путешествие в Берлин #11', CAST(757.00 AS Decimal(10, 2)), CAST(N'2023-05-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (252, 12, 3, 2, N'Бронирование для Путешествие в Дубай #12', CAST(996.00 AS Decimal(10, 2)), CAST(N'2024-11-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (253, 13, 3, 1, N'Бронирование для Путешествие в  #13', CAST(346.00 AS Decimal(10, 2)), CAST(N'2023-12-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (254, 14, 4, 1, N'Бронирование для Путешествие в  #14', CAST(886.00 AS Decimal(10, 2)), CAST(N'2023-01-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (255, 15, 6, 1, N'Бронирование для Путешествие в Барселону #15', CAST(868.00 AS Decimal(10, 2)), CAST(N'2023-06-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (256, 16, 3, 2, N'Бронирование для Путешествие в Берлин #16', CAST(831.00 AS Decimal(10, 2)), CAST(N'2024-03-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (257, 17, 4, 4, N'Бронирование для Путешествие в Дубай #17', CAST(1010.00 AS Decimal(10, 2)), CAST(N'2024-12-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (258, 18, 4, 2, N'Бронирование для Путешествие в Пекин #18', CAST(102.00 AS Decimal(10, 2)), CAST(N'2023-05-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (259, 19, 4, 3, N'Бронирование для Путешествие в Лондон #19', CAST(282.00 AS Decimal(10, 2)), CAST(N'2023-09-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (260, 20, 5, 1, N'Бронирование для Путешествие в Нью-Йорк #20', CAST(334.00 AS Decimal(10, 2)), CAST(N'2023-07-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (261, 21, 5, 1, N'Бронирование для Путешествие в Лондон #21', CAST(1002.00 AS Decimal(10, 2)), CAST(N'2023-06-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (262, 22, 5, 4, N'Бронирование для Путешествие в  #22', CAST(878.00 AS Decimal(10, 2)), CAST(N'2023-06-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (263, 23, 7, 3, N'Бронирование для Путешествие в Рим #23', CAST(341.00 AS Decimal(10, 2)), CAST(N'2024-05-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (264, 24, 6, 2, N'Бронирование для Путешествие в  #24', CAST(842.00 AS Decimal(10, 2)), CAST(N'2024-02-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (265, 25, 5, 3, N'Бронирование для Путешествие в Париж #25', CAST(56.00 AS Decimal(10, 2)), CAST(N'2023-02-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (266, 26, 5, 1, N'Бронирование для Путешествие в Берлин #26', CAST(814.00 AS Decimal(10, 2)), CAST(N'2024-05-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (267, 27, 1, 4, N'Бронирование для Путешествие в Париж #27', CAST(541.00 AS Decimal(10, 2)), CAST(N'2023-03-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (268, 28, 2, 1, N'Бронирование для Путешествие в  #28', CAST(1044.00 AS Decimal(10, 2)), CAST(N'2024-02-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (269, 29, 3, 1, N'Бронирование для Путешествие в  #29', CAST(1010.00 AS Decimal(10, 2)), CAST(N'2023-08-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (270, 30, 4, 1, N'Бронирование для Путешествие в Лондон #30', CAST(521.00 AS Decimal(10, 2)), CAST(N'2024-09-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (271, 31, 6, 4, N'Бронирование для Путешествие в  #31', CAST(662.00 AS Decimal(10, 2)), CAST(N'2023-01-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (272, 32, 1, 2, N'Бронирование для Путешествие в Рим #32', CAST(915.00 AS Decimal(10, 2)), CAST(N'2024-11-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (273, 33, 1, 3, N'Бронирование для Путешествие в Париж #33', CAST(814.00 AS Decimal(10, 2)), CAST(N'2023-07-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (274, 34, 3, 4, N'Бронирование для Путешествие в Барселону #34', CAST(145.00 AS Decimal(10, 2)), CAST(N'2023-08-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (275, 35, 3, 1, N'Бронирование для Путешествие в Рим #35', CAST(235.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (276, 36, 6, 3, N'Бронирование для Путешествие в  #36', CAST(439.00 AS Decimal(10, 2)), CAST(N'2024-10-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (277, 37, 3, 4, N'Бронирование для Путешествие в Париж #37', CAST(258.00 AS Decimal(10, 2)), CAST(N'2023-12-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (278, 38, 1, 4, N'Бронирование для Путешествие в Нью-Йорк #38', CAST(827.00 AS Decimal(10, 2)), CAST(N'2024-10-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (279, 39, 2, 4, N'Бронирование для Путешествие в  #39', CAST(257.00 AS Decimal(10, 2)), CAST(N'2024-08-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (280, 40, 4, 1, N'Бронирование для Путешествие в  #40', CAST(349.00 AS Decimal(10, 2)), CAST(N'2023-09-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (281, 41, 2, 2, N'Бронирование для Путешествие в  #41', CAST(463.00 AS Decimal(10, 2)), CAST(N'2024-11-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (282, 42, 3, 4, N'Бронирование для Путешествие в Дубай #42', CAST(435.00 AS Decimal(10, 2)), CAST(N'2023-08-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (283, 43, 7, 2, N'Бронирование для Путешествие в Пекин #43', CAST(847.00 AS Decimal(10, 2)), CAST(N'2024-11-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (284, 44, 3, 3, N'Бронирование для Путешествие в  #44', CAST(611.00 AS Decimal(10, 2)), CAST(N'2023-10-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (285, 45, 7, 3, N'Бронирование для Путешествие в Нью-Йорк #45', CAST(799.00 AS Decimal(10, 2)), CAST(N'2024-06-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (286, 46, 6, 1, N'Бронирование для Путешествие в  #46', CAST(729.00 AS Decimal(10, 2)), CAST(N'2023-11-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (287, 47, 6, 3, N'Бронирование для Путешествие в Лондон #47', CAST(295.00 AS Decimal(10, 2)), CAST(N'2024-06-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (288, 48, 2, 4, N'Бронирование для Путешествие в Нью-Йорк #48', CAST(330.00 AS Decimal(10, 2)), CAST(N'2023-02-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (289, 49, 2, 3, N'Бронирование для Путешествие в Лондон #49', CAST(912.00 AS Decimal(10, 2)), CAST(N'2024-08-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (290, 50, 7, 2, N'Бронирование для Путешествие в Берлин #50', CAST(249.00 AS Decimal(10, 2)), CAST(N'2023-09-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (291, 51, 7, 2, N'Бронирование для Путешествие в Токио #51', CAST(933.00 AS Decimal(10, 2)), CAST(N'2024-05-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (292, 52, 2, 4, N'Бронирование для Путешествие в  #52', CAST(182.00 AS Decimal(10, 2)), CAST(N'2023-05-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (293, 53, 2, 2, N'Бронирование для Путешествие в  #53', CAST(612.00 AS Decimal(10, 2)), CAST(N'2024-03-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (294, 54, 2, 2, N'Бронирование для Путешествие в  #54', CAST(812.00 AS Decimal(10, 2)), CAST(N'2024-07-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (295, 55, 2, 1, N'Бронирование для Путешествие в Нью-Йорк #55', CAST(908.00 AS Decimal(10, 2)), CAST(N'2024-01-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (296, 56, 5, 2, N'Бронирование для Путешествие в Пекин #56', CAST(996.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (297, 57, 1, 1, N'Бронирование для Путешествие в  #57', CAST(54.00 AS Decimal(10, 2)), CAST(N'2023-02-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (298, 58, 6, 3, N'Бронирование для Путешествие в  #58', CAST(393.00 AS Decimal(10, 2)), CAST(N'2024-09-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (299, 59, 7, 4, N'Бронирование для Путешествие в Нью-Йорк #59', CAST(689.00 AS Decimal(10, 2)), CAST(N'2024-06-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (300, 60, 3, 3, N'Бронирование для Путешествие в Берлин #60', CAST(650.00 AS Decimal(10, 2)), CAST(N'2023-12-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (301, 61, 1, 2, N'Бронирование для Путешествие в Дубай #61', CAST(880.00 AS Decimal(10, 2)), CAST(N'2024-12-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (302, 62, 3, 1, N'Бронирование для Путешествие в Берлин #62', CAST(1046.00 AS Decimal(10, 2)), CAST(N'2024-07-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (303, 63, 5, 4, N'Бронирование для Путешествие в Париж #63', CAST(641.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (304, 64, 1, 3, N'Бронирование для Путешествие в  #64', CAST(624.00 AS Decimal(10, 2)), CAST(N'2024-10-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (305, 65, 1, 2, N'Бронирование для Путешествие в Рим #65', CAST(606.00 AS Decimal(10, 2)), CAST(N'2024-01-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (306, 66, 5, 1, N'Бронирование для Путешествие в Париж #66', CAST(623.00 AS Decimal(10, 2)), CAST(N'2024-09-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (307, 67, 3, 1, N'Бронирование для Путешествие в Дубай #67', CAST(1003.00 AS Decimal(10, 2)), CAST(N'2024-05-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (308, 68, 1, 4, N'Бронирование для Путешествие в  #68', CAST(564.00 AS Decimal(10, 2)), CAST(N'2023-04-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (309, 69, 7, 3, N'Бронирование для Путешествие в  #69', CAST(568.00 AS Decimal(10, 2)), CAST(N'2024-11-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (310, 70, 2, 4, N'Бронирование для Путешествие в  #70', CAST(222.00 AS Decimal(10, 2)), CAST(N'2023-02-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (311, 71, 1, 4, N'Бронирование для Путешествие в Берлин #71', CAST(431.00 AS Decimal(10, 2)), CAST(N'2023-05-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (312, 72, 5, 3, N'Бронирование для Путешествие в  #72', CAST(276.00 AS Decimal(10, 2)), CAST(N'2023-01-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (313, 73, 2, 2, N'Бронирование для Путешествие в Пекин #73', CAST(974.00 AS Decimal(10, 2)), CAST(N'2024-05-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (314, 74, 1, 4, N'Бронирование для Путешествие в  #74', CAST(455.00 AS Decimal(10, 2)), CAST(N'2024-10-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (315, 75, 5, 3, N'Бронирование для Путешествие в  #75', CAST(571.00 AS Decimal(10, 2)), CAST(N'2023-08-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (316, 76, 6, 4, N'Бронирование для Путешествие в Токио #76', CAST(550.00 AS Decimal(10, 2)), CAST(N'2023-11-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (317, 77, 7, 3, N'Бронирование для Путешествие в  #77', CAST(892.00 AS Decimal(10, 2)), CAST(N'2023-08-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (318, 78, 6, 4, N'Бронирование для Путешествие в Лондон #78', CAST(111.00 AS Decimal(10, 2)), CAST(N'2024-11-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (319, 79, 2, 2, N'Бронирование для Путешествие в  #79', CAST(598.00 AS Decimal(10, 2)), CAST(N'2023-12-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (320, 80, 5, 4, N'Бронирование для Путешествие в  #80', CAST(794.00 AS Decimal(10, 2)), CAST(N'2023-05-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (321, 81, 2, 4, N'Бронирование для Путешествие в Нью-Йорк #81', CAST(161.00 AS Decimal(10, 2)), CAST(N'2024-06-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (322, 82, 7, 1, N'Бронирование для Путешествие в  #82', CAST(404.00 AS Decimal(10, 2)), CAST(N'2024-01-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (323, 83, 1, 2, N'Бронирование для Путешествие в Берлин #83', CAST(159.00 AS Decimal(10, 2)), CAST(N'2023-05-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (324, 84, 5, 4, N'Бронирование для Путешествие в Рим #84', CAST(654.00 AS Decimal(10, 2)), CAST(N'2023-11-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (325, 85, 4, 4, N'Бронирование для Путешествие в  #85', CAST(828.00 AS Decimal(10, 2)), CAST(N'2024-01-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (326, 86, 4, 3, N'Бронирование для Путешествие в Дубай #86', CAST(559.00 AS Decimal(10, 2)), CAST(N'2023-05-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (327, 87, 6, 1, N'Бронирование для Путешествие в Лондон #87', CAST(874.00 AS Decimal(10, 2)), CAST(N'2023-09-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (328, 88, 6, 2, N'Бронирование для Путешествие в  #88', CAST(724.00 AS Decimal(10, 2)), CAST(N'2023-06-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (329, 89, 3, 4, N'Бронирование для Путешествие в  #89', CAST(900.00 AS Decimal(10, 2)), CAST(N'2024-04-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (330, 90, 3, 3, N'Бронирование для Путешествие в  #90', CAST(764.00 AS Decimal(10, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (331, 91, 7, 1, N'Бронирование для Путешествие в  #91', CAST(463.00 AS Decimal(10, 2)), CAST(N'2023-09-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (332, 92, 5, 1, N'Бронирование для Путешествие в  #92', CAST(99.00 AS Decimal(10, 2)), CAST(N'2024-08-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (333, 93, 3, 2, N'Бронирование для Путешествие в Лондон #93', CAST(976.00 AS Decimal(10, 2)), CAST(N'2024-02-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (334, 94, 1, 4, N'Бронирование для Путешествие в Москву #94', CAST(290.00 AS Decimal(10, 2)), CAST(N'2023-07-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (335, 95, 7, 4, N'Бронирование для Путешествие в Нью-Йорк #95', CAST(413.00 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (336, 96, 7, 1, N'Бронирование для Путешествие в Берлин #96', CAST(571.00 AS Decimal(10, 2)), CAST(N'2024-07-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (337, 97, 4, 4, N'Бронирование для Путешествие в Лондон #97', CAST(908.00 AS Decimal(10, 2)), CAST(N'2024-10-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (338, 98, 2, 2, N'Бронирование для Путешествие в Пекин #98', CAST(1023.00 AS Decimal(10, 2)), CAST(N'2023-11-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (339, 99, 3, 2, N'Бронирование для Путешествие в  #99', CAST(380.00 AS Decimal(10, 2)), CAST(N'2023-03-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (340, 100, 5, 1, N'Бронирование для Путешествие в  #100', CAST(355.00 AS Decimal(10, 2)), CAST(N'2023-02-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (341, 101, 5, 1, N'Бронирование для Путешествие в Дубай #101', CAST(156.00 AS Decimal(10, 2)), CAST(N'2024-01-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (342, 102, 4, 3, N'Бронирование для Путешествие в Нью-Йорк #102', CAST(304.00 AS Decimal(10, 2)), CAST(N'2023-01-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (343, 103, 6, 3, N'Бронирование для Путешествие в  #103', CAST(425.00 AS Decimal(10, 2)), CAST(N'2023-08-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (344, 104, 2, 4, N'Бронирование для Путешествие в  #104', CAST(704.00 AS Decimal(10, 2)), CAST(N'2023-03-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (345, 105, 2, 4, N'Бронирование для Путешествие в Берлин #105', CAST(145.00 AS Decimal(10, 2)), CAST(N'2024-07-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (346, 106, 6, 1, N'Бронирование для Путешествие в  #106', CAST(615.00 AS Decimal(10, 2)), CAST(N'2023-05-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (347, 107, 6, 4, N'Бронирование для Путешествие в Лондон #107', CAST(852.00 AS Decimal(10, 2)), CAST(N'2024-07-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (348, 108, 5, 3, N'Бронирование для Путешествие в Париж #108', CAST(269.00 AS Decimal(10, 2)), CAST(N'2024-06-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (349, 109, 4, 3, N'Бронирование для Путешествие в  #109', CAST(392.00 AS Decimal(10, 2)), CAST(N'2023-04-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (350, 110, 3, 2, N'Бронирование для Путешествие в  #110', CAST(456.00 AS Decimal(10, 2)), CAST(N'2022-12-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (351, 111, 2, 2, N'Бронирование для Путешествие в  #111', CAST(139.00 AS Decimal(10, 2)), CAST(N'2023-02-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (352, 112, 1, 1, N'Бронирование для Путешествие в Рим #112', CAST(970.00 AS Decimal(10, 2)), CAST(N'2024-11-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (353, 113, 2, 3, N'Бронирование для Путешествие в Дубай #113', CAST(865.00 AS Decimal(10, 2)), CAST(N'2023-04-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (354, 114, 5, 1, N'Бронирование для Путешествие в Париж #114', CAST(969.00 AS Decimal(10, 2)), CAST(N'2023-06-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (355, 115, 5, 4, N'Бронирование для Путешествие в Дубай #115', CAST(824.00 AS Decimal(10, 2)), CAST(N'2024-03-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (356, 116, 4, 3, N'Бронирование для Путешествие в  #116', CAST(745.00 AS Decimal(10, 2)), CAST(N'2023-07-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (357, 117, 7, 4, N'Бронирование для Путешествие в Барселону #117', CAST(166.00 AS Decimal(10, 2)), CAST(N'2023-12-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (358, 118, 7, 4, N'Бронирование для Путешествие в Лондон #118', CAST(269.00 AS Decimal(10, 2)), CAST(N'2023-06-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (359, 119, 3, 3, N'Бронирование для Путешествие в Нью-Йорк #119', CAST(683.00 AS Decimal(10, 2)), CAST(N'2023-11-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (360, 120, 4, 2, N'Бронирование для Путешествие в  #120', CAST(649.00 AS Decimal(10, 2)), CAST(N'2023-04-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (361, 1, 5, 2, N'Бронирование для Путешествие в Дубай #1', CAST(243.00 AS Decimal(10, 2)), CAST(N'2023-11-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (362, 2, 5, 1, N'Бронирование для Путешествие в Москву #2', CAST(201.00 AS Decimal(10, 2)), CAST(N'2023-02-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (363, 3, 1, 2, N'Бронирование для Путешествие в Токио #3', CAST(940.00 AS Decimal(10, 2)), CAST(N'2023-11-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (364, 4, 5, 4, N'Бронирование для Путешествие в Барселону #4', CAST(838.00 AS Decimal(10, 2)), CAST(N'2023-12-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (365, 5, 5, 3, N'Бронирование для Путешествие в  #5', CAST(357.00 AS Decimal(10, 2)), CAST(N'2024-05-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (366, 6, 7, 4, N'Бронирование для Путешествие в Париж #6', CAST(997.00 AS Decimal(10, 2)), CAST(N'2023-10-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (367, 7, 5, 1, N'Бронирование для Путешествие в  #7', CAST(376.00 AS Decimal(10, 2)), CAST(N'2023-02-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (368, 8, 3, 4, N'Бронирование для Путешествие в  #8', CAST(370.00 AS Decimal(10, 2)), CAST(N'2024-06-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (369, 9, 1, 4, N'Бронирование для Путешествие в Париж #9', CAST(211.00 AS Decimal(10, 2)), CAST(N'2023-09-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (370, 10, 1, 2, N'Бронирование для Путешествие в Лондон #10', CAST(472.00 AS Decimal(10, 2)), CAST(N'2024-03-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (371, 11, 2, 3, N'Бронирование для Путешествие в Берлин #11', CAST(637.00 AS Decimal(10, 2)), CAST(N'2023-05-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (372, 12, 1, 2, N'Бронирование для Путешествие в Дубай #12', CAST(157.00 AS Decimal(10, 2)), CAST(N'2024-11-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (373, 13, 1, 3, N'Бронирование для Путешествие в  #13', CAST(620.00 AS Decimal(10, 2)), CAST(N'2023-12-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (374, 14, 4, 3, N'Бронирование для Путешествие в  #14', CAST(476.00 AS Decimal(10, 2)), CAST(N'2023-02-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (375, 15, 4, 3, N'Бронирование для Путешествие в Барселону #15', CAST(360.00 AS Decimal(10, 2)), CAST(N'2023-05-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (376, 16, 5, 3, N'Бронирование для Путешествие в Берлин #16', CAST(296.00 AS Decimal(10, 2)), CAST(N'2024-04-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (377, 17, 3, 4, N'Бронирование для Путешествие в Дубай #17', CAST(1027.00 AS Decimal(10, 2)), CAST(N'2024-11-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (378, 18, 1, 1, N'Бронирование для Путешествие в Пекин #18', CAST(328.00 AS Decimal(10, 2)), CAST(N'2023-05-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (379, 19, 2, 1, N'Бронирование для Путешествие в Лондон #19', CAST(64.00 AS Decimal(10, 2)), CAST(N'2023-09-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (380, 20, 3, 2, N'Бронирование для Путешествие в Нью-Йорк #20', CAST(854.00 AS Decimal(10, 2)), CAST(N'2023-07-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (381, 21, 4, 2, N'Бронирование для Путешествие в Лондон #21', CAST(300.00 AS Decimal(10, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (382, 22, 5, 3, N'Бронирование для Путешествие в  #22', CAST(240.00 AS Decimal(10, 2)), CAST(N'2023-06-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (383, 23, 1, 3, N'Бронирование для Путешествие в Рим #23', CAST(172.00 AS Decimal(10, 2)), CAST(N'2024-05-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (384, 24, 5, 1, N'Бронирование для Путешествие в  #24', CAST(99.00 AS Decimal(10, 2)), CAST(N'2024-01-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (385, 25, 5, 1, N'Бронирование для Путешествие в Париж #25', CAST(827.00 AS Decimal(10, 2)), CAST(N'2023-02-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (386, 26, 5, 4, N'Бронирование для Путешествие в Берлин #26', CAST(677.00 AS Decimal(10, 2)), CAST(N'2024-05-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (387, 27, 4, 4, N'Бронирование для Путешествие в Париж #27', CAST(580.00 AS Decimal(10, 2)), CAST(N'2023-03-26' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (388, 28, 5, 1, N'Бронирование для Путешествие в  #28', CAST(125.00 AS Decimal(10, 2)), CAST(N'2024-02-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (389, 29, 5, 3, N'Бронирование для Путешествие в  #29', CAST(346.00 AS Decimal(10, 2)), CAST(N'2023-08-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (390, 30, 3, 1, N'Бронирование для Путешествие в Лондон #30', CAST(448.00 AS Decimal(10, 2)), CAST(N'2024-08-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (391, 31, 6, 4, N'Бронирование для Путешествие в  #31', CAST(402.00 AS Decimal(10, 2)), CAST(N'2023-01-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (392, 32, 6, 1, N'Бронирование для Путешествие в Рим #32', CAST(953.00 AS Decimal(10, 2)), CAST(N'2024-11-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (393, 33, 6, 2, N'Бронирование для Путешествие в Париж #33', CAST(163.00 AS Decimal(10, 2)), CAST(N'2023-07-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (394, 34, 5, 3, N'Бронирование для Путешествие в Барселону #34', CAST(471.00 AS Decimal(10, 2)), CAST(N'2023-08-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (395, 35, 6, 3, N'Бронирование для Путешествие в Рим #35', CAST(1011.00 AS Decimal(10, 2)), CAST(N'2024-06-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (396, 36, 2, 4, N'Бронирование для Путешествие в  #36', CAST(788.00 AS Decimal(10, 2)), CAST(N'2024-10-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (397, 37, 5, 1, N'Бронирование для Путешествие в Париж #37', CAST(551.00 AS Decimal(10, 2)), CAST(N'2023-12-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (398, 38, 2, 4, N'Бронирование для Путешествие в Нью-Йорк #38', CAST(1048.00 AS Decimal(10, 2)), CAST(N'2024-10-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (399, 39, 4, 4, N'Бронирование для Путешествие в  #39', CAST(450.00 AS Decimal(10, 2)), CAST(N'2024-09-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (400, 40, 6, 1, N'Бронирование для Путешествие в  #40', CAST(157.00 AS Decimal(10, 2)), CAST(N'2023-10-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (401, 41, 4, 2, N'Бронирование для Путешествие в  #41', CAST(357.00 AS Decimal(10, 2)), CAST(N'2024-11-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (402, 42, 7, 1, N'Бронирование для Путешествие в Дубай #42', CAST(983.00 AS Decimal(10, 2)), CAST(N'2023-08-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (403, 43, 3, 4, N'Бронирование для Путешествие в Пекин #43', CAST(173.00 AS Decimal(10, 2)), CAST(N'2024-12-08' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (404, 44, 1, 4, N'Бронирование для Путешествие в  #44', CAST(945.00 AS Decimal(10, 2)), CAST(N'2023-10-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (405, 45, 3, 1, N'Бронирование для Путешествие в Нью-Йорк #45', CAST(708.00 AS Decimal(10, 2)), CAST(N'2024-07-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (406, 46, 4, 2, N'Бронирование для Путешествие в  #46', CAST(649.00 AS Decimal(10, 2)), CAST(N'2023-11-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (407, 47, 2, 2, N'Бронирование для Путешествие в Лондон #47', CAST(904.00 AS Decimal(10, 2)), CAST(N'2024-06-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (408, 48, 7, 2, N'Бронирование для Путешествие в Нью-Йорк #48', CAST(691.00 AS Decimal(10, 2)), CAST(N'2023-02-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (409, 49, 3, 2, N'Бронирование для Путешествие в Лондон #49', CAST(752.00 AS Decimal(10, 2)), CAST(N'2024-08-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (410, 50, 7, 3, N'Бронирование для Путешествие в Берлин #50', CAST(479.00 AS Decimal(10, 2)), CAST(N'2023-10-13' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (411, 51, 7, 3, N'Бронирование для Путешествие в Токио #51', CAST(190.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (412, 52, 7, 2, N'Бронирование для Путешествие в  #52', CAST(791.00 AS Decimal(10, 2)), CAST(N'2023-06-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (413, 53, 3, 3, N'Бронирование для Путешествие в  #53', CAST(273.00 AS Decimal(10, 2)), CAST(N'2024-04-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (414, 54, 4, 1, N'Бронирование для Путешествие в  #54', CAST(309.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (415, 55, 5, 3, N'Бронирование для Путешествие в Нью-Йорк #55', CAST(166.00 AS Decimal(10, 2)), CAST(N'2024-01-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (416, 56, 5, 3, N'Бронирование для Путешествие в Пекин #56', CAST(629.00 AS Decimal(10, 2)), CAST(N'2024-07-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (417, 57, 7, 4, N'Бронирование для Путешествие в  #57', CAST(796.00 AS Decimal(10, 2)), CAST(N'2023-03-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (418, 58, 7, 3, N'Бронирование для Путешествие в  #58', CAST(246.00 AS Decimal(10, 2)), CAST(N'2024-09-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (419, 59, 7, 1, N'Бронирование для Путешествие в Нью-Йорк #59', CAST(347.00 AS Decimal(10, 2)), CAST(N'2024-05-23' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (420, 60, 4, 1, N'Бронирование для Путешествие в Берлин #60', CAST(1023.00 AS Decimal(10, 2)), CAST(N'2023-11-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (421, 61, 2, 3, N'Бронирование для Путешествие в Дубай #61', CAST(149.00 AS Decimal(10, 2)), CAST(N'2024-12-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (422, 62, 5, 2, N'Бронирование для Путешествие в Берлин #62', CAST(320.00 AS Decimal(10, 2)), CAST(N'2024-07-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (423, 63, 4, 1, N'Бронирование для Путешествие в Париж #63', CAST(523.00 AS Decimal(10, 2)), CAST(N'2024-07-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (424, 64, 3, 4, N'Бронирование для Путешествие в  #64', CAST(467.00 AS Decimal(10, 2)), CAST(N'2024-10-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (425, 65, 2, 3, N'Бронирование для Путешествие в Рим #65', CAST(543.00 AS Decimal(10, 2)), CAST(N'2024-01-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (426, 66, 3, 1, N'Бронирование для Путешествие в Париж #66', CAST(443.00 AS Decimal(10, 2)), CAST(N'2024-09-21' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (427, 67, 3, 4, N'Бронирование для Путешествие в Дубай #67', CAST(467.00 AS Decimal(10, 2)), CAST(N'2024-06-09' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (428, 68, 6, 1, N'Бронирование для Путешествие в  #68', CAST(502.00 AS Decimal(10, 2)), CAST(N'2023-05-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (429, 69, 2, 3, N'Бронирование для Путешествие в  #69', CAST(178.00 AS Decimal(10, 2)), CAST(N'2024-11-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (430, 70, 4, 3, N'Бронирование для Путешествие в  #70', CAST(872.00 AS Decimal(10, 2)), CAST(N'2023-01-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (431, 71, 5, 4, N'Бронирование для Путешествие в Берлин #71', CAST(1012.00 AS Decimal(10, 2)), CAST(N'2023-05-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (432, 72, 4, 4, N'Бронирование для Путешествие в  #72', CAST(1043.00 AS Decimal(10, 2)), CAST(N'2023-01-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (433, 73, 1, 1, N'Бронирование для Путешествие в Пекин #73', CAST(720.00 AS Decimal(10, 2)), CAST(N'2024-05-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (434, 74, 7, 1, N'Бронирование для Путешествие в  #74', CAST(966.00 AS Decimal(10, 2)), CAST(N'2024-09-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (435, 75, 6, 1, N'Бронирование для Путешествие в  #75', CAST(618.00 AS Decimal(10, 2)), CAST(N'2023-08-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (436, 76, 7, 3, N'Бронирование для Путешествие в Токио #76', CAST(473.00 AS Decimal(10, 2)), CAST(N'2023-10-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (437, 77, 1, 2, N'Бронирование для Путешествие в  #77', CAST(620.00 AS Decimal(10, 2)), CAST(N'2023-07-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (438, 78, 4, 3, N'Бронирование для Путешествие в Лондон #78', CAST(671.00 AS Decimal(10, 2)), CAST(N'2024-11-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (439, 79, 3, 2, N'Бронирование для Путешествие в  #79', CAST(307.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (440, 80, 2, 1, N'Бронирование для Путешествие в  #80', CAST(444.00 AS Decimal(10, 2)), CAST(N'2023-05-31' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (441, 81, 3, 3, N'Бронирование для Путешествие в Нью-Йорк #81', CAST(186.00 AS Decimal(10, 2)), CAST(N'2024-06-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (442, 82, 5, 3, N'Бронирование для Путешествие в  #82', CAST(473.00 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (443, 83, 5, 4, N'Бронирование для Путешествие в Берлин #83', CAST(269.00 AS Decimal(10, 2)), CAST(N'2023-05-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (444, 84, 3, 3, N'Бронирование для Путешествие в Рим #84', CAST(860.00 AS Decimal(10, 2)), CAST(N'2023-10-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (445, 85, 1, 2, N'Бронирование для Путешествие в  #85', CAST(821.00 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (446, 86, 1, 4, N'Бронирование для Путешествие в Дубай #86', CAST(583.00 AS Decimal(10, 2)), CAST(N'2023-05-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (447, 87, 6, 3, N'Бронирование для Путешествие в Лондон #87', CAST(808.00 AS Decimal(10, 2)), CAST(N'2023-09-30' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (448, 88, 1, 4, N'Бронирование для Путешествие в  #88', CAST(175.00 AS Decimal(10, 2)), CAST(N'2023-06-16' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (449, 89, 6, 1, N'Бронирование для Путешествие в  #89', CAST(559.00 AS Decimal(10, 2)), CAST(N'2024-04-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (450, 90, 3, 2, N'Бронирование для Путешествие в  #90', CAST(723.00 AS Decimal(10, 2)), CAST(N'2023-06-05' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (451, 91, 5, 1, N'Бронирование для Путешествие в  #91', CAST(1002.00 AS Decimal(10, 2)), CAST(N'2023-09-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (452, 92, 5, 2, N'Бронирование для Путешествие в  #92', CAST(384.00 AS Decimal(10, 2)), CAST(N'2024-08-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (453, 93, 7, 4, N'Бронирование для Путешествие в Лондон #93', CAST(924.00 AS Decimal(10, 2)), CAST(N'2024-02-12' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (454, 94, 7, 3, N'Бронирование для Путешествие в Москву #94', CAST(1017.00 AS Decimal(10, 2)), CAST(N'2023-07-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (455, 95, 2, 4, N'Бронирование для Путешествие в Нью-Йорк #95', CAST(1037.00 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (456, 96, 6, 2, N'Бронирование для Путешествие в Берлин #96', CAST(644.00 AS Decimal(10, 2)), CAST(N'2024-07-07' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (457, 97, 5, 2, N'Бронирование для Путешествие в Лондон #97', CAST(817.00 AS Decimal(10, 2)), CAST(N'2024-09-15' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (458, 98, 6, 2, N'Бронирование для Путешествие в Пекин #98', CAST(816.00 AS Decimal(10, 2)), CAST(N'2023-10-27' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (459, 99, 6, 3, N'Бронирование для Путешествие в  #99', CAST(156.00 AS Decimal(10, 2)), CAST(N'2023-04-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (460, 100, 5, 3, N'Бронирование для Путешествие в  #100', CAST(1012.00 AS Decimal(10, 2)), CAST(N'2023-02-24' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (461, 101, 3, 2, N'Бронирование для Путешествие в Дубай #101', CAST(515.00 AS Decimal(10, 2)), CAST(N'2024-01-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (462, 102, 1, 2, N'Бронирование для Путешествие в Нью-Йорк #102', CAST(538.00 AS Decimal(10, 2)), CAST(N'2023-01-06' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (463, 103, 5, 4, N'Бронирование для Путешествие в  #103', CAST(357.00 AS Decimal(10, 2)), CAST(N'2023-08-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (464, 104, 4, 1, N'Бронирование для Путешествие в  #104', CAST(126.00 AS Decimal(10, 2)), CAST(N'2023-03-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (465, 105, 6, 4, N'Бронирование для Путешествие в Берлин #105', CAST(719.00 AS Decimal(10, 2)), CAST(N'2024-08-11' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (466, 106, 7, 3, N'Бронирование для Путешествие в  #106', CAST(449.00 AS Decimal(10, 2)), CAST(N'2023-05-19' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (467, 107, 7, 2, N'Бронирование для Путешествие в Лондон #107', CAST(999.00 AS Decimal(10, 2)), CAST(N'2024-07-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (468, 108, 7, 2, N'Бронирование для Путешествие в Париж #108', CAST(603.00 AS Decimal(10, 2)), CAST(N'2024-07-01' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (469, 109, 6, 2, N'Бронирование для Путешествие в  #109', CAST(245.00 AS Decimal(10, 2)), CAST(N'2023-04-28' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (470, 110, 6, 1, N'Бронирование для Путешествие в  #110', CAST(793.00 AS Decimal(10, 2)), CAST(N'2023-01-02' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (471, 111, 6, 4, N'Бронирование для Путешествие в  #111', CAST(1017.00 AS Decimal(10, 2)), CAST(N'2023-02-14' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (472, 112, 2, 2, N'Бронирование для Путешествие в Рим #112', CAST(95.00 AS Decimal(10, 2)), CAST(N'2024-11-10' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (473, 113, 5, 1, N'Бронирование для Путешествие в Дубай #113', CAST(276.00 AS Decimal(10, 2)), CAST(N'2023-04-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (474, 114, 3, 4, N'Бронирование для Путешествие в Париж #114', CAST(358.00 AS Decimal(10, 2)), CAST(N'2023-06-20' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (475, 115, 1, 2, N'Бронирование для Путешествие в Дубай #115', CAST(352.00 AS Decimal(10, 2)), CAST(N'2024-02-29' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (476, 116, 7, 2, N'Бронирование для Путешествие в  #116', CAST(181.00 AS Decimal(10, 2)), CAST(N'2023-07-18' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (477, 117, 3, 2, N'Бронирование для Путешествие в Барселону #117', CAST(961.00 AS Decimal(10, 2)), CAST(N'2024-01-17' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (478, 118, 3, 4, N'Бронирование для Путешествие в Лондон #118', CAST(619.00 AS Decimal(10, 2)), CAST(N'2023-06-22' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (479, 119, 5, 3, N'Бронирование для Путешествие в Нью-Йорк #119', CAST(1007.00 AS Decimal(10, 2)), CAST(N'2023-11-25' AS Date))
GO
INSERT [dbo].[bookings] ([id], [trip_id], [booking_type_id], [status_id], [title], [price], [booking_date]) VALUES (480, 120, 7, 3, N'Бронирование для Путешествие в  #120', CAST(213.00 AS Decimal(10, 2)), CAST(N'2023-03-28' AS Date))
GO
SET IDENTITY_INSERT [dbo].[bookings] OFF
GO
SET IDENTITY_INSERT [dbo].[documents] ON 
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (1, 1, NULL, N'DOC004074', CAST(N'2027-12-17' AS Date), N'/docs/user_1_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (2, 2, N'visa', N'DOC007327', CAST(N'2027-05-30' AS Date), N'/docs/user_2_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (3, 3, N'visa', N'DOC007394', CAST(N'2026-06-04' AS Date), N'/docs/user_3_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (4, 4, N'insurance', N'DOC004608', CAST(N'2026-11-16' AS Date), N'/docs/user_4_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (5, 5, NULL, N'DOC000418', CAST(N'2027-05-20' AS Date), N'/docs/user_5_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (6, 6, NULL, N'DOC006539', CAST(N'2026-11-14' AS Date), N'/docs/user_6_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (7, 7, NULL, N'DOC001985', CAST(N'2026-11-16' AS Date), N'/docs/user_7_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (8, 8, NULL, N'DOC007415', CAST(N'2027-02-23' AS Date), N'/docs/user_8_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (9, 9, N'passport', N'DOC001225', CAST(N'2028-04-10' AS Date), N'/docs/user_9_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (10, 10, N'visa', N'DOC001786', CAST(N'2027-09-21' AS Date), N'/docs/user_10_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (11, 11, N'passport', N'DOC001771', CAST(N'2027-04-20' AS Date), N'/docs/user_11_insurance.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (12, 12, NULL, N'DOC008613', CAST(N'2026-06-14' AS Date), N'/docs/user_12_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (13, 13, N'insurance', N'DOC008101', CAST(N'2026-08-24' AS Date), N'/docs/user_13_insurance.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (14, 14, N'visa', N'DOC000934', CAST(N'2026-11-17' AS Date), N'/docs/user_14_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (15, 15, N'passport', N'DOC003778', CAST(N'2027-05-11' AS Date), N'/docs/user_15_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (16, 16, NULL, N'DOC001222', CAST(N'2026-11-15' AS Date), N'/docs/user_16_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (17, 17, N'insurance', N'DOC004234', CAST(N'2028-04-20' AS Date), N'/docs/user_17_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (18, 18, NULL, N'DOC008146', CAST(N'2026-08-10' AS Date), N'/docs/user_18_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (19, 19, NULL, N'DOC006443', CAST(N'2026-09-27' AS Date), N'/docs/user_19_insurance.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (20, 20, NULL, N'DOC003908', CAST(N'2026-11-17' AS Date), N'/docs/user_20_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (21, 1, N'insurance', N'DOC006604', CAST(N'2026-08-12' AS Date), N'/docs/user_1_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (22, 2, N'insurance', N'DOC003875', CAST(N'2027-08-11' AS Date), N'/docs/user_2_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (23, 3, NULL, N'DOC002771', CAST(N'2027-05-14' AS Date), N'/docs/user_3_insurance.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (24, 4, NULL, N'DOC000738', CAST(N'2026-09-17' AS Date), N'/docs/user_4_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (25, 5, N'passport', N'DOC001967', CAST(N'2028-02-07' AS Date), N'/docs/user_5_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (26, 6, N'passport', N'DOC001507', CAST(N'2028-03-22' AS Date), N'/docs/user_6_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (27, 7, N'visa', N'DOC000074', CAST(N'2027-11-18' AS Date), N'/docs/user_7_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (28, 8, N'visa', N'DOC004502', CAST(N'2027-05-11' AS Date), N'/docs/user_8_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (29, 9, N'insurance', N'DOC009735', CAST(N'2026-07-19' AS Date), N'/docs/user_9_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (30, 10, N'visa', N'DOC005386', CAST(N'2028-01-21' AS Date), N'/docs/user_10_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (31, 11, NULL, N'DOC003944', CAST(N'2026-07-19' AS Date), N'/docs/user_11_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (32, 12, N'insurance', N'DOC000479', CAST(N'2027-01-15' AS Date), N'/docs/user_12_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (33, 13, N'insurance', N'DOC007407', CAST(N'2026-12-22' AS Date), N'/docs/user_13_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (34, 14, N'passport', N'DOC008019', CAST(N'2028-01-02' AS Date), N'/docs/user_14_visa.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (35, 15, NULL, N'DOC004571', CAST(N'2027-05-26' AS Date), N'/docs/user_15_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (36, 16, N'insurance', N'DOC001310', CAST(N'2027-08-10' AS Date), N'/docs/user_16_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (37, 17, N'passport', N'DOC002993', CAST(N'2026-11-04' AS Date), N'/docs/user_17_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (38, 18, NULL, N'DOC000241', CAST(N'2027-09-19' AS Date), N'/docs/user_18_passport.pdf')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (39, 19, N'passport', N'DOC008072', CAST(N'2026-11-20' AS Date), N'/docs/user_19_')
GO
INSERT [dbo].[documents] ([id], [user_id], [doc_type], [doc_number], [expiry_date], [file_path]) VALUES (40, 20, N'passport', N'DOC007559', CAST(N'2027-04-15' AS Date), N'/docs/user_20_passport.pdf')
GO
SET IDENTITY_INSERT [dbo].[documents] OFF
GO
SET IDENTITY_INSERT [dbo].[expense_categories] ON 
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (5, N'Авиабилеты')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (16, N'Аптека')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (7, N'Аренда авто')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (18, N'Виза')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (6, N'ЖД билеты')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (12, N'Кафе')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (13, N'Музеи')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (9, N'Отели')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (3, N'Питание')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (2, N'Проживание')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (20, N'Прочее')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (4, N'Развлечения')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (11, N'Рестораны')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (19, N'Связь')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (17, N'Страховка')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (15, N'Сувениры')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (8, N'Такси')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (1, N'Транспорт')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (10, N'Хостелы')
GO
INSERT [dbo].[expense_categories] ([id], [name]) VALUES (14, N'Экскурсии')
GO
SET IDENTITY_INSERT [dbo].[expense_categories] OFF
GO
SET IDENTITY_INSERT [dbo].[expenses] ON 
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1, 1, 6, CAST(170.00 AS Decimal(10, 2)), CAST(N'2024-07-05' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (2, 2, 14, CAST(203.00 AS Decimal(10, 2)), CAST(N'2023-03-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (3, 3, 2, CAST(10.00 AS Decimal(10, 2)), CAST(N'2024-11-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (4, 4, 15, CAST(142.00 AS Decimal(10, 2)), CAST(N'2024-06-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (5, 5, 18, CAST(239.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (6, 6, 5, CAST(42.00 AS Decimal(10, 2)), CAST(N'2024-05-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (7, 7, 6, CAST(393.00 AS Decimal(10, 2)), CAST(N'2023-11-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (8, 8, 14, CAST(154.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (9, 9, 9, CAST(234.00 AS Decimal(10, 2)), CAST(N'2024-03-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (10, 10, 2, CAST(89.00 AS Decimal(10, 2)), CAST(N'2024-04-21' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (11, 11, 20, CAST(47.00 AS Decimal(10, 2)), CAST(N'2023-06-07' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (12, 12, 2, CAST(91.00 AS Decimal(10, 2)), CAST(N'2025-01-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (13, 13, 6, CAST(58.00 AS Decimal(10, 2)), CAST(N'2024-04-03' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (14, 14, 11, CAST(93.00 AS Decimal(10, 2)), CAST(N'2023-03-10' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (15, 15, 7, CAST(255.00 AS Decimal(10, 2)), CAST(N'2023-07-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (16, 16, 13, CAST(468.00 AS Decimal(10, 2)), CAST(N'2024-04-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (17, 17, 20, CAST(451.00 AS Decimal(10, 2)), CAST(N'2025-03-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (18, 18, 18, CAST(354.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (19, 19, 6, CAST(504.00 AS Decimal(10, 2)), CAST(N'2024-08-06' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (20, 20, 10, CAST(67.00 AS Decimal(10, 2)), CAST(N'2023-09-09' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (21, 21, 1, CAST(11.00 AS Decimal(10, 2)), CAST(N'2023-09-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (22, 22, 6, CAST(13.00 AS Decimal(10, 2)), CAST(N'2024-02-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (23, 23, 7, CAST(160.00 AS Decimal(10, 2)), CAST(N'2024-07-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (24, 24, 8, CAST(324.00 AS Decimal(10, 2)), CAST(N'2024-02-12' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (25, 25, 19, CAST(200.00 AS Decimal(10, 2)), CAST(N'2023-06-30' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (26, 26, 4, CAST(89.00 AS Decimal(10, 2)), CAST(N'2024-08-01' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (27, 27, 14, CAST(332.00 AS Decimal(10, 2)), CAST(N'2024-05-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (28, 28, 11, CAST(87.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (29, 29, 13, CAST(81.00 AS Decimal(10, 2)), CAST(N'2023-11-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (30, 30, 6, CAST(310.00 AS Decimal(10, 2)), CAST(N'2024-10-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (31, 31, 14, CAST(53.00 AS Decimal(10, 2)), CAST(N'2023-08-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (32, 32, 15, CAST(200.00 AS Decimal(10, 2)), CAST(N'2025-02-21' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (33, 33, 4, CAST(330.00 AS Decimal(10, 2)), CAST(N'2023-09-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (34, 34, 7, CAST(244.00 AS Decimal(10, 2)), CAST(N'2023-09-13' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (35, 35, 1, CAST(187.00 AS Decimal(10, 2)), CAST(N'2024-12-03' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (36, 36, 13, CAST(66.00 AS Decimal(10, 2)), CAST(N'2024-11-22' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (37, 37, 14, CAST(83.00 AS Decimal(10, 2)), CAST(N'2024-01-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (38, 38, 4, CAST(304.00 AS Decimal(10, 2)), CAST(N'2025-01-06' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (39, 39, 16, CAST(266.00 AS Decimal(10, 2)), CAST(N'2024-12-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (40, 40, 16, CAST(387.00 AS Decimal(10, 2)), CAST(N'2023-12-12' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (41, 41, 14, CAST(151.00 AS Decimal(10, 2)), CAST(N'2024-12-08' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (42, 42, 8, CAST(211.00 AS Decimal(10, 2)), CAST(N'2023-09-24' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (43, 43, 18, CAST(68.00 AS Decimal(10, 2)), CAST(N'2025-09-08' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (44, 44, 10, CAST(318.00 AS Decimal(10, 2)), CAST(N'2023-11-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (45, 45, 16, CAST(349.00 AS Decimal(10, 2)), CAST(N'2024-10-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (46, 46, 20, CAST(261.00 AS Decimal(10, 2)), CAST(N'2023-12-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (47, 47, 18, CAST(275.00 AS Decimal(10, 2)), CAST(N'2025-04-25' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (48, 48, 20, CAST(145.00 AS Decimal(10, 2)), CAST(N'2023-12-01' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (49, 49, 14, CAST(271.00 AS Decimal(10, 2)), CAST(N'2024-10-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (50, 50, 13, CAST(129.00 AS Decimal(10, 2)), CAST(N'2023-11-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (51, 51, 16, CAST(215.00 AS Decimal(10, 2)), CAST(N'2024-10-25' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (52, 52, 11, CAST(141.00 AS Decimal(10, 2)), CAST(N'2023-10-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (53, 53, 12, CAST(219.00 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (54, 54, 20, CAST(318.00 AS Decimal(10, 2)), CAST(N'2024-08-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (55, 55, 5, CAST(183.00 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (56, 56, 16, CAST(407.00 AS Decimal(10, 2)), CAST(N'2025-09-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (57, 57, 3, CAST(203.00 AS Decimal(10, 2)), CAST(N'2023-04-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (58, 58, 15, CAST(353.00 AS Decimal(10, 2)), CAST(N'2025-04-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (59, 59, 3, CAST(408.00 AS Decimal(10, 2)), CAST(N'2025-03-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (60, 60, 4, CAST(159.00 AS Decimal(10, 2)), CAST(N'2024-08-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (61, 61, 2, CAST(415.00 AS Decimal(10, 2)), CAST(N'2025-04-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (62, 62, 19, CAST(444.00 AS Decimal(10, 2)), CAST(N'2024-12-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (63, 63, 15, CAST(59.00 AS Decimal(10, 2)), CAST(N'2025-01-08' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (64, 64, 16, CAST(195.00 AS Decimal(10, 2)), CAST(N'2025-03-12' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (65, 65, 15, CAST(284.00 AS Decimal(10, 2)), CAST(N'2024-03-15' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (66, 66, 4, CAST(496.00 AS Decimal(10, 2)), CAST(N'2025-06-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (67, 67, 16, CAST(463.00 AS Decimal(10, 2)), CAST(N'2024-09-11' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (68, 68, 6, CAST(429.00 AS Decimal(10, 2)), CAST(N'2023-07-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (69, 69, 20, CAST(374.00 AS Decimal(10, 2)), CAST(N'2025-02-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (70, 70, 8, CAST(353.00 AS Decimal(10, 2)), CAST(N'2024-07-01' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (71, 71, 13, CAST(486.00 AS Decimal(10, 2)), CAST(N'2023-05-20' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (72, 72, 17, CAST(57.00 AS Decimal(10, 2)), CAST(N'2023-06-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (73, 73, 1, CAST(337.00 AS Decimal(10, 2)), CAST(N'2024-06-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (74, 74, 11, CAST(368.00 AS Decimal(10, 2)), CAST(N'2025-02-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (75, 75, 1, CAST(503.00 AS Decimal(10, 2)), CAST(N'2023-12-19' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (76, 76, 10, CAST(383.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (77, 77, 2, CAST(312.00 AS Decimal(10, 2)), CAST(N'2023-12-03' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (78, 78, 8, CAST(395.00 AS Decimal(10, 2)), CAST(N'2025-06-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (79, 79, 16, CAST(359.00 AS Decimal(10, 2)), CAST(N'2024-08-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (80, 80, 8, CAST(232.00 AS Decimal(10, 2)), CAST(N'2024-01-06' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (81, 81, 1, CAST(62.00 AS Decimal(10, 2)), CAST(N'2024-08-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (82, 82, 17, CAST(151.00 AS Decimal(10, 2)), CAST(N'2024-07-03' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (83, 83, 10, CAST(317.00 AS Decimal(10, 2)), CAST(N'2023-07-16' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (84, 84, 14, CAST(36.00 AS Decimal(10, 2)), CAST(N'2024-11-23' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (85, 85, 6, CAST(177.00 AS Decimal(10, 2)), CAST(N'2024-07-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (86, 86, 3, CAST(12.00 AS Decimal(10, 2)), CAST(N'2023-11-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (87, 87, 12, CAST(197.00 AS Decimal(10, 2)), CAST(N'2023-12-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (88, 88, 2, CAST(153.00 AS Decimal(10, 2)), CAST(N'2023-11-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (89, 89, 16, CAST(470.00 AS Decimal(10, 2)), CAST(N'2024-04-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (90, 90, 17, CAST(72.00 AS Decimal(10, 2)), CAST(N'2023-08-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (91, 91, 10, CAST(162.00 AS Decimal(10, 2)), CAST(N'2023-11-17' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (92, 92, 15, CAST(390.00 AS Decimal(10, 2)), CAST(N'2024-12-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (93, 93, 1, CAST(428.00 AS Decimal(10, 2)), CAST(N'2024-06-01' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (94, 94, 18, CAST(269.00 AS Decimal(10, 2)), CAST(N'2024-06-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (95, 95, 9, CAST(27.00 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (96, 96, 20, CAST(161.00 AS Decimal(10, 2)), CAST(N'2024-08-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (97, 97, 11, CAST(367.00 AS Decimal(10, 2)), CAST(N'2024-12-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (98, 98, 1, CAST(353.00 AS Decimal(10, 2)), CAST(N'2024-03-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (99, 99, 15, CAST(472.00 AS Decimal(10, 2)), CAST(N'2023-06-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (100, 100, 14, CAST(230.00 AS Decimal(10, 2)), CAST(N'2024-04-29' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (101, 101, 14, CAST(378.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (102, 102, 17, CAST(73.00 AS Decimal(10, 2)), CAST(N'2023-04-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (103, 103, 9, CAST(44.00 AS Decimal(10, 2)), CAST(N'2024-03-24' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (104, 104, 13, CAST(498.00 AS Decimal(10, 2)), CAST(N'2023-03-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (105, 105, 14, CAST(194.00 AS Decimal(10, 2)), CAST(N'2024-08-17' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (106, 106, 1, CAST(441.00 AS Decimal(10, 2)), CAST(N'2023-08-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (107, 107, 8, CAST(276.00 AS Decimal(10, 2)), CAST(N'2025-12-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (108, 108, 18, CAST(12.00 AS Decimal(10, 2)), CAST(N'2024-07-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (109, 109, 5, CAST(478.00 AS Decimal(10, 2)), CAST(N'2023-07-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (110, 110, 19, CAST(425.00 AS Decimal(10, 2)), CAST(N'2023-03-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (111, 111, 6, CAST(12.00 AS Decimal(10, 2)), CAST(N'2023-05-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (112, 112, 1, CAST(131.00 AS Decimal(10, 2)), CAST(N'2025-11-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (113, 113, 3, CAST(54.00 AS Decimal(10, 2)), CAST(N'2023-10-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (114, 114, 16, CAST(21.00 AS Decimal(10, 2)), CAST(N'2023-10-31' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (115, 115, 15, CAST(471.00 AS Decimal(10, 2)), CAST(N'2024-08-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (116, 116, 8, CAST(406.00 AS Decimal(10, 2)), CAST(N'2023-10-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (117, 117, 13, CAST(423.00 AS Decimal(10, 2)), CAST(N'2024-07-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (118, 118, 9, CAST(399.00 AS Decimal(10, 2)), CAST(N'2023-10-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (119, 119, 6, CAST(28.00 AS Decimal(10, 2)), CAST(N'2024-05-30' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (120, 120, 10, CAST(43.00 AS Decimal(10, 2)), CAST(N'2023-07-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (121, 1, 17, CAST(32.00 AS Decimal(10, 2)), CAST(N'2024-06-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (122, 2, 12, CAST(41.00 AS Decimal(10, 2)), CAST(N'2024-01-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (123, 3, 13, CAST(103.00 AS Decimal(10, 2)), CAST(N'2024-08-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (124, 4, 18, CAST(274.00 AS Decimal(10, 2)), CAST(N'2024-04-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (125, 5, 15, CAST(341.00 AS Decimal(10, 2)), CAST(N'2024-09-09' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (126, 6, 10, CAST(392.00 AS Decimal(10, 2)), CAST(N'2023-12-18' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (127, 7, 6, CAST(479.00 AS Decimal(10, 2)), CAST(N'2023-12-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (128, 8, 18, CAST(298.00 AS Decimal(10, 2)), CAST(N'2024-09-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (129, 9, 3, CAST(336.00 AS Decimal(10, 2)), CAST(N'2023-10-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (130, 10, 12, CAST(48.00 AS Decimal(10, 2)), CAST(N'2024-04-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (131, 11, 10, CAST(505.00 AS Decimal(10, 2)), CAST(N'2023-06-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (132, 12, 19, CAST(110.00 AS Decimal(10, 2)), CAST(N'2024-12-09' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (133, 13, 4, CAST(134.00 AS Decimal(10, 2)), CAST(N'2024-06-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (134, 14, 7, CAST(228.00 AS Decimal(10, 2)), CAST(N'2023-03-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (135, 15, 14, CAST(416.00 AS Decimal(10, 2)), CAST(N'2024-05-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (136, 16, 11, CAST(356.00 AS Decimal(10, 2)), CAST(N'2024-04-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (137, 17, 7, CAST(482.00 AS Decimal(10, 2)), CAST(N'2025-03-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (138, 18, 8, CAST(185.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (139, 19, 13, CAST(144.00 AS Decimal(10, 2)), CAST(N'2024-04-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (140, 20, 15, CAST(230.00 AS Decimal(10, 2)), CAST(N'2023-10-28' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (141, 21, 12, CAST(58.00 AS Decimal(10, 2)), CAST(N'2024-06-23' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (142, 22, 16, CAST(313.00 AS Decimal(10, 2)), CAST(N'2024-04-10' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (143, 23, 16, CAST(488.00 AS Decimal(10, 2)), CAST(N'2024-07-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (144, 24, 14, CAST(405.00 AS Decimal(10, 2)), CAST(N'2024-02-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (145, 25, 14, CAST(438.00 AS Decimal(10, 2)), CAST(N'2023-06-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (146, 26, 12, CAST(229.00 AS Decimal(10, 2)), CAST(N'2024-07-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (147, 27, 18, CAST(263.00 AS Decimal(10, 2)), CAST(N'2023-05-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (148, 28, 3, CAST(257.00 AS Decimal(10, 2)), CAST(N'2024-07-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (149, 29, 1, CAST(89.00 AS Decimal(10, 2)), CAST(N'2024-01-20' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (150, 30, 16, CAST(385.00 AS Decimal(10, 2)), CAST(N'2024-10-22' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (151, 31, 13, CAST(274.00 AS Decimal(10, 2)), CAST(N'2023-08-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (152, 32, 9, CAST(166.00 AS Decimal(10, 2)), CAST(N'2025-01-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (153, 33, 11, CAST(22.00 AS Decimal(10, 2)), CAST(N'2023-10-20' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (154, 34, 8, CAST(12.00 AS Decimal(10, 2)), CAST(N'2023-12-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (155, 35, 14, CAST(112.00 AS Decimal(10, 2)), CAST(N'2024-09-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (156, 36, 2, CAST(13.00 AS Decimal(10, 2)), CAST(N'2024-11-14' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (157, 37, 2, CAST(37.00 AS Decimal(10, 2)), CAST(N'2024-01-11' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (158, 38, 20, CAST(447.00 AS Decimal(10, 2)), CAST(N'2025-01-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (159, 39, 7, CAST(136.00 AS Decimal(10, 2)), CAST(N'2024-11-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (160, 40, 18, CAST(241.00 AS Decimal(10, 2)), CAST(N'2023-12-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (161, 41, 17, CAST(381.00 AS Decimal(10, 2)), CAST(N'2025-01-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (162, 42, 2, CAST(12.00 AS Decimal(10, 2)), CAST(N'2023-09-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (163, 43, 3, CAST(148.00 AS Decimal(10, 2)), CAST(N'2025-07-24' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (164, 44, 7, CAST(329.00 AS Decimal(10, 2)), CAST(N'2023-12-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (165, 45, 20, CAST(225.00 AS Decimal(10, 2)), CAST(N'2024-07-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (166, 46, 9, CAST(212.00 AS Decimal(10, 2)), CAST(N'2024-03-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (167, 47, 3, CAST(313.00 AS Decimal(10, 2)), CAST(N'2025-02-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (168, 48, 15, CAST(422.00 AS Decimal(10, 2)), CAST(N'2023-09-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (169, 49, 10, CAST(215.00 AS Decimal(10, 2)), CAST(N'2024-10-05' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (170, 50, 8, CAST(434.00 AS Decimal(10, 2)), CAST(N'2023-12-23' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (171, 51, 8, CAST(347.00 AS Decimal(10, 2)), CAST(N'2024-11-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (172, 52, 9, CAST(342.00 AS Decimal(10, 2)), CAST(N'2024-01-17' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (173, 53, 17, CAST(204.00 AS Decimal(10, 2)), CAST(N'2024-04-21' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (174, 54, 7, CAST(116.00 AS Decimal(10, 2)), CAST(N'2024-08-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (175, 55, 12, CAST(137.00 AS Decimal(10, 2)), CAST(N'2024-12-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (176, 56, 10, CAST(67.00 AS Decimal(10, 2)), CAST(N'2024-11-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (177, 57, 18, CAST(88.00 AS Decimal(10, 2)), CAST(N'2023-11-14' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (178, 58, 5, CAST(266.00 AS Decimal(10, 2)), CAST(N'2024-12-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (179, 59, 17, CAST(194.00 AS Decimal(10, 2)), CAST(N'2025-01-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (180, 60, 4, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-06-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (181, 61, 17, CAST(231.00 AS Decimal(10, 2)), CAST(N'2025-02-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (182, 62, 19, CAST(109.00 AS Decimal(10, 2)), CAST(N'2024-12-07' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (183, 63, 3, CAST(59.00 AS Decimal(10, 2)), CAST(N'2025-03-25' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (184, 64, 13, CAST(346.00 AS Decimal(10, 2)), CAST(N'2024-11-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (185, 65, 10, CAST(230.00 AS Decimal(10, 2)), CAST(N'2024-04-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (186, 66, 3, CAST(493.00 AS Decimal(10, 2)), CAST(N'2024-11-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (187, 67, 9, CAST(219.00 AS Decimal(10, 2)), CAST(N'2024-07-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (188, 68, 2, CAST(335.00 AS Decimal(10, 2)), CAST(N'2023-11-27' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (189, 69, 20, CAST(470.00 AS Decimal(10, 2)), CAST(N'2024-12-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (190, 70, 3, CAST(163.00 AS Decimal(10, 2)), CAST(N'2023-09-04' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (191, 71, 14, CAST(145.00 AS Decimal(10, 2)), CAST(N'2024-01-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (192, 72, 10, CAST(134.00 AS Decimal(10, 2)), CAST(N'2023-10-13' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (193, 73, 19, CAST(455.00 AS Decimal(10, 2)), CAST(N'2024-06-03' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (194, 74, 12, CAST(77.00 AS Decimal(10, 2)), CAST(N'2025-02-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (195, 75, 18, CAST(485.00 AS Decimal(10, 2)), CAST(N'2024-06-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (196, 76, 14, CAST(309.00 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (197, 77, 18, CAST(215.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (198, 78, 11, CAST(427.00 AS Decimal(10, 2)), CAST(N'2025-05-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (199, 79, 10, CAST(63.00 AS Decimal(10, 2)), CAST(N'2024-08-03' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (200, 80, 10, CAST(276.00 AS Decimal(10, 2)), CAST(N'2023-10-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (201, 81, 6, CAST(14.00 AS Decimal(10, 2)), CAST(N'2024-07-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (202, 82, 2, CAST(410.00 AS Decimal(10, 2)), CAST(N'2024-10-29' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (203, 83, 14, CAST(464.00 AS Decimal(10, 2)), CAST(N'2023-10-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (204, 84, 12, CAST(455.00 AS Decimal(10, 2)), CAST(N'2023-11-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (205, 85, 17, CAST(414.00 AS Decimal(10, 2)), CAST(N'2024-04-29' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (206, 86, 5, CAST(450.00 AS Decimal(10, 2)), CAST(N'2023-12-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (207, 87, 6, CAST(256.00 AS Decimal(10, 2)), CAST(N'2024-04-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (208, 88, 12, CAST(165.00 AS Decimal(10, 2)), CAST(N'2023-11-22' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (209, 89, 11, CAST(181.00 AS Decimal(10, 2)), CAST(N'2024-07-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (210, 90, 4, CAST(425.00 AS Decimal(10, 2)), CAST(N'2024-01-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (211, 91, 15, CAST(371.00 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (212, 92, 7, CAST(122.00 AS Decimal(10, 2)), CAST(N'2024-11-29' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (213, 93, 1, CAST(285.00 AS Decimal(10, 2)), CAST(N'2024-10-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (214, 94, 12, CAST(501.00 AS Decimal(10, 2)), CAST(N'2024-04-04' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (215, 95, 10, CAST(423.00 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (216, 96, 1, CAST(412.00 AS Decimal(10, 2)), CAST(N'2024-11-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (217, 97, 7, CAST(104.00 AS Decimal(10, 2)), CAST(N'2024-11-02' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (218, 98, 13, CAST(315.00 AS Decimal(10, 2)), CAST(N'2023-12-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (219, 99, 20, CAST(125.00 AS Decimal(10, 2)), CAST(N'2023-06-17' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (220, 100, 17, CAST(400.00 AS Decimal(10, 2)), CAST(N'2024-03-27' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (221, 101, 6, CAST(197.00 AS Decimal(10, 2)), CAST(N'2024-02-29' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (222, 102, 16, CAST(236.00 AS Decimal(10, 2)), CAST(N'2023-10-16' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (223, 103, 20, CAST(41.00 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (224, 104, 1, CAST(283.00 AS Decimal(10, 2)), CAST(N'2023-08-06' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (225, 105, 2, CAST(484.00 AS Decimal(10, 2)), CAST(N'2024-09-06' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (226, 106, 1, CAST(460.00 AS Decimal(10, 2)), CAST(N'2023-11-01' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (227, 107, 15, CAST(81.00 AS Decimal(10, 2)), CAST(N'2024-09-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (228, 108, 18, CAST(500.00 AS Decimal(10, 2)), CAST(N'2024-07-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (229, 109, 4, CAST(166.00 AS Decimal(10, 2)), CAST(N'2024-01-09' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (230, 110, 7, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-01-15' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (231, 111, 2, CAST(484.00 AS Decimal(10, 2)), CAST(N'2023-03-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (232, 112, 4, CAST(47.00 AS Decimal(10, 2)), CAST(N'2025-07-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (233, 113, 15, CAST(479.00 AS Decimal(10, 2)), CAST(N'2023-12-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (234, 114, 20, CAST(246.00 AS Decimal(10, 2)), CAST(N'2023-10-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (235, 115, 11, CAST(110.00 AS Decimal(10, 2)), CAST(N'2024-04-11' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (236, 116, 2, CAST(32.00 AS Decimal(10, 2)), CAST(N'2023-09-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (237, 117, 11, CAST(275.00 AS Decimal(10, 2)), CAST(N'2024-07-19' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (238, 118, 18, CAST(315.00 AS Decimal(10, 2)), CAST(N'2023-11-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (239, 119, 4, CAST(416.00 AS Decimal(10, 2)), CAST(N'2024-10-30' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (240, 120, 6, CAST(156.00 AS Decimal(10, 2)), CAST(N'2023-06-23' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (241, 1, 9, CAST(474.00 AS Decimal(10, 2)), CAST(N'2023-12-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (242, 2, 19, CAST(130.00 AS Decimal(10, 2)), CAST(N'2023-03-17' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (243, 3, 6, CAST(293.00 AS Decimal(10, 2)), CAST(N'2024-07-09' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (244, 4, 10, CAST(363.00 AS Decimal(10, 2)), CAST(N'2024-09-29' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (245, 5, 1, CAST(340.00 AS Decimal(10, 2)), CAST(N'2024-07-22' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (246, 6, 3, CAST(112.00 AS Decimal(10, 2)), CAST(N'2023-11-22' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (247, 7, 18, CAST(223.00 AS Decimal(10, 2)), CAST(N'2023-05-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (248, 8, 9, CAST(505.00 AS Decimal(10, 2)), CAST(N'2024-07-24' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (249, 9, 16, CAST(492.00 AS Decimal(10, 2)), CAST(N'2023-10-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (250, 10, 1, CAST(374.00 AS Decimal(10, 2)), CAST(N'2024-04-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (251, 11, 10, CAST(120.00 AS Decimal(10, 2)), CAST(N'2023-08-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (252, 12, 10, CAST(111.00 AS Decimal(10, 2)), CAST(N'2025-01-25' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (253, 13, 3, CAST(215.00 AS Decimal(10, 2)), CAST(N'2024-03-09' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (254, 14, 10, CAST(152.00 AS Decimal(10, 2)), CAST(N'2023-03-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (255, 15, 18, CAST(385.00 AS Decimal(10, 2)), CAST(N'2023-12-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (256, 16, 6, CAST(439.00 AS Decimal(10, 2)), CAST(N'2024-04-28' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (257, 17, 12, CAST(142.00 AS Decimal(10, 2)), CAST(N'2025-02-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (258, 18, 18, CAST(47.00 AS Decimal(10, 2)), CAST(N'2024-02-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (259, 19, 8, CAST(443.00 AS Decimal(10, 2)), CAST(N'2024-08-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (260, 20, 7, CAST(460.00 AS Decimal(10, 2)), CAST(N'2023-10-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (261, 21, 13, CAST(430.00 AS Decimal(10, 2)), CAST(N'2023-10-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (262, 22, 20, CAST(322.00 AS Decimal(10, 2)), CAST(N'2023-11-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (263, 23, 14, CAST(322.00 AS Decimal(10, 2)), CAST(N'2024-08-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (264, 24, 19, CAST(174.00 AS Decimal(10, 2)), CAST(N'2024-02-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (265, 25, 6, CAST(177.00 AS Decimal(10, 2)), CAST(N'2023-11-16' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (266, 26, 10, CAST(294.00 AS Decimal(10, 2)), CAST(N'2024-06-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (267, 27, 16, CAST(76.00 AS Decimal(10, 2)), CAST(N'2024-01-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (268, 28, 14, CAST(261.00 AS Decimal(10, 2)), CAST(N'2024-04-07' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (269, 29, 5, CAST(132.00 AS Decimal(10, 2)), CAST(N'2024-01-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (270, 30, 20, CAST(215.00 AS Decimal(10, 2)), CAST(N'2024-10-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (271, 31, 2, CAST(131.00 AS Decimal(10, 2)), CAST(N'2024-06-03' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (272, 32, 6, CAST(279.00 AS Decimal(10, 2)), CAST(N'2025-03-18' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (273, 33, 11, CAST(277.00 AS Decimal(10, 2)), CAST(N'2023-10-25' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (274, 34, 12, CAST(130.00 AS Decimal(10, 2)), CAST(N'2023-11-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (275, 35, 2, CAST(241.00 AS Decimal(10, 2)), CAST(N'2024-07-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (276, 36, 4, CAST(253.00 AS Decimal(10, 2)), CAST(N'2024-11-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (277, 37, 2, CAST(290.00 AS Decimal(10, 2)), CAST(N'2024-01-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (278, 38, 18, CAST(269.00 AS Decimal(10, 2)), CAST(N'2025-01-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (279, 39, 10, CAST(231.00 AS Decimal(10, 2)), CAST(N'2024-10-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (280, 40, 6, CAST(385.00 AS Decimal(10, 2)), CAST(N'2023-11-09' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (281, 41, 14, CAST(104.00 AS Decimal(10, 2)), CAST(N'2025-07-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (282, 42, 16, CAST(79.00 AS Decimal(10, 2)), CAST(N'2023-09-20' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (283, 43, 18, CAST(244.00 AS Decimal(10, 2)), CAST(N'2025-06-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (284, 44, 8, CAST(360.00 AS Decimal(10, 2)), CAST(N'2023-12-06' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (285, 45, 17, CAST(364.00 AS Decimal(10, 2)), CAST(N'2024-11-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (286, 46, 11, CAST(325.00 AS Decimal(10, 2)), CAST(N'2024-01-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (287, 47, 20, CAST(55.00 AS Decimal(10, 2)), CAST(N'2025-06-23' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (288, 48, 20, CAST(62.00 AS Decimal(10, 2)), CAST(N'2023-03-05' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (289, 49, 13, CAST(251.00 AS Decimal(10, 2)), CAST(N'2024-09-15' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (290, 50, 3, CAST(442.00 AS Decimal(10, 2)), CAST(N'2024-01-11' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (291, 51, 8, CAST(506.00 AS Decimal(10, 2)), CAST(N'2024-07-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (292, 52, 13, CAST(197.00 AS Decimal(10, 2)), CAST(N'2024-02-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (293, 53, 11, CAST(399.00 AS Decimal(10, 2)), CAST(N'2024-05-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (294, 54, 20, CAST(263.00 AS Decimal(10, 2)), CAST(N'2024-07-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (295, 55, 10, CAST(345.00 AS Decimal(10, 2)), CAST(N'2024-06-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (296, 56, 18, CAST(340.00 AS Decimal(10, 2)), CAST(N'2025-09-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (297, 57, 1, CAST(105.00 AS Decimal(10, 2)), CAST(N'2023-08-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (298, 58, 6, CAST(506.00 AS Decimal(10, 2)), CAST(N'2025-01-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (299, 59, 20, CAST(217.00 AS Decimal(10, 2)), CAST(N'2024-10-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (300, 60, 8, CAST(164.00 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (301, 61, 7, CAST(440.00 AS Decimal(10, 2)), CAST(N'2025-12-09' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (302, 62, 8, CAST(445.00 AS Decimal(10, 2)), CAST(N'2024-08-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (303, 63, 15, CAST(388.00 AS Decimal(10, 2)), CAST(N'2025-03-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (304, 64, 17, CAST(257.00 AS Decimal(10, 2)), CAST(N'2025-03-11' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (305, 65, 11, CAST(13.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (306, 66, 13, CAST(509.00 AS Decimal(10, 2)), CAST(N'2025-01-14' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (307, 67, 15, CAST(44.00 AS Decimal(10, 2)), CAST(N'2024-11-15' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (308, 68, 14, CAST(471.00 AS Decimal(10, 2)), CAST(N'2023-07-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (309, 69, 9, CAST(423.00 AS Decimal(10, 2)), CAST(N'2024-12-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (310, 70, 2, CAST(446.00 AS Decimal(10, 2)), CAST(N'2023-03-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (311, 71, 1, CAST(373.00 AS Decimal(10, 2)), CAST(N'2024-08-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (312, 72, 3, CAST(106.00 AS Decimal(10, 2)), CAST(N'2023-11-17' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (313, 73, 11, CAST(488.00 AS Decimal(10, 2)), CAST(N'2024-06-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (314, 74, 6, CAST(442.00 AS Decimal(10, 2)), CAST(N'2025-02-09' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (315, 75, 13, CAST(458.00 AS Decimal(10, 2)), CAST(N'2023-11-05' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (316, 76, 15, CAST(152.00 AS Decimal(10, 2)), CAST(N'2024-05-29' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (317, 77, 19, CAST(45.00 AS Decimal(10, 2)), CAST(N'2023-10-06' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (318, 78, 16, CAST(108.00 AS Decimal(10, 2)), CAST(N'2025-11-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (319, 79, 12, CAST(414.00 AS Decimal(10, 2)), CAST(N'2024-12-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (320, 80, 1, CAST(60.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (321, 81, 18, CAST(326.00 AS Decimal(10, 2)), CAST(N'2024-07-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (322, 82, 3, CAST(279.00 AS Decimal(10, 2)), CAST(N'2024-04-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (323, 83, 4, CAST(260.00 AS Decimal(10, 2)), CAST(N'2023-06-19' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (324, 84, 12, CAST(153.00 AS Decimal(10, 2)), CAST(N'2024-05-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (325, 85, 9, CAST(371.00 AS Decimal(10, 2)), CAST(N'2024-02-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (326, 86, 9, CAST(214.00 AS Decimal(10, 2)), CAST(N'2023-06-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (327, 87, 3, CAST(169.00 AS Decimal(10, 2)), CAST(N'2023-11-30' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (328, 88, 20, CAST(24.00 AS Decimal(10, 2)), CAST(N'2023-10-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (329, 89, 16, CAST(474.00 AS Decimal(10, 2)), CAST(N'2024-09-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (330, 90, 4, CAST(428.00 AS Decimal(10, 2)), CAST(N'2023-08-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (331, 91, 18, CAST(295.00 AS Decimal(10, 2)), CAST(N'2023-10-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (332, 92, 6, CAST(291.00 AS Decimal(10, 2)), CAST(N'2024-09-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (333, 93, 19, CAST(45.00 AS Decimal(10, 2)), CAST(N'2024-04-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (334, 94, 7, CAST(410.00 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (335, 95, 5, CAST(467.00 AS Decimal(10, 2)), CAST(N'2024-03-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (336, 96, 14, CAST(224.00 AS Decimal(10, 2)), CAST(N'2024-08-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (337, 97, 18, CAST(405.00 AS Decimal(10, 2)), CAST(N'2024-10-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (338, 98, 18, CAST(41.00 AS Decimal(10, 2)), CAST(N'2023-12-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (339, 99, 1, CAST(427.00 AS Decimal(10, 2)), CAST(N'2023-06-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (340, 100, 3, CAST(28.00 AS Decimal(10, 2)), CAST(N'2023-04-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (341, 101, 17, CAST(106.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (342, 102, 9, CAST(22.00 AS Decimal(10, 2)), CAST(N'2023-10-31' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (343, 103, 2, CAST(251.00 AS Decimal(10, 2)), CAST(N'2023-12-29' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (344, 104, 19, CAST(291.00 AS Decimal(10, 2)), CAST(N'2023-04-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (345, 105, 16, CAST(17.00 AS Decimal(10, 2)), CAST(N'2024-10-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (346, 106, 18, CAST(189.00 AS Decimal(10, 2)), CAST(N'2023-10-01' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (347, 107, 4, CAST(28.00 AS Decimal(10, 2)), CAST(N'2025-05-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (348, 108, 11, CAST(345.00 AS Decimal(10, 2)), CAST(N'2024-07-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (349, 109, 2, CAST(210.00 AS Decimal(10, 2)), CAST(N'2023-06-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (350, 110, 16, CAST(337.00 AS Decimal(10, 2)), CAST(N'2023-04-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (351, 111, 1, CAST(156.00 AS Decimal(10, 2)), CAST(N'2023-07-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (352, 112, 2, CAST(453.00 AS Decimal(10, 2)), CAST(N'2025-04-05' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (353, 113, 20, CAST(196.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (354, 114, 5, CAST(305.00 AS Decimal(10, 2)), CAST(N'2023-07-31' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (355, 115, 6, CAST(298.00 AS Decimal(10, 2)), CAST(N'2024-09-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (356, 116, 6, CAST(466.00 AS Decimal(10, 2)), CAST(N'2023-07-23' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (357, 117, 11, CAST(213.00 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (358, 118, 9, CAST(37.00 AS Decimal(10, 2)), CAST(N'2023-07-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (359, 119, 11, CAST(509.00 AS Decimal(10, 2)), CAST(N'2024-10-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (360, 120, 4, CAST(272.00 AS Decimal(10, 2)), CAST(N'2023-05-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (361, 1, 17, CAST(32.00 AS Decimal(10, 2)), CAST(N'2023-12-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (362, 2, 16, CAST(118.00 AS Decimal(10, 2)), CAST(N'2023-11-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (363, 3, 18, CAST(367.00 AS Decimal(10, 2)), CAST(N'2023-11-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (364, 4, 19, CAST(319.00 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (365, 5, 18, CAST(350.00 AS Decimal(10, 2)), CAST(N'2024-08-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (366, 6, 12, CAST(137.00 AS Decimal(10, 2)), CAST(N'2024-06-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (367, 7, 16, CAST(472.00 AS Decimal(10, 2)), CAST(N'2023-05-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (368, 8, 2, CAST(141.00 AS Decimal(10, 2)), CAST(N'2024-07-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (369, 9, 3, CAST(492.00 AS Decimal(10, 2)), CAST(N'2023-09-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (370, 10, 9, CAST(385.00 AS Decimal(10, 2)), CAST(N'2024-04-25' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (371, 11, 10, CAST(159.00 AS Decimal(10, 2)), CAST(N'2023-07-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (372, 12, 5, CAST(500.00 AS Decimal(10, 2)), CAST(N'2024-12-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (373, 13, 8, CAST(313.00 AS Decimal(10, 2)), CAST(N'2024-07-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (374, 14, 19, CAST(35.00 AS Decimal(10, 2)), CAST(N'2023-10-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (375, 15, 12, CAST(12.00 AS Decimal(10, 2)), CAST(N'2023-08-09' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (376, 16, 3, CAST(254.00 AS Decimal(10, 2)), CAST(N'2024-04-14' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (377, 17, 6, CAST(378.00 AS Decimal(10, 2)), CAST(N'2025-03-27' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (378, 18, 7, CAST(242.00 AS Decimal(10, 2)), CAST(N'2023-08-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (379, 19, 4, CAST(268.00 AS Decimal(10, 2)), CAST(N'2023-09-29' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (380, 20, 13, CAST(239.00 AS Decimal(10, 2)), CAST(N'2023-10-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (381, 21, 15, CAST(459.00 AS Decimal(10, 2)), CAST(N'2023-12-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (382, 22, 8, CAST(14.00 AS Decimal(10, 2)), CAST(N'2024-01-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (383, 23, 12, CAST(375.00 AS Decimal(10, 2)), CAST(N'2024-11-17' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (384, 24, 11, CAST(96.00 AS Decimal(10, 2)), CAST(N'2024-02-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (385, 25, 19, CAST(260.00 AS Decimal(10, 2)), CAST(N'2023-12-07' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (386, 26, 13, CAST(494.00 AS Decimal(10, 2)), CAST(N'2024-09-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (387, 27, 6, CAST(469.00 AS Decimal(10, 2)), CAST(N'2024-08-04' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (388, 28, 14, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-07-13' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (389, 29, 3, CAST(162.00 AS Decimal(10, 2)), CAST(N'2023-11-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (390, 30, 16, CAST(497.00 AS Decimal(10, 2)), CAST(N'2024-10-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (391, 31, 10, CAST(323.00 AS Decimal(10, 2)), CAST(N'2024-04-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (392, 32, 8, CAST(11.00 AS Decimal(10, 2)), CAST(N'2024-11-27' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (393, 33, 15, CAST(462.00 AS Decimal(10, 2)), CAST(N'2023-11-05' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (394, 34, 3, CAST(179.00 AS Decimal(10, 2)), CAST(N'2023-10-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (395, 35, 17, CAST(388.00 AS Decimal(10, 2)), CAST(N'2024-07-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (396, 36, 13, CAST(202.00 AS Decimal(10, 2)), CAST(N'2024-11-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (397, 37, 18, CAST(402.00 AS Decimal(10, 2)), CAST(N'2024-01-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (398, 38, 17, CAST(274.00 AS Decimal(10, 2)), CAST(N'2025-03-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (399, 39, 11, CAST(137.00 AS Decimal(10, 2)), CAST(N'2024-12-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (400, 40, 20, CAST(298.00 AS Decimal(10, 2)), CAST(N'2024-01-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (401, 41, 14, CAST(66.00 AS Decimal(10, 2)), CAST(N'2025-03-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (402, 42, 20, CAST(137.00 AS Decimal(10, 2)), CAST(N'2023-10-15' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (403, 43, 15, CAST(112.00 AS Decimal(10, 2)), CAST(N'2025-03-27' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (404, 44, 20, CAST(222.00 AS Decimal(10, 2)), CAST(N'2023-11-29' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (405, 45, 13, CAST(201.00 AS Decimal(10, 2)), CAST(N'2024-08-07' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (406, 46, 3, CAST(363.00 AS Decimal(10, 2)), CAST(N'2024-05-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (407, 47, 12, CAST(328.00 AS Decimal(10, 2)), CAST(N'2024-11-29' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (408, 48, 6, CAST(150.00 AS Decimal(10, 2)), CAST(N'2023-08-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (409, 49, 10, CAST(369.00 AS Decimal(10, 2)), CAST(N'2024-09-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (410, 50, 5, CAST(200.00 AS Decimal(10, 2)), CAST(N'2023-11-21' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (411, 51, 19, CAST(260.00 AS Decimal(10, 2)), CAST(N'2024-12-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (412, 52, 10, CAST(418.00 AS Decimal(10, 2)), CAST(N'2024-03-06' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (413, 53, 6, CAST(346.00 AS Decimal(10, 2)), CAST(N'2024-05-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (414, 54, 9, CAST(194.00 AS Decimal(10, 2)), CAST(N'2024-08-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (415, 55, 17, CAST(276.00 AS Decimal(10, 2)), CAST(N'2024-08-26' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (416, 56, 3, CAST(409.00 AS Decimal(10, 2)), CAST(N'2025-03-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (417, 57, 11, CAST(171.00 AS Decimal(10, 2)), CAST(N'2023-05-23' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (418, 58, 13, CAST(197.00 AS Decimal(10, 2)), CAST(N'2024-11-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (419, 59, 18, CAST(482.00 AS Decimal(10, 2)), CAST(N'2024-08-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (420, 60, 3, CAST(445.00 AS Decimal(10, 2)), CAST(N'2024-03-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (421, 61, 19, CAST(371.00 AS Decimal(10, 2)), CAST(N'2025-08-18' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (422, 62, 2, CAST(354.00 AS Decimal(10, 2)), CAST(N'2024-09-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (423, 63, 17, CAST(60.00 AS Decimal(10, 2)), CAST(N'2025-04-07' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (424, 64, 16, CAST(484.00 AS Decimal(10, 2)), CAST(N'2025-01-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (425, 65, 6, CAST(235.00 AS Decimal(10, 2)), CAST(N'2024-02-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (426, 66, 8, CAST(69.00 AS Decimal(10, 2)), CAST(N'2024-11-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (427, 67, 2, CAST(188.00 AS Decimal(10, 2)), CAST(N'2024-08-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (428, 68, 2, CAST(173.00 AS Decimal(10, 2)), CAST(N'2023-11-14' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (429, 69, 5, CAST(343.00 AS Decimal(10, 2)), CAST(N'2025-02-03' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (430, 70, 16, CAST(482.00 AS Decimal(10, 2)), CAST(N'2024-09-26' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (431, 71, 1, CAST(403.00 AS Decimal(10, 2)), CAST(N'2023-10-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (432, 72, 20, CAST(123.00 AS Decimal(10, 2)), CAST(N'2023-06-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (433, 73, 2, CAST(182.00 AS Decimal(10, 2)), CAST(N'2024-06-04' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (434, 74, 17, CAST(456.00 AS Decimal(10, 2)), CAST(N'2025-06-17' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (435, 75, 1, CAST(92.00 AS Decimal(10, 2)), CAST(N'2024-02-14' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (436, 76, 20, CAST(412.00 AS Decimal(10, 2)), CAST(N'2024-04-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (437, 77, 18, CAST(376.00 AS Decimal(10, 2)), CAST(N'2023-09-07' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (438, 78, 11, CAST(359.00 AS Decimal(10, 2)), CAST(N'2025-05-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (439, 79, 3, CAST(440.00 AS Decimal(10, 2)), CAST(N'2024-12-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (440, 80, 10, CAST(106.00 AS Decimal(10, 2)), CAST(N'2024-04-13' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (441, 81, 9, CAST(75.00 AS Decimal(10, 2)), CAST(N'2024-07-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (442, 82, 15, CAST(161.00 AS Decimal(10, 2)), CAST(N'2024-04-29' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (443, 83, 2, CAST(497.00 AS Decimal(10, 2)), CAST(N'2023-06-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (444, 84, 8, CAST(199.00 AS Decimal(10, 2)), CAST(N'2024-11-23' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (445, 85, 10, CAST(102.00 AS Decimal(10, 2)), CAST(N'2024-06-23' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (446, 86, 6, CAST(114.00 AS Decimal(10, 2)), CAST(N'2023-09-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (447, 87, 7, CAST(328.00 AS Decimal(10, 2)), CAST(N'2024-04-26' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (448, 88, 12, CAST(335.00 AS Decimal(10, 2)), CAST(N'2023-10-09' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (449, 89, 3, CAST(482.00 AS Decimal(10, 2)), CAST(N'2024-06-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (450, 90, 11, CAST(142.00 AS Decimal(10, 2)), CAST(N'2023-11-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (451, 91, 8, CAST(499.00 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (452, 92, 13, CAST(332.00 AS Decimal(10, 2)), CAST(N'2024-10-12' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (453, 93, 4, CAST(19.00 AS Decimal(10, 2)), CAST(N'2024-07-03' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (454, 94, 18, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-06-24' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (455, 95, 15, CAST(138.00 AS Decimal(10, 2)), CAST(N'2024-05-15' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (456, 96, 16, CAST(19.00 AS Decimal(10, 2)), CAST(N'2024-07-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (457, 97, 17, CAST(447.00 AS Decimal(10, 2)), CAST(N'2024-12-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (458, 98, 14, CAST(235.00 AS Decimal(10, 2)), CAST(N'2023-11-24' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (459, 99, 20, CAST(399.00 AS Decimal(10, 2)), CAST(N'2023-05-16' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (460, 100, 5, CAST(363.00 AS Decimal(10, 2)), CAST(N'2023-08-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (461, 101, 4, CAST(431.00 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (462, 102, 11, CAST(169.00 AS Decimal(10, 2)), CAST(N'2023-03-29' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (463, 103, 8, CAST(442.00 AS Decimal(10, 2)), CAST(N'2023-12-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (464, 104, 15, CAST(23.00 AS Decimal(10, 2)), CAST(N'2023-05-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (465, 105, 20, CAST(491.00 AS Decimal(10, 2)), CAST(N'2024-10-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (466, 106, 6, CAST(140.00 AS Decimal(10, 2)), CAST(N'2023-07-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (467, 107, 6, CAST(149.00 AS Decimal(10, 2)), CAST(N'2025-03-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (468, 108, 17, CAST(185.00 AS Decimal(10, 2)), CAST(N'2024-07-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (469, 109, 1, CAST(105.00 AS Decimal(10, 2)), CAST(N'2023-06-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (470, 110, 5, CAST(281.00 AS Decimal(10, 2)), CAST(N'2023-02-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (471, 111, 10, CAST(192.00 AS Decimal(10, 2)), CAST(N'2023-05-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (472, 112, 3, CAST(358.00 AS Decimal(10, 2)), CAST(N'2026-01-12' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (473, 113, 8, CAST(110.00 AS Decimal(10, 2)), CAST(N'2023-08-26' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (474, 114, 10, CAST(91.00 AS Decimal(10, 2)), CAST(N'2023-08-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (475, 115, 19, CAST(262.00 AS Decimal(10, 2)), CAST(N'2024-05-28' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (476, 116, 3, CAST(56.00 AS Decimal(10, 2)), CAST(N'2023-08-10' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (477, 117, 18, CAST(146.00 AS Decimal(10, 2)), CAST(N'2024-05-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (478, 118, 18, CAST(455.00 AS Decimal(10, 2)), CAST(N'2024-01-01' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (479, 119, 7, CAST(106.00 AS Decimal(10, 2)), CAST(N'2024-10-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (480, 120, 5, CAST(299.00 AS Decimal(10, 2)), CAST(N'2023-06-29' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (481, 1, 5, CAST(289.00 AS Decimal(10, 2)), CAST(N'2024-05-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (482, 2, 6, CAST(36.00 AS Decimal(10, 2)), CAST(N'2023-06-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (483, 3, 15, CAST(258.00 AS Decimal(10, 2)), CAST(N'2024-05-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (484, 4, 2, CAST(492.00 AS Decimal(10, 2)), CAST(N'2024-06-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (485, 5, 5, CAST(437.00 AS Decimal(10, 2)), CAST(N'2024-06-04' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (486, 6, 1, CAST(506.00 AS Decimal(10, 2)), CAST(N'2024-06-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (487, 7, 13, CAST(25.00 AS Decimal(10, 2)), CAST(N'2023-12-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (488, 8, 18, CAST(464.00 AS Decimal(10, 2)), CAST(N'2024-08-27' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (489, 9, 8, CAST(498.00 AS Decimal(10, 2)), CAST(N'2024-03-12' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (490, 10, 11, CAST(304.00 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (491, 11, 14, CAST(391.00 AS Decimal(10, 2)), CAST(N'2023-07-22' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (492, 12, 3, CAST(285.00 AS Decimal(10, 2)), CAST(N'2025-01-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (493, 13, 5, CAST(324.00 AS Decimal(10, 2)), CAST(N'2024-05-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (494, 14, 2, CAST(308.00 AS Decimal(10, 2)), CAST(N'2023-09-18' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (495, 15, 2, CAST(94.00 AS Decimal(10, 2)), CAST(N'2024-02-17' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (496, 16, 18, CAST(46.00 AS Decimal(10, 2)), CAST(N'2024-04-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (497, 17, 17, CAST(192.00 AS Decimal(10, 2)), CAST(N'2025-03-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (498, 18, 11, CAST(271.00 AS Decimal(10, 2)), CAST(N'2023-06-13' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (499, 19, 20, CAST(390.00 AS Decimal(10, 2)), CAST(N'2024-01-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (500, 20, 18, CAST(164.00 AS Decimal(10, 2)), CAST(N'2023-10-28' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (501, 21, 3, CAST(296.00 AS Decimal(10, 2)), CAST(N'2024-02-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (502, 22, 16, CAST(467.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (503, 23, 3, CAST(293.00 AS Decimal(10, 2)), CAST(N'2025-02-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (504, 24, 12, CAST(31.00 AS Decimal(10, 2)), CAST(N'2024-02-10' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (505, 25, 8, CAST(114.00 AS Decimal(10, 2)), CAST(N'2023-11-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (506, 26, 17, CAST(219.00 AS Decimal(10, 2)), CAST(N'2024-08-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (507, 27, 7, CAST(97.00 AS Decimal(10, 2)), CAST(N'2023-05-05' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (508, 28, 4, CAST(154.00 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (509, 29, 10, CAST(226.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (510, 30, 4, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-09-26' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (511, 31, 5, CAST(454.00 AS Decimal(10, 2)), CAST(N'2023-07-23' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (512, 32, 1, CAST(193.00 AS Decimal(10, 2)), CAST(N'2024-12-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (513, 33, 12, CAST(257.00 AS Decimal(10, 2)), CAST(N'2023-10-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (514, 34, 14, CAST(280.00 AS Decimal(10, 2)), CAST(N'2024-01-15' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (515, 35, 5, CAST(390.00 AS Decimal(10, 2)), CAST(N'2024-07-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (516, 36, 5, CAST(162.00 AS Decimal(10, 2)), CAST(N'2024-11-14' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (517, 37, 19, CAST(34.00 AS Decimal(10, 2)), CAST(N'2024-01-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (518, 38, 16, CAST(127.00 AS Decimal(10, 2)), CAST(N'2025-05-01' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (519, 39, 3, CAST(414.00 AS Decimal(10, 2)), CAST(N'2024-12-12' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (520, 40, 1, CAST(258.00 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (521, 41, 14, CAST(182.00 AS Decimal(10, 2)), CAST(N'2025-06-15' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (522, 42, 16, CAST(207.00 AS Decimal(10, 2)), CAST(N'2023-10-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (523, 43, 3, CAST(212.00 AS Decimal(10, 2)), CAST(N'2025-09-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (524, 44, 17, CAST(107.00 AS Decimal(10, 2)), CAST(N'2023-12-25' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (525, 45, 14, CAST(356.00 AS Decimal(10, 2)), CAST(N'2024-09-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (526, 46, 19, CAST(503.00 AS Decimal(10, 2)), CAST(N'2024-02-14' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (527, 47, 17, CAST(157.00 AS Decimal(10, 2)), CAST(N'2024-08-10' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (528, 48, 12, CAST(377.00 AS Decimal(10, 2)), CAST(N'2023-06-03' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (529, 49, 8, CAST(70.00 AS Decimal(10, 2)), CAST(N'2024-09-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (530, 50, 15, CAST(386.00 AS Decimal(10, 2)), CAST(N'2023-11-07' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (531, 51, 7, CAST(163.00 AS Decimal(10, 2)), CAST(N'2024-09-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (532, 52, 18, CAST(267.00 AS Decimal(10, 2)), CAST(N'2023-12-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (533, 53, 3, CAST(271.00 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (534, 54, 15, CAST(296.00 AS Decimal(10, 2)), CAST(N'2024-08-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (535, 55, 16, CAST(421.00 AS Decimal(10, 2)), CAST(N'2024-11-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (536, 56, 11, CAST(97.00 AS Decimal(10, 2)), CAST(N'2025-04-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (537, 57, 17, CAST(264.00 AS Decimal(10, 2)), CAST(N'2023-04-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (538, 58, 8, CAST(378.00 AS Decimal(10, 2)), CAST(N'2024-12-31' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (539, 59, 7, CAST(150.00 AS Decimal(10, 2)), CAST(N'2025-03-28' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (540, 60, 13, CAST(124.00 AS Decimal(10, 2)), CAST(N'2024-05-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (541, 61, 5, CAST(398.00 AS Decimal(10, 2)), CAST(N'2025-08-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (542, 62, 9, CAST(453.00 AS Decimal(10, 2)), CAST(N'2024-07-22' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (543, 63, 4, CAST(408.00 AS Decimal(10, 2)), CAST(N'2024-11-30' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (544, 64, 11, CAST(286.00 AS Decimal(10, 2)), CAST(N'2025-02-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (545, 65, 6, CAST(440.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (546, 66, 19, CAST(300.00 AS Decimal(10, 2)), CAST(N'2025-03-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (547, 67, 6, CAST(405.00 AS Decimal(10, 2)), CAST(N'2024-09-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (548, 68, 11, CAST(464.00 AS Decimal(10, 2)), CAST(N'2023-11-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (549, 69, 6, CAST(250.00 AS Decimal(10, 2)), CAST(N'2025-01-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (550, 70, 20, CAST(470.00 AS Decimal(10, 2)), CAST(N'2024-07-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (551, 71, 14, CAST(316.00 AS Decimal(10, 2)), CAST(N'2023-11-10' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (552, 72, 7, CAST(323.00 AS Decimal(10, 2)), CAST(N'2023-04-21' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (553, 73, 20, CAST(242.00 AS Decimal(10, 2)), CAST(N'2024-06-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (554, 74, 8, CAST(197.00 AS Decimal(10, 2)), CAST(N'2025-04-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (555, 75, 12, CAST(468.00 AS Decimal(10, 2)), CAST(N'2024-03-22' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (556, 76, 4, CAST(421.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (557, 77, 10, CAST(496.00 AS Decimal(10, 2)), CAST(N'2023-09-03' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (558, 78, 13, CAST(88.00 AS Decimal(10, 2)), CAST(N'2025-01-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (559, 79, 13, CAST(249.00 AS Decimal(10, 2)), CAST(N'2024-03-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (560, 80, 6, CAST(370.00 AS Decimal(10, 2)), CAST(N'2024-02-18' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (561, 81, 1, CAST(221.00 AS Decimal(10, 2)), CAST(N'2024-07-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (562, 82, 19, CAST(286.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (563, 83, 7, CAST(188.00 AS Decimal(10, 2)), CAST(N'2023-11-06' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (564, 84, 12, CAST(48.00 AS Decimal(10, 2)), CAST(N'2024-06-27' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (565, 85, 20, CAST(357.00 AS Decimal(10, 2)), CAST(N'2024-05-11' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (566, 86, 10, CAST(488.00 AS Decimal(10, 2)), CAST(N'2023-05-30' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (567, 87, 17, CAST(463.00 AS Decimal(10, 2)), CAST(N'2024-06-02' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (568, 88, 8, CAST(16.00 AS Decimal(10, 2)), CAST(N'2023-08-04' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (569, 89, 4, CAST(337.00 AS Decimal(10, 2)), CAST(N'2024-06-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (570, 90, 4, CAST(50.00 AS Decimal(10, 2)), CAST(N'2024-05-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (571, 91, 5, CAST(216.00 AS Decimal(10, 2)), CAST(N'2024-06-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (572, 92, 2, CAST(371.00 AS Decimal(10, 2)), CAST(N'2024-09-21' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (573, 93, 3, CAST(167.00 AS Decimal(10, 2)), CAST(N'2024-08-25' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (574, 94, 1, CAST(303.00 AS Decimal(10, 2)), CAST(N'2024-01-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (575, 95, 19, CAST(185.00 AS Decimal(10, 2)), CAST(N'2024-06-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (576, 96, 10, CAST(367.00 AS Decimal(10, 2)), CAST(N'2024-10-24' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (577, 97, 13, CAST(57.00 AS Decimal(10, 2)), CAST(N'2024-10-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (578, 98, 11, CAST(144.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (579, 99, 1, CAST(495.00 AS Decimal(10, 2)), CAST(N'2023-07-09' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (580, 100, 16, CAST(227.00 AS Decimal(10, 2)), CAST(N'2024-01-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (581, 101, 16, CAST(304.00 AS Decimal(10, 2)), CAST(N'2024-03-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (582, 102, 20, CAST(90.00 AS Decimal(10, 2)), CAST(N'2023-03-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (583, 103, 3, CAST(353.00 AS Decimal(10, 2)), CAST(N'2023-09-20' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (584, 104, 7, CAST(469.00 AS Decimal(10, 2)), CAST(N'2023-09-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (585, 105, 14, CAST(87.00 AS Decimal(10, 2)), CAST(N'2024-10-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (586, 106, 5, CAST(190.00 AS Decimal(10, 2)), CAST(N'2023-11-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (587, 107, 14, CAST(391.00 AS Decimal(10, 2)), CAST(N'2025-01-31' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (588, 108, 19, CAST(469.00 AS Decimal(10, 2)), CAST(N'2024-07-21' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (589, 109, 11, CAST(412.00 AS Decimal(10, 2)), CAST(N'2023-12-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (590, 110, 18, CAST(162.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (591, 111, 19, CAST(41.00 AS Decimal(10, 2)), CAST(N'2023-06-07' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (592, 112, 17, CAST(483.00 AS Decimal(10, 2)), CAST(N'2025-02-27' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (593, 113, 11, CAST(225.00 AS Decimal(10, 2)), CAST(N'2023-11-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (594, 114, 4, CAST(281.00 AS Decimal(10, 2)), CAST(N'2023-08-29' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (595, 115, 15, CAST(431.00 AS Decimal(10, 2)), CAST(N'2024-06-01' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (596, 116, 17, CAST(259.00 AS Decimal(10, 2)), CAST(N'2023-11-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (597, 117, 10, CAST(361.00 AS Decimal(10, 2)), CAST(N'2024-01-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (598, 118, 15, CAST(438.00 AS Decimal(10, 2)), CAST(N'2023-10-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (599, 119, 20, CAST(235.00 AS Decimal(10, 2)), CAST(N'2024-05-16' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (600, 120, 12, CAST(347.00 AS Decimal(10, 2)), CAST(N'2023-05-03' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (601, 1, 3, CAST(346.00 AS Decimal(10, 2)), CAST(N'2024-05-29' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (602, 2, 8, CAST(136.00 AS Decimal(10, 2)), CAST(N'2023-07-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (603, 3, 6, CAST(412.00 AS Decimal(10, 2)), CAST(N'2024-07-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (604, 4, 15, CAST(489.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (605, 5, 2, CAST(113.00 AS Decimal(10, 2)), CAST(N'2024-05-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (606, 6, 19, CAST(323.00 AS Decimal(10, 2)), CAST(N'2024-04-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (607, 7, 20, CAST(17.00 AS Decimal(10, 2)), CAST(N'2023-08-27' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (608, 8, 16, CAST(143.00 AS Decimal(10, 2)), CAST(N'2024-10-11' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (609, 9, 16, CAST(194.00 AS Decimal(10, 2)), CAST(N'2023-12-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (610, 10, 6, CAST(40.00 AS Decimal(10, 2)), CAST(N'2024-04-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (611, 11, 7, CAST(294.00 AS Decimal(10, 2)), CAST(N'2023-07-18' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (612, 12, 13, CAST(111.00 AS Decimal(10, 2)), CAST(N'2025-01-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (613, 13, 14, CAST(33.00 AS Decimal(10, 2)), CAST(N'2024-05-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (614, 14, 3, CAST(151.00 AS Decimal(10, 2)), CAST(N'2023-03-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (615, 15, 3, CAST(429.00 AS Decimal(10, 2)), CAST(N'2023-10-26' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (616, 16, 20, CAST(487.00 AS Decimal(10, 2)), CAST(N'2024-04-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (617, 17, 16, CAST(432.00 AS Decimal(10, 2)), CAST(N'2025-03-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (618, 18, 2, CAST(230.00 AS Decimal(10, 2)), CAST(N'2023-06-20' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (619, 19, 18, CAST(179.00 AS Decimal(10, 2)), CAST(N'2024-07-02' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (620, 20, 6, CAST(414.00 AS Decimal(10, 2)), CAST(N'2023-09-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (621, 21, 13, CAST(342.00 AS Decimal(10, 2)), CAST(N'2023-09-08' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (622, 22, 4, CAST(49.00 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (623, 23, 6, CAST(17.00 AS Decimal(10, 2)), CAST(N'2024-12-15' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (624, 24, 3, CAST(500.00 AS Decimal(10, 2)), CAST(N'2024-02-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (625, 25, 9, CAST(311.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (626, 26, 10, CAST(416.00 AS Decimal(10, 2)), CAST(N'2024-09-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (627, 27, 2, CAST(180.00 AS Decimal(10, 2)), CAST(N'2024-12-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (628, 28, 4, CAST(371.00 AS Decimal(10, 2)), CAST(N'2024-06-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (629, 29, 6, CAST(450.00 AS Decimal(10, 2)), CAST(N'2024-01-30' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (630, 30, 4, CAST(314.00 AS Decimal(10, 2)), CAST(N'2024-09-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (631, 31, 17, CAST(305.00 AS Decimal(10, 2)), CAST(N'2023-04-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (632, 32, 20, CAST(345.00 AS Decimal(10, 2)), CAST(N'2025-01-03' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (633, 33, 18, CAST(138.00 AS Decimal(10, 2)), CAST(N'2023-10-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (634, 34, 3, CAST(78.00 AS Decimal(10, 2)), CAST(N'2023-10-09' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (635, 35, 9, CAST(491.00 AS Decimal(10, 2)), CAST(N'2024-10-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (636, 36, 8, CAST(75.00 AS Decimal(10, 2)), CAST(N'2024-11-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (637, 37, 9, CAST(283.00 AS Decimal(10, 2)), CAST(N'2024-01-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (638, 38, 10, CAST(38.00 AS Decimal(10, 2)), CAST(N'2025-04-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (639, 39, 10, CAST(279.00 AS Decimal(10, 2)), CAST(N'2024-10-03' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (640, 40, 14, CAST(63.00 AS Decimal(10, 2)), CAST(N'2023-11-07' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (641, 41, 17, CAST(31.00 AS Decimal(10, 2)), CAST(N'2024-12-15' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (642, 42, 4, CAST(165.00 AS Decimal(10, 2)), CAST(N'2023-09-19' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (643, 43, 9, CAST(509.00 AS Decimal(10, 2)), CAST(N'2025-03-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (644, 44, 19, CAST(247.00 AS Decimal(10, 2)), CAST(N'2023-12-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (645, 45, 6, CAST(352.00 AS Decimal(10, 2)), CAST(N'2024-10-15' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (646, 46, 4, CAST(76.00 AS Decimal(10, 2)), CAST(N'2024-01-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (647, 47, 20, CAST(332.00 AS Decimal(10, 2)), CAST(N'2024-10-12' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (648, 48, 7, CAST(163.00 AS Decimal(10, 2)), CAST(N'2023-09-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (649, 49, 2, CAST(145.00 AS Decimal(10, 2)), CAST(N'2024-09-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (650, 50, 7, CAST(81.00 AS Decimal(10, 2)), CAST(N'2023-12-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (651, 51, 1, CAST(425.00 AS Decimal(10, 2)), CAST(N'2024-12-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (652, 52, 14, CAST(322.00 AS Decimal(10, 2)), CAST(N'2023-08-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (653, 53, 8, CAST(122.00 AS Decimal(10, 2)), CAST(N'2024-05-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (654, 54, 18, CAST(272.00 AS Decimal(10, 2)), CAST(N'2024-07-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (655, 55, 12, CAST(448.00 AS Decimal(10, 2)), CAST(N'2024-12-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (656, 56, 16, CAST(274.00 AS Decimal(10, 2)), CAST(N'2025-08-24' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (657, 57, 18, CAST(51.00 AS Decimal(10, 2)), CAST(N'2023-08-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (658, 58, 9, CAST(59.00 AS Decimal(10, 2)), CAST(N'2024-09-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (659, 59, 15, CAST(223.00 AS Decimal(10, 2)), CAST(N'2024-11-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (660, 60, 5, CAST(330.00 AS Decimal(10, 2)), CAST(N'2024-09-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (661, 61, 4, CAST(79.00 AS Decimal(10, 2)), CAST(N'2025-07-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (662, 62, 10, CAST(403.00 AS Decimal(10, 2)), CAST(N'2024-12-23' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (663, 63, 4, CAST(93.00 AS Decimal(10, 2)), CAST(N'2025-03-08' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (664, 64, 17, CAST(506.00 AS Decimal(10, 2)), CAST(N'2024-11-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (665, 65, 8, CAST(351.00 AS Decimal(10, 2)), CAST(N'2024-02-04' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (666, 66, 1, CAST(414.00 AS Decimal(10, 2)), CAST(N'2025-02-28' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (667, 67, 6, CAST(400.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (668, 68, 15, CAST(33.00 AS Decimal(10, 2)), CAST(N'2023-10-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (669, 69, 1, CAST(94.00 AS Decimal(10, 2)), CAST(N'2025-02-06' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (670, 70, 5, CAST(446.00 AS Decimal(10, 2)), CAST(N'2024-03-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (671, 71, 14, CAST(414.00 AS Decimal(10, 2)), CAST(N'2024-03-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (672, 72, 3, CAST(485.00 AS Decimal(10, 2)), CAST(N'2023-10-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (673, 73, 18, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-06-05' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (674, 74, 11, CAST(77.00 AS Decimal(10, 2)), CAST(N'2025-03-05' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (675, 75, 4, CAST(170.00 AS Decimal(10, 2)), CAST(N'2024-11-05' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (676, 76, 7, CAST(16.00 AS Decimal(10, 2)), CAST(N'2024-04-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (677, 77, 2, CAST(434.00 AS Decimal(10, 2)), CAST(N'2023-11-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (678, 78, 8, CAST(14.00 AS Decimal(10, 2)), CAST(N'2025-04-12' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (679, 79, 11, CAST(452.00 AS Decimal(10, 2)), CAST(N'2024-11-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (680, 80, 13, CAST(217.00 AS Decimal(10, 2)), CAST(N'2024-07-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (681, 81, 20, CAST(320.00 AS Decimal(10, 2)), CAST(N'2024-07-27' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (682, 82, 7, CAST(311.00 AS Decimal(10, 2)), CAST(N'2024-08-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (683, 83, 10, CAST(309.00 AS Decimal(10, 2)), CAST(N'2024-02-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (684, 84, 19, CAST(268.00 AS Decimal(10, 2)), CAST(N'2024-02-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (685, 85, 7, CAST(309.00 AS Decimal(10, 2)), CAST(N'2024-05-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (686, 86, 6, CAST(290.00 AS Decimal(10, 2)), CAST(N'2023-12-03' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (687, 87, 1, CAST(443.00 AS Decimal(10, 2)), CAST(N'2024-06-16' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (688, 88, 8, CAST(291.00 AS Decimal(10, 2)), CAST(N'2023-11-29' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (689, 89, 3, CAST(100.00 AS Decimal(10, 2)), CAST(N'2024-06-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (690, 90, 13, CAST(458.00 AS Decimal(10, 2)), CAST(N'2024-07-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (691, 91, 3, CAST(107.00 AS Decimal(10, 2)), CAST(N'2023-12-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (692, 92, 12, CAST(236.00 AS Decimal(10, 2)), CAST(N'2024-12-09' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (693, 93, 9, CAST(322.00 AS Decimal(10, 2)), CAST(N'2024-11-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (694, 94, 3, CAST(268.00 AS Decimal(10, 2)), CAST(N'2023-12-07' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (695, 95, 17, CAST(451.00 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (696, 96, 20, CAST(340.00 AS Decimal(10, 2)), CAST(N'2024-07-10' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (697, 97, 9, CAST(159.00 AS Decimal(10, 2)), CAST(N'2024-11-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (698, 98, 4, CAST(349.00 AS Decimal(10, 2)), CAST(N'2024-01-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (699, 99, 14, CAST(220.00 AS Decimal(10, 2)), CAST(N'2023-04-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (700, 100, 19, CAST(396.00 AS Decimal(10, 2)), CAST(N'2023-11-25' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (701, 101, 20, CAST(497.00 AS Decimal(10, 2)), CAST(N'2024-04-28' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (702, 102, 12, CAST(292.00 AS Decimal(10, 2)), CAST(N'2023-06-11' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (703, 103, 8, CAST(183.00 AS Decimal(10, 2)), CAST(N'2023-09-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (704, 104, 17, CAST(159.00 AS Decimal(10, 2)), CAST(N'2023-07-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (705, 105, 9, CAST(477.00 AS Decimal(10, 2)), CAST(N'2025-09-04' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (706, 106, 9, CAST(292.00 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (707, 107, 12, CAST(229.00 AS Decimal(10, 2)), CAST(N'2025-03-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (708, 108, 3, CAST(340.00 AS Decimal(10, 2)), CAST(N'2024-07-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (709, 109, 17, CAST(59.00 AS Decimal(10, 2)), CAST(N'2024-01-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (710, 110, 11, CAST(281.00 AS Decimal(10, 2)), CAST(N'2024-04-06' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (711, 111, 18, CAST(393.00 AS Decimal(10, 2)), CAST(N'2023-07-20' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (712, 112, 15, CAST(462.00 AS Decimal(10, 2)), CAST(N'2026-01-07' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (713, 113, 6, CAST(345.00 AS Decimal(10, 2)), CAST(N'2023-11-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (714, 114, 4, CAST(404.00 AS Decimal(10, 2)), CAST(N'2023-07-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (715, 115, 12, CAST(494.00 AS Decimal(10, 2)), CAST(N'2024-06-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (716, 116, 6, CAST(306.00 AS Decimal(10, 2)), CAST(N'2023-10-09' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (717, 117, 19, CAST(114.00 AS Decimal(10, 2)), CAST(N'2024-06-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (718, 118, 11, CAST(472.00 AS Decimal(10, 2)), CAST(N'2023-12-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (719, 119, 20, CAST(256.00 AS Decimal(10, 2)), CAST(N'2024-04-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (720, 120, 7, CAST(363.00 AS Decimal(10, 2)), CAST(N'2023-05-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (721, 1, 19, CAST(94.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (722, 2, 1, CAST(383.00 AS Decimal(10, 2)), CAST(N'2023-12-31' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (723, 3, 12, CAST(273.00 AS Decimal(10, 2)), CAST(N'2024-03-03' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (724, 4, 11, CAST(31.00 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (725, 5, 9, CAST(499.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (726, 6, 18, CAST(270.00 AS Decimal(10, 2)), CAST(N'2024-05-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (727, 7, 6, CAST(332.00 AS Decimal(10, 2)), CAST(N'2023-10-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (728, 8, 5, CAST(507.00 AS Decimal(10, 2)), CAST(N'2024-08-09' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (729, 9, 9, CAST(310.00 AS Decimal(10, 2)), CAST(N'2024-02-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (730, 10, 2, CAST(205.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (731, 11, 8, CAST(313.00 AS Decimal(10, 2)), CAST(N'2023-10-04' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (732, 12, 2, CAST(274.00 AS Decimal(10, 2)), CAST(N'2024-12-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (733, 13, 7, CAST(65.00 AS Decimal(10, 2)), CAST(N'2024-03-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (734, 14, 2, CAST(297.00 AS Decimal(10, 2)), CAST(N'2023-05-29' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (735, 15, 4, CAST(122.00 AS Decimal(10, 2)), CAST(N'2023-10-25' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (736, 16, 17, CAST(274.00 AS Decimal(10, 2)), CAST(N'2024-04-24' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (737, 17, 18, CAST(330.00 AS Decimal(10, 2)), CAST(N'2025-03-03' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (738, 18, 11, CAST(165.00 AS Decimal(10, 2)), CAST(N'2023-08-11' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (739, 19, 13, CAST(489.00 AS Decimal(10, 2)), CAST(N'2024-04-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (740, 20, 14, CAST(114.00 AS Decimal(10, 2)), CAST(N'2023-09-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (741, 21, 6, CAST(258.00 AS Decimal(10, 2)), CAST(N'2023-08-19' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (742, 22, 8, CAST(507.00 AS Decimal(10, 2)), CAST(N'2023-08-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (743, 23, 15, CAST(277.00 AS Decimal(10, 2)), CAST(N'2024-05-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (744, 24, 18, CAST(93.00 AS Decimal(10, 2)), CAST(N'2024-02-12' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (745, 25, 9, CAST(476.00 AS Decimal(10, 2)), CAST(N'2023-05-12' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (746, 26, 11, CAST(386.00 AS Decimal(10, 2)), CAST(N'2024-10-06' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (747, 27, 5, CAST(62.00 AS Decimal(10, 2)), CAST(N'2023-08-22' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (748, 28, 11, CAST(81.00 AS Decimal(10, 2)), CAST(N'2024-05-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (749, 29, 18, CAST(398.00 AS Decimal(10, 2)), CAST(N'2023-11-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (750, 30, 16, CAST(403.00 AS Decimal(10, 2)), CAST(N'2024-09-21' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (751, 31, 5, CAST(284.00 AS Decimal(10, 2)), CAST(N'2024-01-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (752, 32, 9, CAST(509.00 AS Decimal(10, 2)), CAST(N'2025-03-10' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (753, 33, 5, CAST(68.00 AS Decimal(10, 2)), CAST(N'2023-08-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (754, 34, 2, CAST(372.00 AS Decimal(10, 2)), CAST(N'2023-11-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (755, 35, 11, CAST(114.00 AS Decimal(10, 2)), CAST(N'2024-11-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (756, 36, 2, CAST(466.00 AS Decimal(10, 2)), CAST(N'2024-11-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (757, 37, 10, CAST(287.00 AS Decimal(10, 2)), CAST(N'2024-01-17' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (758, 38, 3, CAST(292.00 AS Decimal(10, 2)), CAST(N'2025-04-17' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (759, 39, 18, CAST(288.00 AS Decimal(10, 2)), CAST(N'2024-10-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (760, 40, 11, CAST(107.00 AS Decimal(10, 2)), CAST(N'2024-02-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (761, 41, 10, CAST(15.00 AS Decimal(10, 2)), CAST(N'2025-04-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (762, 42, 3, CAST(244.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (763, 43, 12, CAST(323.00 AS Decimal(10, 2)), CAST(N'2025-07-20' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (764, 44, 2, CAST(311.00 AS Decimal(10, 2)), CAST(N'2023-12-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (765, 45, 3, CAST(405.00 AS Decimal(10, 2)), CAST(N'2024-10-08' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (766, 46, 19, CAST(133.00 AS Decimal(10, 2)), CAST(N'2024-02-15' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (767, 47, 17, CAST(221.00 AS Decimal(10, 2)), CAST(N'2024-08-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (768, 48, 4, CAST(331.00 AS Decimal(10, 2)), CAST(N'2023-09-22' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (769, 49, 16, CAST(224.00 AS Decimal(10, 2)), CAST(N'2024-09-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (770, 50, 10, CAST(166.00 AS Decimal(10, 2)), CAST(N'2023-11-10' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (771, 51, 20, CAST(68.00 AS Decimal(10, 2)), CAST(N'2024-08-17' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (772, 52, 7, CAST(156.00 AS Decimal(10, 2)), CAST(N'2024-02-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (773, 53, 11, CAST(347.00 AS Decimal(10, 2)), CAST(N'2024-05-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (774, 54, 16, CAST(193.00 AS Decimal(10, 2)), CAST(N'2024-08-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (775, 55, 15, CAST(42.00 AS Decimal(10, 2)), CAST(N'2024-05-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (776, 56, 20, CAST(95.00 AS Decimal(10, 2)), CAST(N'2025-03-15' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (777, 57, 19, CAST(349.00 AS Decimal(10, 2)), CAST(N'2023-04-02' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (778, 58, 20, CAST(503.00 AS Decimal(10, 2)), CAST(N'2024-11-23' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (779, 59, 4, CAST(261.00 AS Decimal(10, 2)), CAST(N'2025-02-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (780, 60, 11, CAST(494.00 AS Decimal(10, 2)), CAST(N'2024-07-17' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (781, 61, 19, CAST(144.00 AS Decimal(10, 2)), CAST(N'2025-09-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (782, 62, 9, CAST(365.00 AS Decimal(10, 2)), CAST(N'2024-10-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (783, 63, 9, CAST(338.00 AS Decimal(10, 2)), CAST(N'2024-09-27' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (784, 64, 20, CAST(160.00 AS Decimal(10, 2)), CAST(N'2025-02-08' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (785, 65, 10, CAST(371.00 AS Decimal(10, 2)), CAST(N'2024-03-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (786, 66, 18, CAST(140.00 AS Decimal(10, 2)), CAST(N'2025-03-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (787, 67, 10, CAST(57.00 AS Decimal(10, 2)), CAST(N'2024-08-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (788, 68, 2, CAST(222.00 AS Decimal(10, 2)), CAST(N'2024-03-22' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (789, 69, 20, CAST(322.00 AS Decimal(10, 2)), CAST(N'2025-01-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (790, 70, 6, CAST(472.00 AS Decimal(10, 2)), CAST(N'2024-08-13' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (791, 71, 9, CAST(199.00 AS Decimal(10, 2)), CAST(N'2023-10-14' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (792, 72, 5, CAST(339.00 AS Decimal(10, 2)), CAST(N'2023-04-25' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (793, 73, 3, CAST(385.00 AS Decimal(10, 2)), CAST(N'2024-06-04' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (794, 74, 7, CAST(17.00 AS Decimal(10, 2)), CAST(N'2024-12-16' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (795, 75, 4, CAST(39.00 AS Decimal(10, 2)), CAST(N'2023-09-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (796, 76, 15, CAST(343.00 AS Decimal(10, 2)), CAST(N'2024-03-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (797, 77, 14, CAST(499.00 AS Decimal(10, 2)), CAST(N'2023-10-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (798, 78, 5, CAST(378.00 AS Decimal(10, 2)), CAST(N'2025-01-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (799, 79, 18, CAST(295.00 AS Decimal(10, 2)), CAST(N'2024-12-21' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (800, 80, 16, CAST(325.00 AS Decimal(10, 2)), CAST(N'2023-12-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (801, 81, 14, CAST(227.00 AS Decimal(10, 2)), CAST(N'2024-07-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (802, 82, 8, CAST(485.00 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (803, 83, 8, CAST(144.00 AS Decimal(10, 2)), CAST(N'2023-09-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (804, 84, 12, CAST(450.00 AS Decimal(10, 2)), CAST(N'2023-12-24' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (805, 85, 20, CAST(295.00 AS Decimal(10, 2)), CAST(N'2024-06-07' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (806, 86, 6, CAST(168.00 AS Decimal(10, 2)), CAST(N'2023-09-03' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (807, 87, 15, CAST(35.00 AS Decimal(10, 2)), CAST(N'2024-03-04' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (808, 88, 16, CAST(379.00 AS Decimal(10, 2)), CAST(N'2023-11-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (809, 89, 13, CAST(276.00 AS Decimal(10, 2)), CAST(N'2024-05-07' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (810, 90, 8, CAST(113.00 AS Decimal(10, 2)), CAST(N'2023-11-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (811, 91, 12, CAST(43.00 AS Decimal(10, 2)), CAST(N'2023-12-20' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (812, 92, 5, CAST(477.00 AS Decimal(10, 2)), CAST(N'2024-09-10' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (813, 93, 17, CAST(474.00 AS Decimal(10, 2)), CAST(N'2024-08-15' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (814, 94, 11, CAST(414.00 AS Decimal(10, 2)), CAST(N'2024-04-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (815, 95, 14, CAST(319.00 AS Decimal(10, 2)), CAST(N'2024-04-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (816, 96, 6, CAST(248.00 AS Decimal(10, 2)), CAST(N'2024-11-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (817, 97, 15, CAST(49.00 AS Decimal(10, 2)), CAST(N'2024-11-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (818, 98, 1, CAST(42.00 AS Decimal(10, 2)), CAST(N'2023-11-26' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (819, 99, 1, CAST(438.00 AS Decimal(10, 2)), CAST(N'2023-07-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (820, 100, 18, CAST(132.00 AS Decimal(10, 2)), CAST(N'2023-04-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (821, 101, 18, CAST(46.00 AS Decimal(10, 2)), CAST(N'2024-02-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (822, 102, 1, CAST(152.00 AS Decimal(10, 2)), CAST(N'2023-09-22' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (823, 103, 18, CAST(17.00 AS Decimal(10, 2)), CAST(N'2023-11-14' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (824, 104, 17, CAST(38.00 AS Decimal(10, 2)), CAST(N'2023-07-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (825, 105, 6, CAST(317.00 AS Decimal(10, 2)), CAST(N'2025-06-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (826, 106, 7, CAST(387.00 AS Decimal(10, 2)), CAST(N'2024-01-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (827, 107, 6, CAST(142.00 AS Decimal(10, 2)), CAST(N'2025-05-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (828, 108, 1, CAST(280.00 AS Decimal(10, 2)), CAST(N'2024-07-19' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (829, 109, 14, CAST(225.00 AS Decimal(10, 2)), CAST(N'2023-09-19' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (830, 110, 10, CAST(23.00 AS Decimal(10, 2)), CAST(N'2024-03-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (831, 111, 16, CAST(477.00 AS Decimal(10, 2)), CAST(N'2023-06-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (832, 112, 15, CAST(192.00 AS Decimal(10, 2)), CAST(N'2025-10-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (833, 113, 17, CAST(427.00 AS Decimal(10, 2)), CAST(N'2023-11-27' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (834, 114, 8, CAST(33.00 AS Decimal(10, 2)), CAST(N'2023-11-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (835, 115, 15, CAST(398.00 AS Decimal(10, 2)), CAST(N'2024-06-17' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (836, 116, 1, CAST(214.00 AS Decimal(10, 2)), CAST(N'2023-08-30' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (837, 117, 14, CAST(287.00 AS Decimal(10, 2)), CAST(N'2024-01-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (838, 118, 10, CAST(232.00 AS Decimal(10, 2)), CAST(N'2023-07-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (839, 119, 20, CAST(138.00 AS Decimal(10, 2)), CAST(N'2024-08-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (840, 120, 20, CAST(276.00 AS Decimal(10, 2)), CAST(N'2023-06-05' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (841, 1, 6, CAST(392.00 AS Decimal(10, 2)), CAST(N'2024-04-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (842, 2, 2, CAST(329.00 AS Decimal(10, 2)), CAST(N'2023-04-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (843, 3, 19, CAST(318.00 AS Decimal(10, 2)), CAST(N'2024-03-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (844, 4, 15, CAST(31.00 AS Decimal(10, 2)), CAST(N'2024-06-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (845, 5, 9, CAST(83.00 AS Decimal(10, 2)), CAST(N'2024-09-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (846, 6, 19, CAST(28.00 AS Decimal(10, 2)), CAST(N'2024-05-13' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (847, 7, 18, CAST(329.00 AS Decimal(10, 2)), CAST(N'2023-10-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (848, 8, 6, CAST(221.00 AS Decimal(10, 2)), CAST(N'2024-08-20' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (849, 9, 6, CAST(148.00 AS Decimal(10, 2)), CAST(N'2023-12-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (850, 10, 1, CAST(480.00 AS Decimal(10, 2)), CAST(N'2024-04-05' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (851, 11, 9, CAST(480.00 AS Decimal(10, 2)), CAST(N'2023-08-23' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (852, 12, 18, CAST(287.00 AS Decimal(10, 2)), CAST(N'2025-01-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (853, 13, 1, CAST(447.00 AS Decimal(10, 2)), CAST(N'2024-03-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (854, 14, 18, CAST(268.00 AS Decimal(10, 2)), CAST(N'2023-09-06' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (855, 15, 17, CAST(237.00 AS Decimal(10, 2)), CAST(N'2024-01-09' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (856, 16, 16, CAST(30.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (857, 17, 2, CAST(223.00 AS Decimal(10, 2)), CAST(N'2025-02-13' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (858, 18, 4, CAST(228.00 AS Decimal(10, 2)), CAST(N'2024-04-12' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (859, 19, 1, CAST(211.00 AS Decimal(10, 2)), CAST(N'2024-06-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (860, 20, 14, CAST(173.00 AS Decimal(10, 2)), CAST(N'2023-08-25' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (861, 21, 15, CAST(173.00 AS Decimal(10, 2)), CAST(N'2023-08-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (862, 22, 14, CAST(33.00 AS Decimal(10, 2)), CAST(N'2024-03-07' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (863, 23, 11, CAST(256.00 AS Decimal(10, 2)), CAST(N'2025-01-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (864, 24, 2, CAST(474.00 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (865, 25, 15, CAST(345.00 AS Decimal(10, 2)), CAST(N'2023-06-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (866, 26, 12, CAST(215.00 AS Decimal(10, 2)), CAST(N'2024-10-18' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (867, 27, 3, CAST(416.00 AS Decimal(10, 2)), CAST(N'2024-09-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (868, 28, 1, CAST(465.00 AS Decimal(10, 2)), CAST(N'2024-06-14' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (869, 29, 11, CAST(316.00 AS Decimal(10, 2)), CAST(N'2023-10-01' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (870, 30, 4, CAST(119.00 AS Decimal(10, 2)), CAST(N'2024-09-20' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (871, 31, 8, CAST(451.00 AS Decimal(10, 2)), CAST(N'2024-08-10' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (872, 32, 14, CAST(279.00 AS Decimal(10, 2)), CAST(N'2025-03-08' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (873, 33, 8, CAST(121.00 AS Decimal(10, 2)), CAST(N'2023-08-10' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (874, 34, 12, CAST(24.00 AS Decimal(10, 2)), CAST(N'2023-11-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (875, 35, 5, CAST(308.00 AS Decimal(10, 2)), CAST(N'2024-11-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (876, 36, 16, CAST(505.00 AS Decimal(10, 2)), CAST(N'2024-11-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (877, 37, 7, CAST(19.00 AS Decimal(10, 2)), CAST(N'2024-01-08' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (878, 38, 17, CAST(349.00 AS Decimal(10, 2)), CAST(N'2024-11-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (879, 39, 4, CAST(383.00 AS Decimal(10, 2)), CAST(N'2024-11-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (880, 40, 15, CAST(184.00 AS Decimal(10, 2)), CAST(N'2024-01-23' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (881, 41, 5, CAST(352.00 AS Decimal(10, 2)), CAST(N'2026-03-07' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (882, 42, 6, CAST(298.00 AS Decimal(10, 2)), CAST(N'2023-09-20' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (883, 43, 10, CAST(106.00 AS Decimal(10, 2)), CAST(N'2024-12-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (884, 44, 9, CAST(143.00 AS Decimal(10, 2)), CAST(N'2023-11-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (885, 45, 19, CAST(198.00 AS Decimal(10, 2)), CAST(N'2024-12-26' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (886, 46, 4, CAST(101.00 AS Decimal(10, 2)), CAST(N'2024-05-11' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (887, 47, 19, CAST(393.00 AS Decimal(10, 2)), CAST(N'2025-06-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (888, 48, 11, CAST(395.00 AS Decimal(10, 2)), CAST(N'2023-07-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (889, 49, 3, CAST(358.00 AS Decimal(10, 2)), CAST(N'2024-09-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (890, 50, 3, CAST(69.00 AS Decimal(10, 2)), CAST(N'2023-12-19' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (891, 51, 1, CAST(180.00 AS Decimal(10, 2)), CAST(N'2024-12-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (892, 52, 17, CAST(319.00 AS Decimal(10, 2)), CAST(N'2024-03-23' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (893, 53, 10, CAST(143.00 AS Decimal(10, 2)), CAST(N'2024-04-22' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (894, 54, 16, CAST(176.00 AS Decimal(10, 2)), CAST(N'2024-07-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (895, 55, 18, CAST(241.00 AS Decimal(10, 2)), CAST(N'2024-12-22' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (896, 56, 4, CAST(149.00 AS Decimal(10, 2)), CAST(N'2025-07-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (897, 57, 4, CAST(20.00 AS Decimal(10, 2)), CAST(N'2023-10-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (898, 58, 18, CAST(228.00 AS Decimal(10, 2)), CAST(N'2025-04-12' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (899, 59, 8, CAST(233.00 AS Decimal(10, 2)), CAST(N'2024-10-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (900, 60, 7, CAST(334.00 AS Decimal(10, 2)), CAST(N'2024-08-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (901, 61, 10, CAST(146.00 AS Decimal(10, 2)), CAST(N'2025-08-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (902, 62, 12, CAST(216.00 AS Decimal(10, 2)), CAST(N'2024-10-20' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (903, 63, 16, CAST(492.00 AS Decimal(10, 2)), CAST(N'2024-11-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (904, 64, 20, CAST(246.00 AS Decimal(10, 2)), CAST(N'2025-03-10' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (905, 65, 3, CAST(313.00 AS Decimal(10, 2)), CAST(N'2024-04-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (906, 66, 14, CAST(92.00 AS Decimal(10, 2)), CAST(N'2025-03-09' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (907, 67, 16, CAST(352.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (908, 68, 1, CAST(316.00 AS Decimal(10, 2)), CAST(N'2023-12-19' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (909, 69, 2, CAST(264.00 AS Decimal(10, 2)), CAST(N'2024-12-26' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (910, 70, 12, CAST(305.00 AS Decimal(10, 2)), CAST(N'2024-09-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (911, 71, 3, CAST(411.00 AS Decimal(10, 2)), CAST(N'2024-06-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (912, 72, 3, CAST(53.00 AS Decimal(10, 2)), CAST(N'2023-09-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (913, 73, 5, CAST(149.00 AS Decimal(10, 2)), CAST(N'2024-06-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (914, 74, 3, CAST(316.00 AS Decimal(10, 2)), CAST(N'2024-10-26' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (915, 75, 14, CAST(141.00 AS Decimal(10, 2)), CAST(N'2024-09-18' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (916, 76, 5, CAST(407.00 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (917, 77, 4, CAST(397.00 AS Decimal(10, 2)), CAST(N'2023-12-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (918, 78, 16, CAST(220.00 AS Decimal(10, 2)), CAST(N'2024-12-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (919, 79, 14, CAST(363.00 AS Decimal(10, 2)), CAST(N'2024-02-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (920, 80, 8, CAST(10.00 AS Decimal(10, 2)), CAST(N'2024-05-30' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (921, 81, 8, CAST(226.00 AS Decimal(10, 2)), CAST(N'2024-07-20' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (922, 82, 11, CAST(313.00 AS Decimal(10, 2)), CAST(N'2024-02-23' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (923, 83, 15, CAST(303.00 AS Decimal(10, 2)), CAST(N'2023-10-05' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (924, 84, 1, CAST(124.00 AS Decimal(10, 2)), CAST(N'2024-02-24' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (925, 85, 14, CAST(310.00 AS Decimal(10, 2)), CAST(N'2024-03-14' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (926, 86, 18, CAST(29.00 AS Decimal(10, 2)), CAST(N'2023-07-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (927, 87, 4, CAST(305.00 AS Decimal(10, 2)), CAST(N'2024-01-13' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (928, 88, 15, CAST(19.00 AS Decimal(10, 2)), CAST(N'2023-12-10' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (929, 89, 17, CAST(28.00 AS Decimal(10, 2)), CAST(N'2024-06-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (930, 90, 4, CAST(463.00 AS Decimal(10, 2)), CAST(N'2024-08-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (931, 91, 1, CAST(93.00 AS Decimal(10, 2)), CAST(N'2024-05-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (932, 92, 1, CAST(126.00 AS Decimal(10, 2)), CAST(N'2024-10-16' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (933, 93, 14, CAST(147.00 AS Decimal(10, 2)), CAST(N'2024-05-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (934, 94, 5, CAST(393.00 AS Decimal(10, 2)), CAST(N'2024-06-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (935, 95, 3, CAST(167.00 AS Decimal(10, 2)), CAST(N'2024-03-22' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (936, 96, 3, CAST(207.00 AS Decimal(10, 2)), CAST(N'2024-07-27' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (937, 97, 1, CAST(373.00 AS Decimal(10, 2)), CAST(N'2024-12-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (938, 98, 11, CAST(238.00 AS Decimal(10, 2)), CAST(N'2023-12-19' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (939, 99, 12, CAST(67.00 AS Decimal(10, 2)), CAST(N'2023-07-10' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (940, 100, 13, CAST(232.00 AS Decimal(10, 2)), CAST(N'2023-03-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (941, 101, 8, CAST(470.00 AS Decimal(10, 2)), CAST(N'2024-02-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (942, 102, 14, CAST(259.00 AS Decimal(10, 2)), CAST(N'2023-01-14' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (943, 103, 18, CAST(189.00 AS Decimal(10, 2)), CAST(N'2023-11-27' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (944, 104, 5, CAST(484.00 AS Decimal(10, 2)), CAST(N'2023-09-16' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (945, 105, 6, CAST(251.00 AS Decimal(10, 2)), CAST(N'2024-09-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (946, 106, 14, CAST(478.00 AS Decimal(10, 2)), CAST(N'2024-01-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (947, 107, 12, CAST(426.00 AS Decimal(10, 2)), CAST(N'2025-05-07' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (948, 108, 4, CAST(230.00 AS Decimal(10, 2)), CAST(N'2024-07-15' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (949, 109, 18, CAST(157.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (950, 110, 8, CAST(133.00 AS Decimal(10, 2)), CAST(N'2023-12-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (951, 111, 20, CAST(297.00 AS Decimal(10, 2)), CAST(N'2023-07-24' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (952, 112, 1, CAST(83.00 AS Decimal(10, 2)), CAST(N'2025-10-18' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (953, 113, 2, CAST(182.00 AS Decimal(10, 2)), CAST(N'2023-07-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (954, 114, 8, CAST(208.00 AS Decimal(10, 2)), CAST(N'2023-08-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (955, 115, 9, CAST(374.00 AS Decimal(10, 2)), CAST(N'2024-05-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (956, 116, 9, CAST(355.00 AS Decimal(10, 2)), CAST(N'2023-11-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (957, 117, 9, CAST(451.00 AS Decimal(10, 2)), CAST(N'2024-05-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (958, 118, 20, CAST(393.00 AS Decimal(10, 2)), CAST(N'2023-12-29' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (959, 119, 17, CAST(217.00 AS Decimal(10, 2)), CAST(N'2024-06-13' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (960, 120, 1, CAST(152.00 AS Decimal(10, 2)), CAST(N'2023-07-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (961, 1, 7, CAST(288.00 AS Decimal(10, 2)), CAST(N'2024-06-05' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (962, 2, 14, CAST(254.00 AS Decimal(10, 2)), CAST(N'2023-10-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (963, 3, 18, CAST(198.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (964, 4, 13, CAST(393.00 AS Decimal(10, 2)), CAST(N'2024-04-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (965, 5, 10, CAST(32.00 AS Decimal(10, 2)), CAST(N'2024-07-21' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (966, 6, 6, CAST(473.00 AS Decimal(10, 2)), CAST(N'2023-11-16' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (967, 7, 3, CAST(90.00 AS Decimal(10, 2)), CAST(N'2023-07-05' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (968, 8, 16, CAST(436.00 AS Decimal(10, 2)), CAST(N'2024-09-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (969, 9, 3, CAST(428.00 AS Decimal(10, 2)), CAST(N'2023-12-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (970, 10, 9, CAST(79.00 AS Decimal(10, 2)), CAST(N'2024-04-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (971, 11, 16, CAST(396.00 AS Decimal(10, 2)), CAST(N'2023-10-17' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (972, 12, 3, CAST(249.00 AS Decimal(10, 2)), CAST(N'2025-01-04' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (973, 13, 4, CAST(39.00 AS Decimal(10, 2)), CAST(N'2024-05-16' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (974, 14, 13, CAST(75.00 AS Decimal(10, 2)), CAST(N'2023-08-03' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (975, 15, 17, CAST(102.00 AS Decimal(10, 2)), CAST(N'2024-04-29' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (976, 16, 10, CAST(39.00 AS Decimal(10, 2)), CAST(N'2024-04-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (977, 17, 16, CAST(82.00 AS Decimal(10, 2)), CAST(N'2025-04-04' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (978, 18, 2, CAST(472.00 AS Decimal(10, 2)), CAST(N'2023-11-12' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (979, 19, 19, CAST(103.00 AS Decimal(10, 2)), CAST(N'2024-06-27' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (980, 20, 3, CAST(406.00 AS Decimal(10, 2)), CAST(N'2023-09-05' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (981, 21, 5, CAST(99.00 AS Decimal(10, 2)), CAST(N'2023-11-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (982, 22, 4, CAST(377.00 AS Decimal(10, 2)), CAST(N'2024-06-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (983, 23, 1, CAST(142.00 AS Decimal(10, 2)), CAST(N'2024-06-14' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (984, 24, 10, CAST(118.00 AS Decimal(10, 2)), CAST(N'2024-02-10' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (985, 25, 7, CAST(209.00 AS Decimal(10, 2)), CAST(N'2023-04-26' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (986, 26, 6, CAST(70.00 AS Decimal(10, 2)), CAST(N'2024-05-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (987, 27, 8, CAST(309.00 AS Decimal(10, 2)), CAST(N'2024-04-23' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (988, 28, 19, CAST(256.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (989, 29, 20, CAST(375.00 AS Decimal(10, 2)), CAST(N'2023-12-06' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (990, 30, 18, CAST(134.00 AS Decimal(10, 2)), CAST(N'2024-10-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (991, 31, 3, CAST(94.00 AS Decimal(10, 2)), CAST(N'2023-05-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (992, 32, 2, CAST(397.00 AS Decimal(10, 2)), CAST(N'2024-12-08' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (993, 33, 11, CAST(114.00 AS Decimal(10, 2)), CAST(N'2023-09-05' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (994, 34, 13, CAST(421.00 AS Decimal(10, 2)), CAST(N'2023-12-17' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (995, 35, 6, CAST(461.00 AS Decimal(10, 2)), CAST(N'2025-01-13' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (996, 36, 6, CAST(241.00 AS Decimal(10, 2)), CAST(N'2024-11-18' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (997, 37, 3, CAST(45.00 AS Decimal(10, 2)), CAST(N'2024-01-15' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (998, 38, 18, CAST(95.00 AS Decimal(10, 2)), CAST(N'2025-03-19' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (999, 39, 15, CAST(223.00 AS Decimal(10, 2)), CAST(N'2024-11-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1000, 40, 3, CAST(363.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1001, 41, 1, CAST(488.00 AS Decimal(10, 2)), CAST(N'2024-12-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1002, 42, 16, CAST(210.00 AS Decimal(10, 2)), CAST(N'2023-08-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1003, 43, 6, CAST(224.00 AS Decimal(10, 2)), CAST(N'2025-06-26' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1004, 44, 3, CAST(181.00 AS Decimal(10, 2)), CAST(N'2023-12-22' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1005, 45, 18, CAST(426.00 AS Decimal(10, 2)), CAST(N'2024-12-01' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1006, 46, 17, CAST(466.00 AS Decimal(10, 2)), CAST(N'2024-04-22' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1007, 47, 19, CAST(274.00 AS Decimal(10, 2)), CAST(N'2024-11-16' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1008, 48, 9, CAST(258.00 AS Decimal(10, 2)), CAST(N'2023-10-27' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1009, 49, 16, CAST(127.00 AS Decimal(10, 2)), CAST(N'2024-10-02' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1010, 50, 8, CAST(377.00 AS Decimal(10, 2)), CAST(N'2024-01-21' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1011, 51, 13, CAST(497.00 AS Decimal(10, 2)), CAST(N'2024-08-10' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1012, 52, 9, CAST(460.00 AS Decimal(10, 2)), CAST(N'2023-07-12' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1013, 53, 12, CAST(489.00 AS Decimal(10, 2)), CAST(N'2024-06-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1014, 54, 10, CAST(418.00 AS Decimal(10, 2)), CAST(N'2024-08-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1015, 55, 9, CAST(109.00 AS Decimal(10, 2)), CAST(N'2024-03-28' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1016, 56, 16, CAST(176.00 AS Decimal(10, 2)), CAST(N'2024-07-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1017, 57, 2, CAST(404.00 AS Decimal(10, 2)), CAST(N'2023-04-11' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1018, 58, 3, CAST(230.00 AS Decimal(10, 2)), CAST(N'2024-12-15' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1019, 59, 7, CAST(256.00 AS Decimal(10, 2)), CAST(N'2025-05-11' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1020, 60, 20, CAST(234.00 AS Decimal(10, 2)), CAST(N'2024-07-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1021, 61, 9, CAST(503.00 AS Decimal(10, 2)), CAST(N'2025-06-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1022, 62, 14, CAST(154.00 AS Decimal(10, 2)), CAST(N'2024-09-15' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1023, 63, 3, CAST(296.00 AS Decimal(10, 2)), CAST(N'2024-12-31' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1024, 64, 18, CAST(126.00 AS Decimal(10, 2)), CAST(N'2024-11-25' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1025, 65, 11, CAST(152.00 AS Decimal(10, 2)), CAST(N'2024-04-11' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1026, 66, 1, CAST(302.00 AS Decimal(10, 2)), CAST(N'2025-05-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1027, 67, 19, CAST(137.00 AS Decimal(10, 2)), CAST(N'2024-07-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1028, 68, 15, CAST(476.00 AS Decimal(10, 2)), CAST(N'2023-12-24' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1029, 69, 18, CAST(225.00 AS Decimal(10, 2)), CAST(N'2025-02-17' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1030, 70, 12, CAST(220.00 AS Decimal(10, 2)), CAST(N'2023-06-23' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1031, 71, 8, CAST(107.00 AS Decimal(10, 2)), CAST(N'2023-11-11' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1032, 72, 7, CAST(318.00 AS Decimal(10, 2)), CAST(N'2023-05-14' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1033, 73, 4, CAST(65.00 AS Decimal(10, 2)), CAST(N'2024-06-02' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1034, 74, 2, CAST(351.00 AS Decimal(10, 2)), CAST(N'2025-02-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1035, 75, 18, CAST(18.00 AS Decimal(10, 2)), CAST(N'2024-09-06' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1036, 76, 19, CAST(161.00 AS Decimal(10, 2)), CAST(N'2024-01-06' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1037, 77, 11, CAST(199.00 AS Decimal(10, 2)), CAST(N'2023-08-28' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1038, 78, 10, CAST(351.00 AS Decimal(10, 2)), CAST(N'2025-09-18' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1039, 79, 7, CAST(317.00 AS Decimal(10, 2)), CAST(N'2024-11-30' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1040, 80, 20, CAST(478.00 AS Decimal(10, 2)), CAST(N'2023-09-14' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1041, 81, 18, CAST(243.00 AS Decimal(10, 2)), CAST(N'2024-07-30' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1042, 82, 9, CAST(97.00 AS Decimal(10, 2)), CAST(N'2024-04-19' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1043, 83, 6, CAST(97.00 AS Decimal(10, 2)), CAST(N'2024-02-25' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1044, 84, 5, CAST(46.00 AS Decimal(10, 2)), CAST(N'2024-01-05' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1045, 85, 6, CAST(419.00 AS Decimal(10, 2)), CAST(N'2024-03-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1046, 86, 11, CAST(470.00 AS Decimal(10, 2)), CAST(N'2023-09-01' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1047, 87, 2, CAST(95.00 AS Decimal(10, 2)), CAST(N'2023-12-07' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1048, 88, 12, CAST(24.00 AS Decimal(10, 2)), CAST(N'2023-10-28' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1049, 89, 2, CAST(135.00 AS Decimal(10, 2)), CAST(N'2024-08-18' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1050, 90, 12, CAST(282.00 AS Decimal(10, 2)), CAST(N'2024-02-03' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1051, 91, 19, CAST(68.00 AS Decimal(10, 2)), CAST(N'2024-06-08' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1052, 92, 15, CAST(77.00 AS Decimal(10, 2)), CAST(N'2024-12-09' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1053, 93, 10, CAST(489.00 AS Decimal(10, 2)), CAST(N'2024-11-24' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1054, 94, 2, CAST(472.00 AS Decimal(10, 2)), CAST(N'2023-11-28' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1055, 95, 17, CAST(284.00 AS Decimal(10, 2)), CAST(N'2024-07-13' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1056, 96, 8, CAST(117.00 AS Decimal(10, 2)), CAST(N'2024-11-13' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1057, 97, 7, CAST(170.00 AS Decimal(10, 2)), CAST(N'2024-12-01' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1058, 98, 19, CAST(54.00 AS Decimal(10, 2)), CAST(N'2024-01-24' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1059, 99, 6, CAST(158.00 AS Decimal(10, 2)), CAST(N'2023-04-14' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1060, 100, 13, CAST(75.00 AS Decimal(10, 2)), CAST(N'2024-01-25' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1061, 101, 19, CAST(400.00 AS Decimal(10, 2)), CAST(N'2024-02-13' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1062, 102, 2, CAST(171.00 AS Decimal(10, 2)), CAST(N'2023-12-02' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1063, 103, 18, CAST(345.00 AS Decimal(10, 2)), CAST(N'2023-12-28' AS Date), N'Сувениры')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1064, 104, 2, CAST(361.00 AS Decimal(10, 2)), CAST(N'2023-09-05' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1065, 105, 7, CAST(311.00 AS Decimal(10, 2)), CAST(N'2024-12-26' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1066, 106, 7, CAST(67.00 AS Decimal(10, 2)), CAST(N'2024-01-04' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1067, 107, 18, CAST(493.00 AS Decimal(10, 2)), CAST(N'2025-07-21' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1068, 108, 19, CAST(394.00 AS Decimal(10, 2)), CAST(N'2024-07-19' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1069, 109, 4, CAST(457.00 AS Decimal(10, 2)), CAST(N'2023-09-30' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1070, 110, 6, CAST(186.00 AS Decimal(10, 2)), CAST(N'2023-10-02' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1071, 111, 1, CAST(122.00 AS Decimal(10, 2)), CAST(N'2023-05-31' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1072, 112, 2, CAST(60.00 AS Decimal(10, 2)), CAST(N'2025-07-09' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1073, 113, 1, CAST(347.00 AS Decimal(10, 2)), CAST(N'2023-07-07' AS Date), NULL)
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1074, 114, 16, CAST(474.00 AS Decimal(10, 2)), CAST(N'2023-10-29' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1075, 115, 11, CAST(304.00 AS Decimal(10, 2)), CAST(N'2024-05-29' AS Date), N'Такси')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1076, 116, 14, CAST(489.00 AS Decimal(10, 2)), CAST(N'2023-08-28' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1077, 117, 7, CAST(464.00 AS Decimal(10, 2)), CAST(N'2024-08-12' AS Date), N'Ужин')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1078, 118, 14, CAST(476.00 AS Decimal(10, 2)), CAST(N'2023-10-09' AS Date), N'Обед')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1079, 119, 7, CAST(207.00 AS Decimal(10, 2)), CAST(N'2024-05-04' AS Date), N'Билет в музей')
GO
INSERT [dbo].[expenses] ([id], [trip_id], [category_id], [amount], [expense_date], [description]) VALUES (1080, 120, 5, CAST(491.00 AS Decimal(10, 2)), CAST(N'2023-07-02' AS Date), N'Такси')
GO
SET IDENTITY_INSERT [dbo].[expenses] OFF
GO
SET IDENTITY_INSERT [dbo].[roles] ON 
GO
INSERT [dbo].[roles] ([id], [name]) VALUES (3, N'Admin')
GO
INSERT [dbo].[roles] ([id], [name]) VALUES (2, N'Manager')
GO
INSERT [dbo].[roles] ([id], [name]) VALUES (1, N'User')
GO
SET IDENTITY_INSERT [dbo].[roles] OFF
GO
SET IDENTITY_INSERT [dbo].[routes] ON 
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (1, 2, 1, CAST(N'2023-02-24' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (2, 3, 1, CAST(N'2023-11-21' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (3, 4, 1, CAST(N'2023-12-12' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (4, 5, 1, CAST(N'2024-05-18' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (5, 6, 1, CAST(N'2023-10-22' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (6, 7, 1, CAST(N'2023-02-28' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (7, 11, 1, CAST(N'2023-05-17' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (8, 13, 1, CAST(N'2024-01-16' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (9, 14, 1, CAST(N'2023-02-11' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (10, 15, 1, CAST(N'2023-06-29' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (11, 16, 1, CAST(N'2024-04-08' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (12, 18, 1, CAST(N'2023-05-31' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (13, 19, 1, CAST(N'2023-09-29' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (14, 20, 1, CAST(N'2023-08-14' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (15, 21, 1, CAST(N'2023-06-09' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (16, 22, 1, CAST(N'2023-07-11' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (17, 24, 1, CAST(N'2024-02-08' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (18, 25, 1, CAST(N'2023-02-25' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (19, 27, 1, CAST(N'2023-03-29' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (20, 29, 1, CAST(N'2023-09-22' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (21, 30, 1, CAST(N'2024-09-19' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (22, 31, 1, CAST(N'2023-02-07' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (23, 33, 1, CAST(N'2023-08-04' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (24, 36, 1, CAST(N'2024-11-05' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (25, 42, 1, CAST(N'2023-08-09' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (26, 44, 1, CAST(N'2023-11-15' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (27, 45, 1, CAST(N'2024-07-18' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (28, 48, 1, CAST(N'2023-02-26' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (29, 50, 1, CAST(N'2023-10-19' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (30, 51, 1, CAST(N'2024-06-07' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (31, 52, 1, CAST(N'2023-06-12' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (32, 57, 1, CAST(N'2023-03-20' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (33, 62, 1, CAST(N'2024-07-20' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (34, 65, 1, CAST(N'2024-01-09' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (35, 67, 1, CAST(N'2024-06-20' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (36, 68, 1, CAST(N'2023-05-12' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (37, 70, 1, CAST(N'2023-02-19' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (38, 71, 1, CAST(N'2023-05-07' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (39, 72, 1, CAST(N'2023-01-31' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (40, 75, 1, CAST(N'2023-08-28' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (41, 76, 1, CAST(N'2023-11-25' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (42, 80, 1, CAST(N'2023-06-04' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (43, 83, 1, CAST(N'2023-06-04' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (44, 84, 1, CAST(N'2023-11-22' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (45, 85, 1, CAST(N'2024-02-26' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (46, 86, 1, CAST(N'2023-05-21' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (47, 88, 1, CAST(N'2023-06-26' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (48, 89, 1, CAST(N'2024-04-22' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (49, 90, 1, CAST(N'2023-07-04' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (50, 91, 1, CAST(N'2023-09-25' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (51, 92, 1, CAST(N'2024-08-20' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (52, 94, 1, CAST(N'2023-08-06' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (53, 97, 1, CAST(N'2024-10-13' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (54, 99, 1, CAST(N'2023-04-12' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (55, 100, 1, CAST(N'2023-02-24' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (56, 101, 1, CAST(N'2024-02-08' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (57, 102, 1, CAST(N'2023-01-13' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (58, 104, 1, CAST(N'2023-03-16' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (59, 106, 1, CAST(N'2023-06-07' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (60, 108, 1, CAST(N'2024-07-12' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (61, 109, 1, CAST(N'2023-05-07' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (62, 110, 1, CAST(N'2023-01-08' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (63, 111, 1, CAST(N'2023-03-01' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (64, 113, 1, CAST(N'2023-05-18' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (65, 114, 1, CAST(N'2023-07-10' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (66, 115, 1, CAST(N'2024-03-16' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (67, 119, 1, CAST(N'2023-11-29' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (68, 120, 1, CAST(N'2023-04-26' AS Date), N'День 1')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (69, 2, 2, CAST(N'2023-02-25' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (70, 3, 2, CAST(N'2023-11-22' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (71, 4, 2, CAST(N'2023-12-13' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (72, 5, 2, CAST(N'2024-05-19' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (73, 6, 2, CAST(N'2023-10-23' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (74, 7, 2, CAST(N'2023-03-01' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (75, 11, 2, CAST(N'2023-05-18' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (76, 13, 2, CAST(N'2024-01-17' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (77, 14, 2, CAST(N'2023-02-12' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (78, 15, 2, CAST(N'2023-06-30' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (79, 16, 2, CAST(N'2024-04-09' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (80, 18, 2, CAST(N'2023-06-01' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (81, 19, 2, CAST(N'2023-09-30' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (82, 20, 2, CAST(N'2023-08-15' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (83, 21, 2, CAST(N'2023-06-10' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (84, 22, 2, CAST(N'2023-07-12' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (85, 24, 2, CAST(N'2024-02-09' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (86, 25, 2, CAST(N'2023-02-26' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (87, 27, 2, CAST(N'2023-03-30' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (88, 29, 2, CAST(N'2023-09-23' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (89, 30, 2, CAST(N'2024-09-20' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (90, 31, 2, CAST(N'2023-02-08' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (91, 33, 2, CAST(N'2023-08-05' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (92, 36, 2, CAST(N'2024-11-06' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (93, 42, 2, CAST(N'2023-08-10' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (94, 44, 2, CAST(N'2023-11-16' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (95, 45, 2, CAST(N'2024-07-19' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (96, 48, 2, CAST(N'2023-02-27' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (97, 50, 2, CAST(N'2023-10-20' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (98, 51, 2, CAST(N'2024-06-08' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (99, 52, 2, CAST(N'2023-06-13' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (100, 57, 2, CAST(N'2023-03-21' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (101, 62, 2, CAST(N'2024-07-21' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (102, 65, 2, CAST(N'2024-01-10' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (103, 67, 2, CAST(N'2024-06-21' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (104, 68, 2, CAST(N'2023-05-13' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (105, 70, 2, CAST(N'2023-02-20' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (106, 71, 2, CAST(N'2023-05-08' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (107, 72, 2, CAST(N'2023-02-01' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (108, 75, 2, CAST(N'2023-08-29' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (109, 76, 2, CAST(N'2023-11-26' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (110, 80, 2, CAST(N'2023-06-05' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (111, 83, 2, CAST(N'2023-06-05' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (112, 84, 2, CAST(N'2023-11-23' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (113, 85, 2, CAST(N'2024-02-27' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (114, 86, 2, CAST(N'2023-05-22' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (115, 88, 2, CAST(N'2023-06-27' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (116, 89, 2, CAST(N'2024-04-23' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (117, 90, 2, CAST(N'2023-07-05' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (118, 91, 2, CAST(N'2023-09-26' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (119, 92, 2, CAST(N'2024-08-21' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (120, 94, 2, CAST(N'2023-08-07' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (121, 97, 2, CAST(N'2024-10-14' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (122, 99, 2, CAST(N'2023-04-13' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (123, 100, 2, CAST(N'2023-02-25' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (124, 101, 2, CAST(N'2024-02-09' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (125, 102, 2, CAST(N'2023-01-14' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (126, 104, 2, CAST(N'2023-03-17' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (127, 106, 2, CAST(N'2023-06-08' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (128, 108, 2, CAST(N'2024-07-13' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (129, 109, 2, CAST(N'2023-05-08' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (130, 110, 2, CAST(N'2023-01-09' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (131, 111, 2, CAST(N'2023-03-02' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (132, 113, 2, CAST(N'2023-05-19' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (133, 114, 2, CAST(N'2023-07-11' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (134, 115, 2, CAST(N'2024-03-17' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (135, 119, 2, CAST(N'2023-11-30' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (136, 120, 2, CAST(N'2023-04-27' AS Date), N'День 2')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (137, 2, 3, CAST(N'2023-02-26' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (138, 3, 3, CAST(N'2023-11-23' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (139, 4, 3, CAST(N'2023-12-14' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (140, 5, 3, CAST(N'2024-05-20' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (141, 6, 3, CAST(N'2023-10-24' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (142, 7, 3, CAST(N'2023-03-02' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (143, 11, 3, CAST(N'2023-05-19' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (144, 13, 3, CAST(N'2024-01-18' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (145, 14, 3, CAST(N'2023-02-13' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (146, 15, 3, CAST(N'2023-07-01' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (147, 16, 3, CAST(N'2024-04-10' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (148, 18, 3, CAST(N'2023-06-02' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (149, 19, 3, CAST(N'2023-10-01' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (150, 20, 3, CAST(N'2023-08-16' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (151, 21, 3, CAST(N'2023-06-11' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (152, 22, 3, CAST(N'2023-07-13' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (153, 24, 3, CAST(N'2024-02-10' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (154, 25, 3, CAST(N'2023-02-27' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (155, 27, 3, CAST(N'2023-03-31' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (156, 29, 3, CAST(N'2023-09-24' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (157, 30, 3, CAST(N'2024-09-21' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (158, 31, 3, CAST(N'2023-02-09' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (159, 33, 3, CAST(N'2023-08-06' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (160, 36, 3, CAST(N'2024-11-07' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (161, 42, 3, CAST(N'2023-08-11' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (162, 44, 3, CAST(N'2023-11-17' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (163, 45, 3, CAST(N'2024-07-20' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (164, 48, 3, CAST(N'2023-02-28' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (165, 50, 3, CAST(N'2023-10-21' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (166, 51, 3, CAST(N'2024-06-09' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (167, 52, 3, CAST(N'2023-06-14' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (168, 57, 3, CAST(N'2023-03-22' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (169, 62, 3, CAST(N'2024-07-22' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (170, 65, 3, CAST(N'2024-01-11' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (171, 67, 3, CAST(N'2024-06-22' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (172, 68, 3, CAST(N'2023-05-14' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (173, 70, 3, CAST(N'2023-02-21' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (174, 71, 3, CAST(N'2023-05-09' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (175, 72, 3, CAST(N'2023-02-02' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (176, 75, 3, CAST(N'2023-08-30' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (177, 76, 3, CAST(N'2023-11-27' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (178, 80, 3, CAST(N'2023-06-06' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (179, 83, 3, CAST(N'2023-06-06' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (180, 84, 3, CAST(N'2023-11-24' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (181, 85, 3, CAST(N'2024-02-28' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (182, 86, 3, CAST(N'2023-05-23' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (183, 88, 3, CAST(N'2023-06-28' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (184, 89, 3, CAST(N'2024-04-24' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (185, 90, 3, CAST(N'2023-07-06' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (186, 91, 3, CAST(N'2023-09-27' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (187, 92, 3, CAST(N'2024-08-22' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (188, 94, 3, CAST(N'2023-08-08' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (189, 97, 3, CAST(N'2024-10-15' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (190, 99, 3, CAST(N'2023-04-14' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (191, 100, 3, CAST(N'2023-02-26' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (192, 101, 3, CAST(N'2024-02-10' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (193, 102, 3, CAST(N'2023-01-15' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (194, 104, 3, CAST(N'2023-03-18' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (195, 106, 3, CAST(N'2023-06-09' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (196, 108, 3, CAST(N'2024-07-14' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (197, 109, 3, CAST(N'2023-05-09' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (198, 110, 3, CAST(N'2023-01-10' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (199, 111, 3, CAST(N'2023-03-03' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (200, 113, 3, CAST(N'2023-05-20' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (201, 114, 3, CAST(N'2023-07-12' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (202, 115, 3, CAST(N'2024-03-18' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (203, 119, 3, CAST(N'2023-12-01' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (204, 120, 3, CAST(N'2023-04-28' AS Date), N'День 3')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (205, 2, 4, CAST(N'2023-02-27' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (206, 3, 4, CAST(N'2023-11-24' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (207, 4, 4, CAST(N'2023-12-15' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (208, 5, 4, CAST(N'2024-05-21' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (209, 6, 4, CAST(N'2023-10-25' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (210, 7, 4, CAST(N'2023-03-03' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (211, 11, 4, CAST(N'2023-05-20' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (212, 13, 4, CAST(N'2024-01-19' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (213, 14, 4, CAST(N'2023-02-14' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (214, 15, 4, CAST(N'2023-07-02' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (215, 16, 4, CAST(N'2024-04-11' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (216, 18, 4, CAST(N'2023-06-03' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (217, 19, 4, CAST(N'2023-10-02' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (218, 20, 4, CAST(N'2023-08-17' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (219, 21, 4, CAST(N'2023-06-12' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (220, 22, 4, CAST(N'2023-07-14' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (221, 24, 4, CAST(N'2024-02-11' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (222, 25, 4, CAST(N'2023-02-28' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (223, 27, 4, CAST(N'2023-04-01' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (224, 29, 4, CAST(N'2023-09-25' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (225, 30, 4, CAST(N'2024-09-22' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (226, 31, 4, CAST(N'2023-02-10' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (227, 33, 4, CAST(N'2023-08-07' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (228, 36, 4, CAST(N'2024-11-08' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (229, 42, 4, CAST(N'2023-08-12' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (230, 44, 4, CAST(N'2023-11-18' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (231, 45, 4, CAST(N'2024-07-21' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (232, 48, 4, CAST(N'2023-03-01' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (233, 50, 4, CAST(N'2023-10-22' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (234, 51, 4, CAST(N'2024-06-10' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (235, 52, 4, CAST(N'2023-06-15' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (236, 57, 4, CAST(N'2023-03-23' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (237, 62, 4, CAST(N'2024-07-23' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (238, 65, 4, CAST(N'2024-01-12' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (239, 67, 4, CAST(N'2024-06-23' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (240, 68, 4, CAST(N'2023-05-15' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (241, 70, 4, CAST(N'2023-02-22' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (242, 71, 4, CAST(N'2023-05-10' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (243, 72, 4, CAST(N'2023-02-03' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (244, 75, 4, CAST(N'2023-08-31' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (245, 76, 4, CAST(N'2023-11-28' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (246, 80, 4, CAST(N'2023-06-07' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (247, 83, 4, CAST(N'2023-06-07' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (248, 84, 4, CAST(N'2023-11-25' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (249, 85, 4, CAST(N'2024-02-29' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (250, 86, 4, CAST(N'2023-05-24' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (251, 88, 4, CAST(N'2023-06-29' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (252, 89, 4, CAST(N'2024-04-25' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (253, 90, 4, CAST(N'2023-07-07' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (254, 91, 4, CAST(N'2023-09-28' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (255, 92, 4, CAST(N'2024-08-23' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (256, 94, 4, CAST(N'2023-08-09' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (257, 97, 4, CAST(N'2024-10-16' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (258, 99, 4, CAST(N'2023-04-15' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (259, 100, 4, CAST(N'2023-02-27' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (260, 101, 4, CAST(N'2024-02-11' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (261, 102, 4, CAST(N'2023-01-16' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (262, 104, 4, CAST(N'2023-03-19' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (263, 106, 4, CAST(N'2023-06-10' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (264, 108, 4, CAST(N'2024-07-15' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (265, 109, 4, CAST(N'2023-05-10' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (266, 110, 4, CAST(N'2023-01-11' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (267, 111, 4, CAST(N'2023-03-04' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (268, 113, 4, CAST(N'2023-05-21' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (269, 114, 4, CAST(N'2023-07-13' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (270, 115, 4, CAST(N'2024-03-19' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (271, 119, 4, CAST(N'2023-12-02' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (272, 120, 4, CAST(N'2023-04-29' AS Date), N'День 4')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (273, 2, 5, CAST(N'2023-02-28' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (274, 3, 5, CAST(N'2023-11-25' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (275, 4, 5, CAST(N'2023-12-16' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (276, 5, 5, CAST(N'2024-05-22' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (277, 6, 5, CAST(N'2023-10-26' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (278, 7, 5, CAST(N'2023-03-04' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (279, 11, 5, CAST(N'2023-05-21' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (280, 13, 5, CAST(N'2024-01-20' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (281, 14, 5, CAST(N'2023-02-15' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (282, 15, 5, CAST(N'2023-07-03' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (283, 16, 5, CAST(N'2024-04-12' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (284, 18, 5, CAST(N'2023-06-04' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (285, 19, 5, CAST(N'2023-10-03' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (286, 20, 5, CAST(N'2023-08-18' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (287, 21, 5, CAST(N'2023-06-13' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (288, 22, 5, CAST(N'2023-07-15' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (289, 24, 5, CAST(N'2024-02-12' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (290, 25, 5, CAST(N'2023-03-01' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (291, 27, 5, CAST(N'2023-04-02' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (292, 29, 5, CAST(N'2023-09-26' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (293, 30, 5, CAST(N'2024-09-23' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (294, 31, 5, CAST(N'2023-02-11' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (295, 33, 5, CAST(N'2023-08-08' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (296, 36, 5, CAST(N'2024-11-09' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (297, 42, 5, CAST(N'2023-08-13' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (298, 44, 5, CAST(N'2023-11-19' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (299, 45, 5, CAST(N'2024-07-22' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (300, 48, 5, CAST(N'2023-03-02' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (301, 50, 5, CAST(N'2023-10-23' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (302, 51, 5, CAST(N'2024-06-11' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (303, 52, 5, CAST(N'2023-06-16' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (304, 57, 5, CAST(N'2023-03-24' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (305, 62, 5, CAST(N'2024-07-24' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (306, 65, 5, CAST(N'2024-01-13' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (307, 67, 5, CAST(N'2024-06-24' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (308, 68, 5, CAST(N'2023-05-16' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (309, 70, 5, CAST(N'2023-02-23' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (310, 71, 5, CAST(N'2023-05-11' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (311, 72, 5, CAST(N'2023-02-04' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (312, 75, 5, CAST(N'2023-09-01' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (313, 76, 5, CAST(N'2023-11-29' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (314, 80, 5, CAST(N'2023-06-08' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (315, 83, 5, CAST(N'2023-06-08' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (316, 84, 5, CAST(N'2023-11-26' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (317, 85, 5, CAST(N'2024-03-01' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (318, 86, 5, CAST(N'2023-05-25' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (319, 88, 5, CAST(N'2023-06-30' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (320, 89, 5, CAST(N'2024-04-26' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (321, 90, 5, CAST(N'2023-07-08' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (322, 91, 5, CAST(N'2023-09-29' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (323, 92, 5, CAST(N'2024-08-24' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (324, 94, 5, CAST(N'2023-08-10' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (325, 97, 5, CAST(N'2024-10-17' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (326, 99, 5, CAST(N'2023-04-16' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (327, 100, 5, CAST(N'2023-02-28' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (328, 101, 5, CAST(N'2024-02-12' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (329, 102, 5, CAST(N'2023-01-17' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (330, 104, 5, CAST(N'2023-03-20' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (331, 106, 5, CAST(N'2023-06-11' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (332, 108, 5, CAST(N'2024-07-16' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (333, 109, 5, CAST(N'2023-05-11' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (334, 110, 5, CAST(N'2023-01-12' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (335, 111, 5, CAST(N'2023-03-05' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (336, 113, 5, CAST(N'2023-05-22' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (337, 114, 5, CAST(N'2023-07-14' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (338, 115, 5, CAST(N'2024-03-20' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (339, 119, 5, CAST(N'2023-12-03' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (340, 120, 5, CAST(N'2023-04-30' AS Date), N'День 5')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (341, 2, 6, CAST(N'2023-03-01' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (342, 3, 6, CAST(N'2023-11-26' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (343, 4, 6, CAST(N'2023-12-17' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (344, 5, 6, CAST(N'2024-05-23' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (345, 6, 6, CAST(N'2023-10-27' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (346, 7, 6, CAST(N'2023-03-05' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (347, 11, 6, CAST(N'2023-05-22' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (348, 13, 6, CAST(N'2024-01-21' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (349, 14, 6, CAST(N'2023-02-16' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (350, 15, 6, CAST(N'2023-07-04' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (351, 16, 6, CAST(N'2024-04-13' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (352, 18, 6, CAST(N'2023-06-05' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (353, 19, 6, CAST(N'2023-10-04' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (354, 20, 6, CAST(N'2023-08-19' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (355, 21, 6, CAST(N'2023-06-14' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (356, 22, 6, CAST(N'2023-07-16' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (357, 24, 6, CAST(N'2024-02-13' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (358, 25, 6, CAST(N'2023-03-02' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (359, 27, 6, CAST(N'2023-04-03' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (360, 29, 6, CAST(N'2023-09-27' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (361, 30, 6, CAST(N'2024-09-24' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (362, 31, 6, CAST(N'2023-02-12' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (363, 33, 6, CAST(N'2023-08-09' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (364, 36, 6, CAST(N'2024-11-10' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (365, 42, 6, CAST(N'2023-08-14' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (366, 44, 6, CAST(N'2023-11-20' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (367, 45, 6, CAST(N'2024-07-23' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (368, 48, 6, CAST(N'2023-03-03' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (369, 50, 6, CAST(N'2023-10-24' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (370, 51, 6, CAST(N'2024-06-12' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (371, 52, 6, CAST(N'2023-06-17' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (372, 57, 6, CAST(N'2023-03-25' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (373, 62, 6, CAST(N'2024-07-25' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (374, 65, 6, CAST(N'2024-01-14' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (375, 67, 6, CAST(N'2024-06-25' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (376, 68, 6, CAST(N'2023-05-17' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (377, 70, 6, CAST(N'2023-02-24' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (378, 71, 6, CAST(N'2023-05-12' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (379, 72, 6, CAST(N'2023-02-05' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (380, 75, 6, CAST(N'2023-09-02' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (381, 76, 6, CAST(N'2023-11-30' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (382, 80, 6, CAST(N'2023-06-09' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (383, 83, 6, CAST(N'2023-06-09' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (384, 84, 6, CAST(N'2023-11-27' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (385, 85, 6, CAST(N'2024-03-02' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (386, 86, 6, CAST(N'2023-05-26' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (387, 88, 6, CAST(N'2023-07-01' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (388, 89, 6, CAST(N'2024-04-27' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (389, 90, 6, CAST(N'2023-07-09' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (390, 91, 6, CAST(N'2023-09-30' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (391, 92, 6, CAST(N'2024-08-25' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (392, 94, 6, CAST(N'2023-08-11' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (393, 97, 6, CAST(N'2024-10-18' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (394, 99, 6, CAST(N'2023-04-17' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (395, 100, 6, CAST(N'2023-03-01' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (396, 101, 6, CAST(N'2024-02-13' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (397, 102, 6, CAST(N'2023-01-18' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (398, 104, 6, CAST(N'2023-03-21' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (399, 106, 6, CAST(N'2023-06-12' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (400, 108, 6, CAST(N'2024-07-17' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (401, 109, 6, CAST(N'2023-05-12' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (402, 110, 6, CAST(N'2023-01-13' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (403, 111, 6, CAST(N'2023-03-06' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (404, 113, 6, CAST(N'2023-05-23' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (405, 114, 6, CAST(N'2023-07-15' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (406, 115, 6, CAST(N'2024-03-21' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (407, 119, 6, CAST(N'2023-12-04' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (408, 120, 6, CAST(N'2023-05-01' AS Date), N'День 6')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (409, 2, 7, CAST(N'2023-03-02' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (410, 3, 7, CAST(N'2023-11-27' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (411, 4, 7, CAST(N'2023-12-18' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (412, 5, 7, CAST(N'2024-05-24' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (413, 6, 7, CAST(N'2023-10-28' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (414, 7, 7, CAST(N'2023-03-06' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (415, 11, 7, CAST(N'2023-05-23' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (416, 13, 7, CAST(N'2024-01-22' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (417, 14, 7, CAST(N'2023-02-17' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (418, 15, 7, CAST(N'2023-07-05' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (419, 16, 7, CAST(N'2024-04-14' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (420, 18, 7, CAST(N'2023-06-06' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (421, 19, 7, CAST(N'2023-10-05' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (422, 20, 7, CAST(N'2023-08-20' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (423, 21, 7, CAST(N'2023-06-15' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (424, 22, 7, CAST(N'2023-07-17' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (425, 25, 7, CAST(N'2023-03-03' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (426, 27, 7, CAST(N'2023-04-04' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (427, 29, 7, CAST(N'2023-09-28' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (428, 30, 7, CAST(N'2024-09-25' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (429, 31, 7, CAST(N'2023-02-13' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (430, 33, 7, CAST(N'2023-08-10' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (431, 36, 7, CAST(N'2024-11-11' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (432, 42, 7, CAST(N'2023-08-15' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (433, 44, 7, CAST(N'2023-11-21' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (434, 45, 7, CAST(N'2024-07-24' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (435, 48, 7, CAST(N'2023-03-04' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (436, 50, 7, CAST(N'2023-10-25' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (437, 51, 7, CAST(N'2024-06-13' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (438, 52, 7, CAST(N'2023-06-18' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (439, 57, 7, CAST(N'2023-03-26' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (440, 62, 7, CAST(N'2024-07-26' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (441, 65, 7, CAST(N'2024-01-15' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (442, 67, 7, CAST(N'2024-06-26' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (443, 68, 7, CAST(N'2023-05-18' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (444, 70, 7, CAST(N'2023-02-25' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (445, 71, 7, CAST(N'2023-05-13' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (446, 72, 7, CAST(N'2023-02-06' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (447, 75, 7, CAST(N'2023-09-03' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (448, 76, 7, CAST(N'2023-12-01' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (449, 80, 7, CAST(N'2023-06-10' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (450, 83, 7, CAST(N'2023-06-10' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (451, 84, 7, CAST(N'2023-11-28' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (452, 85, 7, CAST(N'2024-03-03' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (453, 86, 7, CAST(N'2023-05-27' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (454, 88, 7, CAST(N'2023-07-02' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (455, 89, 7, CAST(N'2024-04-28' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (456, 90, 7, CAST(N'2023-07-10' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (457, 91, 7, CAST(N'2023-10-01' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (458, 92, 7, CAST(N'2024-08-26' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (459, 94, 7, CAST(N'2023-08-12' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (460, 97, 7, CAST(N'2024-10-19' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (461, 99, 7, CAST(N'2023-04-18' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (462, 100, 7, CAST(N'2023-03-02' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (463, 101, 7, CAST(N'2024-02-14' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (464, 102, 7, CAST(N'2023-01-19' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (465, 104, 7, CAST(N'2023-03-22' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (466, 106, 7, CAST(N'2023-06-13' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (467, 108, 7, CAST(N'2024-07-18' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (468, 109, 7, CAST(N'2023-05-13' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (469, 110, 7, CAST(N'2023-01-14' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (470, 111, 7, CAST(N'2023-03-07' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (471, 113, 7, CAST(N'2023-05-24' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (472, 114, 7, CAST(N'2023-07-16' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (473, 115, 7, CAST(N'2024-03-22' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (474, 119, 7, CAST(N'2023-12-05' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (475, 120, 7, CAST(N'2023-05-02' AS Date), N'День 7')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (476, 2, 8, CAST(N'2023-03-03' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (477, 3, 8, CAST(N'2023-11-28' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (478, 4, 8, CAST(N'2023-12-19' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (479, 5, 8, CAST(N'2024-05-25' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (480, 6, 8, CAST(N'2023-10-29' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (481, 7, 8, CAST(N'2023-03-07' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (482, 11, 8, CAST(N'2023-05-24' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (483, 13, 8, CAST(N'2024-01-23' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (484, 14, 8, CAST(N'2023-02-18' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (485, 15, 8, CAST(N'2023-07-06' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (486, 16, 8, CAST(N'2024-04-15' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (487, 18, 8, CAST(N'2023-06-07' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (488, 19, 8, CAST(N'2023-10-06' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (489, 20, 8, CAST(N'2023-08-21' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (490, 21, 8, CAST(N'2023-06-16' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (491, 22, 8, CAST(N'2023-07-18' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (492, 25, 8, CAST(N'2023-03-04' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (493, 27, 8, CAST(N'2023-04-05' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (494, 29, 8, CAST(N'2023-09-29' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (495, 30, 8, CAST(N'2024-09-26' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (496, 31, 8, CAST(N'2023-02-14' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (497, 33, 8, CAST(N'2023-08-11' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (498, 36, 8, CAST(N'2024-11-12' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (499, 42, 8, CAST(N'2023-08-16' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (500, 44, 8, CAST(N'2023-11-22' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (501, 45, 8, CAST(N'2024-07-25' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (502, 48, 8, CAST(N'2023-03-05' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (503, 50, 8, CAST(N'2023-10-26' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (504, 51, 8, CAST(N'2024-06-14' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (505, 52, 8, CAST(N'2023-06-19' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (506, 57, 8, CAST(N'2023-03-27' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (507, 62, 8, CAST(N'2024-07-27' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (508, 65, 8, CAST(N'2024-01-16' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (509, 67, 8, CAST(N'2024-06-27' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (510, 68, 8, CAST(N'2023-05-19' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (511, 70, 8, CAST(N'2023-02-26' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (512, 71, 8, CAST(N'2023-05-14' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (513, 72, 8, CAST(N'2023-02-07' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (514, 75, 8, CAST(N'2023-09-04' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (515, 76, 8, CAST(N'2023-12-02' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (516, 80, 8, CAST(N'2023-06-11' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (517, 83, 8, CAST(N'2023-06-11' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (518, 84, 8, CAST(N'2023-11-29' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (519, 85, 8, CAST(N'2024-03-04' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (520, 86, 8, CAST(N'2023-05-28' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (521, 88, 8, CAST(N'2023-07-03' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (522, 89, 8, CAST(N'2024-04-29' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (523, 90, 8, CAST(N'2023-07-11' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (524, 91, 8, CAST(N'2023-10-02' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (525, 92, 8, CAST(N'2024-08-27' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (526, 94, 8, CAST(N'2023-08-13' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (527, 97, 8, CAST(N'2024-10-20' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (528, 99, 8, CAST(N'2023-04-19' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (529, 100, 8, CAST(N'2023-03-03' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (530, 101, 8, CAST(N'2024-02-15' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (531, 102, 8, CAST(N'2023-01-20' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (532, 104, 8, CAST(N'2023-03-23' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (533, 106, 8, CAST(N'2023-06-14' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (534, 108, 8, CAST(N'2024-07-19' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (535, 109, 8, CAST(N'2023-05-14' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (536, 110, 8, CAST(N'2023-01-15' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (537, 111, 8, CAST(N'2023-03-08' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (538, 113, 8, CAST(N'2023-05-25' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (539, 114, 8, CAST(N'2023-07-17' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (540, 115, 8, CAST(N'2024-03-23' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (541, 119, 8, CAST(N'2023-12-06' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (542, 120, 8, CAST(N'2023-05-03' AS Date), N'День 8')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (543, 2, 9, CAST(N'2023-03-04' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (544, 3, 9, CAST(N'2023-11-29' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (545, 4, 9, CAST(N'2023-12-20' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (546, 5, 9, CAST(N'2024-05-26' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (547, 6, 9, CAST(N'2023-10-30' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (548, 7, 9, CAST(N'2023-03-08' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (549, 11, 9, CAST(N'2023-05-25' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (550, 13, 9, CAST(N'2024-01-24' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (551, 14, 9, CAST(N'2023-02-19' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (552, 15, 9, CAST(N'2023-07-07' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (553, 16, 9, CAST(N'2024-04-16' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (554, 18, 9, CAST(N'2023-06-08' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (555, 19, 9, CAST(N'2023-10-07' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (556, 20, 9, CAST(N'2023-08-22' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (557, 21, 9, CAST(N'2023-06-17' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (558, 22, 9, CAST(N'2023-07-19' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (559, 25, 9, CAST(N'2023-03-05' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (560, 27, 9, CAST(N'2023-04-06' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (561, 29, 9, CAST(N'2023-09-30' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (562, 30, 9, CAST(N'2024-09-27' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (563, 31, 9, CAST(N'2023-02-15' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (564, 33, 9, CAST(N'2023-08-12' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (565, 36, 9, CAST(N'2024-11-13' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (566, 42, 9, CAST(N'2023-08-17' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (567, 44, 9, CAST(N'2023-11-23' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (568, 45, 9, CAST(N'2024-07-26' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (569, 48, 9, CAST(N'2023-03-06' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (570, 50, 9, CAST(N'2023-10-27' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (571, 51, 9, CAST(N'2024-06-15' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (572, 52, 9, CAST(N'2023-06-20' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (573, 57, 9, CAST(N'2023-03-28' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (574, 62, 9, CAST(N'2024-07-28' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (575, 65, 9, CAST(N'2024-01-17' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (576, 67, 9, CAST(N'2024-06-28' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (577, 68, 9, CAST(N'2023-05-20' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (578, 70, 9, CAST(N'2023-02-27' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (579, 71, 9, CAST(N'2023-05-15' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (580, 72, 9, CAST(N'2023-02-08' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (581, 75, 9, CAST(N'2023-09-05' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (582, 76, 9, CAST(N'2023-12-03' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (583, 80, 9, CAST(N'2023-06-12' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (584, 83, 9, CAST(N'2023-06-12' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (585, 84, 9, CAST(N'2023-11-30' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (586, 85, 9, CAST(N'2024-03-05' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (587, 86, 9, CAST(N'2023-05-29' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (588, 88, 9, CAST(N'2023-07-04' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (589, 89, 9, CAST(N'2024-04-30' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (590, 90, 9, CAST(N'2023-07-12' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (591, 91, 9, CAST(N'2023-10-03' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (592, 92, 9, CAST(N'2024-08-28' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (593, 94, 9, CAST(N'2023-08-14' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (594, 97, 9, CAST(N'2024-10-21' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (595, 99, 9, CAST(N'2023-04-20' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (596, 100, 9, CAST(N'2023-03-04' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (597, 101, 9, CAST(N'2024-02-16' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (598, 102, 9, CAST(N'2023-01-21' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (599, 104, 9, CAST(N'2023-03-24' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (600, 106, 9, CAST(N'2023-06-15' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (601, 108, 9, CAST(N'2024-07-20' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (602, 109, 9, CAST(N'2023-05-15' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (603, 110, 9, CAST(N'2023-01-16' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (604, 111, 9, CAST(N'2023-03-09' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (605, 113, 9, CAST(N'2023-05-26' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (606, 114, 9, CAST(N'2023-07-18' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (607, 115, 9, CAST(N'2024-03-24' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (608, 119, 9, CAST(N'2023-12-07' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (609, 120, 9, CAST(N'2023-05-04' AS Date), N'День 9')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (610, 2, 10, CAST(N'2023-03-05' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (611, 3, 10, CAST(N'2023-11-30' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (612, 4, 10, CAST(N'2023-12-21' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (613, 5, 10, CAST(N'2024-05-27' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (614, 6, 10, CAST(N'2023-10-31' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (615, 7, 10, CAST(N'2023-03-09' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (616, 11, 10, CAST(N'2023-05-26' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (617, 13, 10, CAST(N'2024-01-25' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (618, 14, 10, CAST(N'2023-02-20' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (619, 15, 10, CAST(N'2023-07-08' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (620, 16, 10, CAST(N'2024-04-17' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (621, 18, 10, CAST(N'2023-06-09' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (622, 19, 10, CAST(N'2023-10-08' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (623, 20, 10, CAST(N'2023-08-23' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (624, 21, 10, CAST(N'2023-06-18' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (625, 22, 10, CAST(N'2023-07-20' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (626, 25, 10, CAST(N'2023-03-06' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (627, 27, 10, CAST(N'2023-04-07' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (628, 29, 10, CAST(N'2023-10-01' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (629, 30, 10, CAST(N'2024-09-28' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (630, 31, 10, CAST(N'2023-02-16' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (631, 33, 10, CAST(N'2023-08-13' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (632, 36, 10, CAST(N'2024-11-14' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (633, 42, 10, CAST(N'2023-08-18' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (634, 44, 10, CAST(N'2023-11-24' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (635, 45, 10, CAST(N'2024-07-27' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (636, 48, 10, CAST(N'2023-03-07' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (637, 50, 10, CAST(N'2023-10-28' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (638, 51, 10, CAST(N'2024-06-16' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (639, 52, 10, CAST(N'2023-06-21' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (640, 57, 10, CAST(N'2023-03-29' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (641, 62, 10, CAST(N'2024-07-29' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (642, 65, 10, CAST(N'2024-01-18' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (643, 67, 10, CAST(N'2024-06-29' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (644, 68, 10, CAST(N'2023-05-21' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (645, 70, 10, CAST(N'2023-02-28' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (646, 71, 10, CAST(N'2023-05-16' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (647, 72, 10, CAST(N'2023-02-09' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (648, 75, 10, CAST(N'2023-09-06' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (649, 76, 10, CAST(N'2023-12-04' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (650, 80, 10, CAST(N'2023-06-13' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (651, 83, 10, CAST(N'2023-06-13' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (652, 84, 10, CAST(N'2023-12-01' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (653, 85, 10, CAST(N'2024-03-06' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (654, 86, 10, CAST(N'2023-05-30' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (655, 88, 10, CAST(N'2023-07-05' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (656, 89, 10, CAST(N'2024-05-01' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (657, 90, 10, CAST(N'2023-07-13' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (658, 91, 10, CAST(N'2023-10-04' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (659, 92, 10, CAST(N'2024-08-29' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (660, 94, 10, CAST(N'2023-08-15' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (661, 97, 10, CAST(N'2024-10-22' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (662, 99, 10, CAST(N'2023-04-21' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (663, 100, 10, CAST(N'2023-03-05' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (664, 101, 10, CAST(N'2024-02-17' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (665, 102, 10, CAST(N'2023-01-22' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (666, 104, 10, CAST(N'2023-03-25' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (667, 106, 10, CAST(N'2023-06-16' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (668, 108, 10, CAST(N'2024-07-21' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (669, 109, 10, CAST(N'2023-05-16' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (670, 110, 10, CAST(N'2023-01-17' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (671, 111, 10, CAST(N'2023-03-10' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (672, 113, 10, CAST(N'2023-05-27' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (673, 114, 10, CAST(N'2023-07-19' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (674, 115, 10, CAST(N'2024-03-25' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (675, 119, 10, CAST(N'2023-12-08' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (676, 120, 10, CAST(N'2023-05-05' AS Date), N'День 10')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (677, 2, 11, CAST(N'2023-03-06' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (678, 3, 11, CAST(N'2023-12-01' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (679, 4, 11, CAST(N'2023-12-22' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (680, 5, 11, CAST(N'2024-05-28' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (681, 6, 11, CAST(N'2023-11-01' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (682, 7, 11, CAST(N'2023-03-10' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (683, 11, 11, CAST(N'2023-05-27' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (684, 13, 11, CAST(N'2024-01-26' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (685, 14, 11, CAST(N'2023-02-21' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (686, 15, 11, CAST(N'2023-07-09' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (687, 16, 11, CAST(N'2024-04-18' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (688, 18, 11, CAST(N'2023-06-10' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (689, 19, 11, CAST(N'2023-10-09' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (690, 20, 11, CAST(N'2023-08-24' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (691, 21, 11, CAST(N'2023-06-19' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (692, 22, 11, CAST(N'2023-07-21' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (693, 25, 11, CAST(N'2023-03-07' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (694, 27, 11, CAST(N'2023-04-08' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (695, 29, 11, CAST(N'2023-10-02' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (696, 30, 11, CAST(N'2024-09-29' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (697, 31, 11, CAST(N'2023-02-17' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (698, 33, 11, CAST(N'2023-08-14' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (699, 36, 11, CAST(N'2024-11-15' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (700, 42, 11, CAST(N'2023-08-19' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (701, 44, 11, CAST(N'2023-11-25' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (702, 45, 11, CAST(N'2024-07-28' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (703, 48, 11, CAST(N'2023-03-08' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (704, 50, 11, CAST(N'2023-10-29' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (705, 51, 11, CAST(N'2024-06-17' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (706, 52, 11, CAST(N'2023-06-22' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (707, 57, 11, CAST(N'2023-03-30' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (708, 62, 11, CAST(N'2024-07-30' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (709, 65, 11, CAST(N'2024-01-19' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (710, 67, 11, CAST(N'2024-06-30' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (711, 68, 11, CAST(N'2023-05-22' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (712, 70, 11, CAST(N'2023-03-01' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (713, 71, 11, CAST(N'2023-05-17' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (714, 72, 11, CAST(N'2023-02-10' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (715, 75, 11, CAST(N'2023-09-07' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (716, 76, 11, CAST(N'2023-12-05' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (717, 80, 11, CAST(N'2023-06-14' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (718, 83, 11, CAST(N'2023-06-14' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (719, 84, 11, CAST(N'2023-12-02' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (720, 85, 11, CAST(N'2024-03-07' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (721, 86, 11, CAST(N'2023-05-31' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (722, 88, 11, CAST(N'2023-07-06' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (723, 89, 11, CAST(N'2024-05-02' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (724, 90, 11, CAST(N'2023-07-14' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (725, 91, 11, CAST(N'2023-10-05' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (726, 92, 11, CAST(N'2024-08-30' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (727, 94, 11, CAST(N'2023-08-16' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (728, 97, 11, CAST(N'2024-10-23' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (729, 99, 11, CAST(N'2023-04-22' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (730, 100, 11, CAST(N'2023-03-06' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (731, 101, 11, CAST(N'2024-02-18' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (732, 102, 11, CAST(N'2023-01-23' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (733, 104, 11, CAST(N'2023-03-26' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (734, 106, 11, CAST(N'2023-06-17' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (735, 109, 11, CAST(N'2023-05-17' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (736, 110, 11, CAST(N'2023-01-18' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (737, 111, 11, CAST(N'2023-03-11' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (738, 113, 11, CAST(N'2023-05-28' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (739, 114, 11, CAST(N'2023-07-20' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (740, 115, 11, CAST(N'2024-03-26' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (741, 119, 11, CAST(N'2023-12-09' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (742, 120, 11, CAST(N'2023-05-06' AS Date), N'День 11')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (743, 2, 12, CAST(N'2023-03-07' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (744, 3, 12, CAST(N'2023-12-02' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (745, 4, 12, CAST(N'2023-12-23' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (746, 5, 12, CAST(N'2024-05-29' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (747, 6, 12, CAST(N'2023-11-02' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (748, 7, 12, CAST(N'2023-03-11' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (749, 11, 12, CAST(N'2023-05-28' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (750, 13, 12, CAST(N'2024-01-27' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (751, 14, 12, CAST(N'2023-02-22' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (752, 15, 12, CAST(N'2023-07-10' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (753, 16, 12, CAST(N'2024-04-19' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (754, 18, 12, CAST(N'2023-06-11' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (755, 19, 12, CAST(N'2023-10-10' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (756, 20, 12, CAST(N'2023-08-25' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (757, 21, 12, CAST(N'2023-06-20' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (758, 22, 12, CAST(N'2023-07-22' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (759, 25, 12, CAST(N'2023-03-08' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (760, 27, 12, CAST(N'2023-04-09' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (761, 29, 12, CAST(N'2023-10-03' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (762, 30, 12, CAST(N'2024-09-30' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (763, 31, 12, CAST(N'2023-02-18' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (764, 33, 12, CAST(N'2023-08-15' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (765, 36, 12, CAST(N'2024-11-16' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (766, 42, 12, CAST(N'2023-08-20' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (767, 44, 12, CAST(N'2023-11-26' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (768, 45, 12, CAST(N'2024-07-29' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (769, 48, 12, CAST(N'2023-03-09' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (770, 50, 12, CAST(N'2023-10-30' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (771, 51, 12, CAST(N'2024-06-18' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (772, 52, 12, CAST(N'2023-06-23' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (773, 57, 12, CAST(N'2023-03-31' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (774, 62, 12, CAST(N'2024-07-31' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (775, 65, 12, CAST(N'2024-01-20' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (776, 67, 12, CAST(N'2024-07-01' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (777, 68, 12, CAST(N'2023-05-23' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (778, 70, 12, CAST(N'2023-03-02' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (779, 71, 12, CAST(N'2023-05-18' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (780, 72, 12, CAST(N'2023-02-11' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (781, 75, 12, CAST(N'2023-09-08' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (782, 76, 12, CAST(N'2023-12-06' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (783, 80, 12, CAST(N'2023-06-15' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (784, 83, 12, CAST(N'2023-06-15' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (785, 84, 12, CAST(N'2023-12-03' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (786, 85, 12, CAST(N'2024-03-08' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (787, 86, 12, CAST(N'2023-06-01' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (788, 88, 12, CAST(N'2023-07-07' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (789, 89, 12, CAST(N'2024-05-03' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (790, 90, 12, CAST(N'2023-07-15' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (791, 91, 12, CAST(N'2023-10-06' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (792, 92, 12, CAST(N'2024-08-31' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (793, 94, 12, CAST(N'2023-08-17' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (794, 97, 12, CAST(N'2024-10-24' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (795, 99, 12, CAST(N'2023-04-23' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (796, 100, 12, CAST(N'2023-03-07' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (797, 101, 12, CAST(N'2024-02-19' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (798, 102, 12, CAST(N'2023-01-24' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (799, 104, 12, CAST(N'2023-03-27' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (800, 106, 12, CAST(N'2023-06-18' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (801, 109, 12, CAST(N'2023-05-18' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (802, 110, 12, CAST(N'2023-01-19' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (803, 111, 12, CAST(N'2023-03-12' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (804, 113, 12, CAST(N'2023-05-29' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (805, 114, 12, CAST(N'2023-07-21' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (806, 115, 12, CAST(N'2024-03-27' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (807, 119, 12, CAST(N'2023-12-10' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (808, 120, 12, CAST(N'2023-05-07' AS Date), N'День 12')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (809, 2, 13, CAST(N'2023-03-08' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (810, 3, 13, CAST(N'2023-12-03' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (811, 4, 13, CAST(N'2023-12-24' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (812, 5, 13, CAST(N'2024-05-30' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (813, 6, 13, CAST(N'2023-11-03' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (814, 7, 13, CAST(N'2023-03-12' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (815, 11, 13, CAST(N'2023-05-29' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (816, 13, 13, CAST(N'2024-01-28' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (817, 14, 13, CAST(N'2023-02-23' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (818, 15, 13, CAST(N'2023-07-11' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (819, 16, 13, CAST(N'2024-04-20' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (820, 18, 13, CAST(N'2023-06-12' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (821, 19, 13, CAST(N'2023-10-11' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (822, 20, 13, CAST(N'2023-08-26' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (823, 21, 13, CAST(N'2023-06-21' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (824, 22, 13, CAST(N'2023-07-23' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (825, 25, 13, CAST(N'2023-03-09' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (826, 27, 13, CAST(N'2023-04-10' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (827, 29, 13, CAST(N'2023-10-04' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (828, 30, 13, CAST(N'2024-10-01' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (829, 31, 13, CAST(N'2023-02-19' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (830, 33, 13, CAST(N'2023-08-16' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (831, 36, 13, CAST(N'2024-11-17' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (832, 42, 13, CAST(N'2023-08-21' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (833, 44, 13, CAST(N'2023-11-27' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (834, 45, 13, CAST(N'2024-07-30' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (835, 48, 13, CAST(N'2023-03-10' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (836, 50, 13, CAST(N'2023-10-31' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (837, 51, 13, CAST(N'2024-06-19' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (838, 52, 13, CAST(N'2023-06-24' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (839, 57, 13, CAST(N'2023-04-01' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (840, 62, 13, CAST(N'2024-08-01' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (841, 65, 13, CAST(N'2024-01-21' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (842, 67, 13, CAST(N'2024-07-02' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (843, 68, 13, CAST(N'2023-05-24' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (844, 70, 13, CAST(N'2023-03-03' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (845, 71, 13, CAST(N'2023-05-19' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (846, 72, 13, CAST(N'2023-02-12' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (847, 75, 13, CAST(N'2023-09-09' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (848, 76, 13, CAST(N'2023-12-07' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (849, 80, 13, CAST(N'2023-06-16' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (850, 83, 13, CAST(N'2023-06-16' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (851, 84, 13, CAST(N'2023-12-04' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (852, 85, 13, CAST(N'2024-03-09' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (853, 86, 13, CAST(N'2023-06-02' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (854, 88, 13, CAST(N'2023-07-08' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (855, 89, 13, CAST(N'2024-05-04' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (856, 90, 13, CAST(N'2023-07-16' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (857, 91, 13, CAST(N'2023-10-07' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (858, 92, 13, CAST(N'2024-09-01' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (859, 94, 13, CAST(N'2023-08-18' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (860, 97, 13, CAST(N'2024-10-25' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (861, 99, 13, CAST(N'2023-04-24' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (862, 100, 13, CAST(N'2023-03-08' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (863, 101, 13, CAST(N'2024-02-20' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (864, 102, 13, CAST(N'2023-01-25' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (865, 104, 13, CAST(N'2023-03-28' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (866, 106, 13, CAST(N'2023-06-19' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (867, 109, 13, CAST(N'2023-05-19' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (868, 110, 13, CAST(N'2023-01-20' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (869, 111, 13, CAST(N'2023-03-13' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (870, 113, 13, CAST(N'2023-05-30' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (871, 114, 13, CAST(N'2023-07-22' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (872, 115, 13, CAST(N'2024-03-28' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (873, 119, 13, CAST(N'2023-12-11' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (874, 120, 13, CAST(N'2023-05-08' AS Date), N'День 13')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (875, 2, 14, CAST(N'2023-03-09' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (876, 3, 14, CAST(N'2023-12-04' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (877, 4, 14, CAST(N'2023-12-25' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (878, 5, 14, CAST(N'2024-05-31' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (879, 6, 14, CAST(N'2023-11-04' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (880, 7, 14, CAST(N'2023-03-13' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (881, 11, 14, CAST(N'2023-05-30' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (882, 13, 14, CAST(N'2024-01-29' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (883, 14, 14, CAST(N'2023-02-24' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (884, 15, 14, CAST(N'2023-07-12' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (885, 16, 14, CAST(N'2024-04-21' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (886, 18, 14, CAST(N'2023-06-13' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (887, 19, 14, CAST(N'2023-10-12' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (888, 20, 14, CAST(N'2023-08-27' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (889, 21, 14, CAST(N'2023-06-22' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (890, 22, 14, CAST(N'2023-07-24' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (891, 25, 14, CAST(N'2023-03-10' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (892, 27, 14, CAST(N'2023-04-11' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (893, 29, 14, CAST(N'2023-10-05' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (894, 30, 14, CAST(N'2024-10-02' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (895, 31, 14, CAST(N'2023-02-20' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (896, 33, 14, CAST(N'2023-08-17' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (897, 36, 14, CAST(N'2024-11-18' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (898, 42, 14, CAST(N'2023-08-22' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (899, 44, 14, CAST(N'2023-11-28' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (900, 45, 14, CAST(N'2024-07-31' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (901, 48, 14, CAST(N'2023-03-11' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (902, 50, 14, CAST(N'2023-11-01' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (903, 51, 14, CAST(N'2024-06-20' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (904, 52, 14, CAST(N'2023-06-25' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (905, 57, 14, CAST(N'2023-04-02' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (906, 62, 14, CAST(N'2024-08-02' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (907, 65, 14, CAST(N'2024-01-22' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (908, 67, 14, CAST(N'2024-07-03' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (909, 68, 14, CAST(N'2023-05-25' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (910, 70, 14, CAST(N'2023-03-04' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (911, 71, 14, CAST(N'2023-05-20' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (912, 72, 14, CAST(N'2023-02-13' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (913, 75, 14, CAST(N'2023-09-10' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (914, 76, 14, CAST(N'2023-12-08' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (915, 80, 14, CAST(N'2023-06-17' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (916, 83, 14, CAST(N'2023-06-17' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (917, 84, 14, CAST(N'2023-12-05' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (918, 85, 14, CAST(N'2024-03-10' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (919, 86, 14, CAST(N'2023-06-03' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (920, 88, 14, CAST(N'2023-07-09' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (921, 89, 14, CAST(N'2024-05-05' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (922, 90, 14, CAST(N'2023-07-17' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (923, 91, 14, CAST(N'2023-10-08' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (924, 92, 14, CAST(N'2024-09-02' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (925, 94, 14, CAST(N'2023-08-19' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (926, 97, 14, CAST(N'2024-10-26' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (927, 99, 14, CAST(N'2023-04-25' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (928, 100, 14, CAST(N'2023-03-09' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (929, 101, 14, CAST(N'2024-02-21' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (930, 102, 14, CAST(N'2023-01-26' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (931, 104, 14, CAST(N'2023-03-29' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (932, 106, 14, CAST(N'2023-06-20' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (933, 109, 14, CAST(N'2023-05-20' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (934, 110, 14, CAST(N'2023-01-21' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (935, 111, 14, CAST(N'2023-03-14' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (936, 113, 14, CAST(N'2023-05-31' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (937, 114, 14, CAST(N'2023-07-23' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (938, 115, 14, CAST(N'2024-03-29' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (939, 119, 14, CAST(N'2023-12-12' AS Date), N'День 14')
GO
INSERT [dbo].[routes] ([id], [trip_id], [day_number], [date], [notes]) VALUES (940, 120, 14, CAST(N'2023-05-09' AS Date), N'День 14')
GO
SET IDENTITY_INSERT [dbo].[routes] OFF
GO
SET IDENTITY_INSERT [dbo].[travel_notes] ON 
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (1, 1, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_1_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (2, 1, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_1_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (3, 2, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_2_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (4, 2, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_2_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (5, 3, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_3_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (6, 3, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_3_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (7, 4, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_4_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (8, 4, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_4_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (9, 5, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_5_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (10, 5, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_5_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (11, 6, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_6_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (12, 6, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_6_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (13, 7, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_7_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (14, 7, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_7_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (15, 8, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_8_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (16, 8, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_8_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (17, 9, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_9_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (18, 9, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_9_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (19, 10, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_10_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (20, 10, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_10_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (21, 11, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_11_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (22, 11, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_11_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (23, 12, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_12_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (24, 12, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_12_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (25, 13, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_13_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (26, 13, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_13_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (27, 14, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_14_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (28, 14, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_14_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (29, 15, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_15_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (30, 15, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_15_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (31, 16, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_16_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (32, 16, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_16_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (33, 17, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_17_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (34, 17, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_17_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (35, 18, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_18_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (36, 18, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_18_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (37, 19, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_19_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (38, 19, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_19_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (39, 20, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_20_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (40, 20, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_20_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (41, 21, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_21_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (42, 21, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_21_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (43, 22, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_22_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (44, 22, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_22_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (45, 23, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_23_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (46, 23, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_23_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (47, 24, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_24_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (48, 24, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_24_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (49, 25, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_25_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (50, 25, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_25_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (51, 26, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_26_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (52, 26, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_26_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (53, 27, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_27_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (54, 27, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_27_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (55, 28, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_28_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (56, 28, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_28_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (57, 29, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_29_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (58, 29, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_29_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (59, 30, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_30_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (60, 30, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_30_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (61, 31, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_31_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (62, 31, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_31_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (63, 32, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_32_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (64, 32, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_32_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (65, 33, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_33_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (66, 33, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_33_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (67, 34, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_34_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (68, 34, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_34_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (69, 35, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_35_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (70, 35, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_35_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (71, 36, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_36_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (72, 36, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_36_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (73, 37, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_37_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (74, 37, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_37_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (75, 38, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_38_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (76, 38, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_38_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (77, 39, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_39_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (78, 39, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_39_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (79, 40, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_40_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (80, 40, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_40_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (81, 41, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_41_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (82, 41, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_41_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (83, 42, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_42_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (84, 42, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_42_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (85, 43, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_43_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (86, 43, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_43_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (87, 44, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_44_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (88, 44, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_44_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (89, 45, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_45_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (90, 45, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_45_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (91, 46, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_46_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (92, 46, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_46_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (93, 47, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_47_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (94, 47, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_47_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (95, 48, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_48_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (96, 48, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_48_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (97, 49, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_49_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (98, 49, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_49_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (99, 50, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_50_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (100, 50, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_50_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (101, 51, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_51_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (102, 51, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_51_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (103, 52, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_52_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (104, 52, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_52_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (105, 53, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_53_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (106, 53, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_53_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (107, 54, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_54_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (108, 54, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_54_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (109, 55, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_55_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (110, 55, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_55_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (111, 56, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_56_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (112, 56, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_56_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (113, 57, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_57_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (114, 57, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_57_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (115, 58, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_58_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (116, 58, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_58_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (117, 59, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_59_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (118, 59, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_59_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (119, 60, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_60_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (120, 60, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_60_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (121, 61, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_61_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (122, 61, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_61_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (123, 62, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_62_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (124, 62, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_62_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (125, 63, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_63_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (126, 63, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_63_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (127, 64, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_64_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (128, 64, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_64_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (129, 65, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_65_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (130, 65, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_65_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (131, 66, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_66_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (132, 66, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_66_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (133, 67, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_67_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (134, 67, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_67_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (135, 68, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_68_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (136, 68, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_68_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (137, 69, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_69_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (138, 69, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_69_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (139, 70, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_70_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (140, 70, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_70_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (141, 71, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_71_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (142, 71, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_71_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (143, 72, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_72_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (144, 72, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_72_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (145, 73, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_73_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (146, 73, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_73_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (147, 74, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_74_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (148, 74, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_74_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (149, 75, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_75_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (150, 75, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_75_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (151, 76, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_76_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (152, 76, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_76_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (153, 77, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_77_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (154, 77, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_77_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (155, 78, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_78_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (156, 78, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_78_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (157, 79, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_79_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (158, 79, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_79_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (159, 80, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_80_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (160, 80, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_80_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (161, 81, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_81_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (162, 81, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_81_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (163, 82, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_82_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (164, 82, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_82_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (165, 83, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_83_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (166, 83, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_83_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (167, 84, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_84_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (168, 84, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_84_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (169, 85, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_85_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (170, 85, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_85_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (171, 86, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_86_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (172, 86, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_86_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (173, 87, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_87_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (174, 87, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_87_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (175, 88, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_88_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (176, 88, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_88_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (177, 89, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_89_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (178, 89, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_89_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (179, 90, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_90_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (180, 90, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_90_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (181, 91, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_91_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (182, 91, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_91_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (183, 92, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_92_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (184, 92, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_92_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (185, 93, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_93_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (186, 93, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_93_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (187, 94, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_94_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (188, 94, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_94_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (189, 95, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_95_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (190, 95, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_95_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (191, 96, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_96_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (192, 96, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_96_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (193, 97, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_97_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (194, 97, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_97_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (195, 98, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_98_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (196, 98, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_98_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (197, 99, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_99_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (198, 99, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_99_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (199, 100, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_100_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (200, 100, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_100_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (201, 101, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_101_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (202, 101, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_101_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (203, 102, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_102_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (204, 102, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_102_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (205, 103, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_103_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (206, 103, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_103_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (207, 104, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_104_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (208, 104, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_104_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (209, 105, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_105_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (210, 105, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_105_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (211, 106, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_106_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (212, 106, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_106_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (213, 107, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_107_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (214, 107, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_107_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (215, 108, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_108_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (216, 108, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_108_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (217, 109, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_109_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (218, 109, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_109_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (219, 110, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_110_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (220, 110, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_110_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (221, 111, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_111_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (222, 111, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_111_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (223, 112, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_112_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (224, 112, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_112_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (225, 113, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_113_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (226, 113, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_113_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (227, 114, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_114_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (228, 114, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_114_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (229, 115, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_115_3.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (230, 115, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_115_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (231, 116, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_116_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (232, 116, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Погода супер', N'/photos/trip_116_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (233, 117, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_117_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (234, 117, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_117_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (235, 118, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_118_0.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (236, 118, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_118_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (237, 119, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Вкусно поели', N'/photos/trip_119_1.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (238, 119, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! Красивые виды', N'/photos/trip_119_2.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (239, 120, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_120_4.jpg')
GO
INSERT [dbo].[travel_notes] ([id], [trip_id], [note_date], [content], [photo_path]) VALUES (240, 120, CAST(N'2026-05-08T15:15:10.100' AS DateTime), N'Отличная поездка! ', N'/photos/trip_120_3.jpg')
GO
SET IDENTITY_INSERT [dbo].[travel_notes] OFF
GO
SET IDENTITY_INSERT [dbo].[trips] ON 
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (1, 16, N'Путешествие в Дубай #1', CAST(N'2023-11-06' AS Date), CAST(N'2023-02-11' AS Date), CAST(5284.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (2, 18, N'Путешествие в Москву #2', CAST(N'2023-02-24' AS Date), CAST(N'2024-02-16' AS Date), CAST(4027.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (3, 17, N'Путешествие в Токио #3', CAST(N'2023-11-21' AS Date), CAST(N'2024-11-13' AS Date), CAST(2168.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (4, 5, N'Путешествие в Барселону #4', CAST(N'2023-12-12' AS Date), CAST(N'2024-11-08' AS Date), CAST(4600.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (5, 6, N'Путешествие в  #5', CAST(N'2024-05-18' AS Date), CAST(N'2024-10-02' AS Date), CAST(3006.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (6, 18, N'Путешествие в Париж #6', CAST(N'2023-10-22' AS Date), CAST(N'2024-08-05' AS Date), CAST(644.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (7, 6, N'Путешествие в  #7', CAST(N'2023-02-28' AS Date), CAST(N'2024-01-11' AS Date), CAST(5393.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (8, 9, N'Путешествие в  #8', CAST(N'2024-06-26' AS Date), CAST(N'2024-03-09' AS Date), CAST(2858.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (9, 4, N'Путешествие в Париж #9', CAST(N'2023-09-13' AS Date), CAST(N'2023-02-01' AS Date), CAST(2373.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (10, 16, N'Путешествие в Лондон #10', CAST(N'2024-03-30' AS Date), CAST(N'2024-03-02' AS Date), CAST(2244.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (11, 10, N'Путешествие в Берлин #11', CAST(N'2023-05-17' AS Date), CAST(N'2023-10-30' AS Date), CAST(4223.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (12, 2, N'Путешествие в Дубай #12', CAST(N'2024-11-27' AS Date), CAST(N'2024-09-09' AS Date), CAST(851.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (13, 2, N'Путешествие в  #13', CAST(N'2024-01-16' AS Date), CAST(N'2024-07-04' AS Date), CAST(1092.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (14, 12, N'Путешествие в  #14', CAST(N'2023-02-11' AS Date), CAST(N'2023-11-29' AS Date), CAST(542.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (15, 18, N'Путешествие в Барселону #15', CAST(N'2023-06-29' AS Date), CAST(N'2024-05-17' AS Date), CAST(4466.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (16, 1, N'Путешествие в Берлин #16', CAST(N'2024-04-08' AS Date), CAST(N'2024-05-01' AS Date), CAST(705.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (17, 12, N'Путешествие в Дубай #17', CAST(N'2024-12-14' AS Date), CAST(N'2024-07-28' AS Date), CAST(4425.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (18, 17, N'Путешествие в Пекин #18', CAST(N'2023-05-31' AS Date), CAST(N'2024-05-07' AS Date), CAST(3369.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (19, 2, N'Путешествие в Лондон #19', CAST(N'2023-09-29' AS Date), CAST(N'2024-08-18' AS Date), CAST(4032.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (20, 5, N'Путешествие в Нью-Йорк #20', CAST(N'2023-08-14' AS Date), CAST(N'2023-11-02' AS Date), CAST(3742.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (21, 8, N'Путешествие в Лондон #21', CAST(N'2023-06-09' AS Date), CAST(N'2024-10-31' AS Date), CAST(3665.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (22, 7, N'Путешествие в  #22', CAST(N'2023-07-11' AS Date), CAST(N'2024-07-19' AS Date), CAST(2468.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (23, 5, N'Путешествие в Рим #23', CAST(N'2024-05-12' AS Date), CAST(N'2023-05-08' AS Date), CAST(4682.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (24, 11, N'Путешествие в  #24', CAST(N'2024-02-08' AS Date), CAST(N'2024-02-13' AS Date), CAST(4757.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (25, 5, N'Путешествие в Париж #25', CAST(N'2023-02-25' AS Date), CAST(N'2023-12-30' AS Date), CAST(5488.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (26, 12, N'Путешествие в Берлин #26', CAST(N'2024-05-18' AS Date), CAST(N'2023-12-13' AS Date), CAST(2099.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (27, 4, N'Путешествие в Париж #27', CAST(N'2023-03-29' AS Date), CAST(N'2025-01-04' AS Date), CAST(3526.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (28, 6, N'Путешествие в  #28', CAST(N'2024-02-24' AS Date), CAST(N'2023-09-11' AS Date), CAST(1460.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (29, 18, N'Путешествие в  #29', CAST(N'2023-09-22' AS Date), CAST(N'2024-03-15' AS Date), CAST(3364.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (30, 7, N'Путешествие в Лондон #30', CAST(N'2024-09-19' AS Date), CAST(N'2024-10-26' AS Date), CAST(661.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (31, 3, N'Путешествие в  #31', CAST(N'2023-02-07' AS Date), CAST(N'2024-11-01' AS Date), CAST(3448.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (32, 20, N'Путешествие в Рим #32', CAST(N'2024-11-14' AS Date), CAST(N'2024-07-03' AS Date), CAST(1807.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (33, 20, N'Путешествие в Париж #33', CAST(N'2023-08-04' AS Date), CAST(N'2023-11-20' AS Date), CAST(4462.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (34, 20, N'Путешествие в Барселону #34', CAST(N'2023-08-27' AS Date), CAST(N'2023-02-02' AS Date), CAST(4587.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (35, 20, N'Путешествие в Рим #35', CAST(N'2024-07-02' AS Date), CAST(N'2023-11-16' AS Date), CAST(4123.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (36, 4, N'Путешествие в  #36', CAST(N'2024-11-05' AS Date), CAST(N'2024-11-30' AS Date), CAST(4922.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (37, 11, N'Путешествие в Париж #37', CAST(N'2024-01-03' AS Date), CAST(N'2023-12-14' AS Date), CAST(3701.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (38, 19, N'Путешествие в Нью-Йорк #38', CAST(N'2024-10-27' AS Date), CAST(N'2024-03-26' AS Date), CAST(3838.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (39, 7, N'Путешествие в  #39', CAST(N'2024-09-24' AS Date), CAST(N'2024-06-17' AS Date), CAST(660.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (40, 6, N'Путешествие в  #40', CAST(N'2023-10-15' AS Date), CAST(N'2023-04-26' AS Date), CAST(2658.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (41, 18, N'Путешествие в  #41', CAST(N'2024-11-22' AS Date), CAST(N'2023-03-30' AS Date), CAST(924.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (42, 8, N'Путешествие в Дубай #42', CAST(N'2023-08-09' AS Date), CAST(N'2023-10-30' AS Date), CAST(797.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (43, 14, N'Путешествие в Пекин #43', CAST(N'2024-12-17' AS Date), CAST(N'2024-02-08' AS Date), CAST(5059.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (44, 4, N'Путешествие в  #44', CAST(N'2023-11-15' AS Date), CAST(N'2023-12-26' AS Date), CAST(4593.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (45, 16, N'Путешествие в Нью-Йорк #45', CAST(N'2024-07-18' AS Date), CAST(N'2024-12-27' AS Date), CAST(2417.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (46, 14, N'Путешествие в  #46', CAST(N'2023-12-10' AS Date), CAST(N'2023-04-01' AS Date), CAST(4697.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (47, 6, N'Путешествие в Лондон #47', CAST(N'2024-07-02' AS Date), CAST(N'2023-04-09' AS Date), CAST(5268.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (48, 3, N'Путешествие в Нью-Йорк #48', CAST(N'2023-02-26' AS Date), CAST(N'2024-04-22' AS Date), CAST(4453.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (49, 7, N'Путешествие в Лондон #49', CAST(N'2024-09-11' AS Date), CAST(N'2024-08-16' AS Date), CAST(2687.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (50, 16, N'Путешествие в Берлин #50', CAST(N'2023-10-19' AS Date), CAST(N'2024-02-01' AS Date), CAST(3551.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (51, 18, N'Путешествие в Токио #51', CAST(N'2024-06-07' AS Date), CAST(N'2024-12-17' AS Date), CAST(643.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (52, 14, N'Путешествие в  #52', CAST(N'2023-06-12' AS Date), CAST(N'2024-03-24' AS Date), CAST(3767.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (53, 1, N'Путешествие в  #53', CAST(N'2024-04-16' AS Date), CAST(N'2024-02-24' AS Date), CAST(3072.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (54, 4, N'Путешествие в  #54', CAST(N'2024-07-24' AS Date), CAST(N'2024-06-17' AS Date), CAST(3324.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (55, 5, N'Путешествие в Нью-Йорк #55', CAST(N'2024-01-21' AS Date), CAST(N'2023-02-17' AS Date), CAST(2688.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (56, 7, N'Путешествие в Пекин #56', CAST(N'2024-07-19' AS Date), CAST(N'2023-05-13' AS Date), CAST(1669.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (57, 1, N'Путешествие в  #57', CAST(N'2023-03-20' AS Date), CAST(N'2023-11-22' AS Date), CAST(5355.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (58, 2, N'Путешествие в  #58', CAST(N'2024-09-07' AS Date), CAST(N'2024-01-15' AS Date), CAST(1033.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (59, 18, N'Путешествие в Нью-Йорк #59', CAST(N'2024-06-21' AS Date), CAST(N'2023-07-29' AS Date), CAST(3329.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (60, 20, N'Путешествие в Берлин #60', CAST(N'2023-12-09' AS Date), CAST(N'2023-02-21' AS Date), CAST(2494.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (61, 17, N'Путешествие в Дубай #61', CAST(N'2024-12-26' AS Date), CAST(N'2023-11-07' AS Date), CAST(727.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (62, 13, N'Путешествие в Берлин #62', CAST(N'2024-07-20' AS Date), CAST(N'2024-12-25' AS Date), CAST(2731.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (63, 18, N'Путешествие в Париж #63', CAST(N'2024-07-25' AS Date), CAST(N'2023-09-01' AS Date), CAST(3944.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (64, 18, N'Путешествие в  #64', CAST(N'2024-11-01' AS Date), CAST(N'2024-05-26' AS Date), CAST(667.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (65, 7, N'Путешествие в Рим #65', CAST(N'2024-01-09' AS Date), CAST(N'2024-05-11' AS Date), CAST(2471.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (66, 5, N'Путешествие в Париж #66', CAST(N'2024-10-12' AS Date), CAST(N'2024-02-10' AS Date), CAST(1536.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (67, 20, N'Путешествие в Дубай #67', CAST(N'2024-06-20' AS Date), CAST(N'2024-12-09' AS Date), CAST(4787.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (68, 6, N'Путешествие в  #68', CAST(N'2023-05-12' AS Date), CAST(N'2024-05-18' AS Date), CAST(5144.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (69, 1, N'Путешествие в  #69', CAST(N'2024-12-10' AS Date), CAST(N'2024-09-08' AS Date), CAST(2570.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (70, 18, N'Путешествие в  #70', CAST(N'2023-02-19' AS Date), CAST(N'2024-10-24' AS Date), CAST(5192.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (71, 2, N'Путешествие в Берлин #71', CAST(N'2023-05-07' AS Date), CAST(N'2024-09-21' AS Date), CAST(5027.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (72, 15, N'Путешествие в  #72', CAST(N'2023-01-31' AS Date), CAST(N'2023-12-21' AS Date), CAST(919.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (73, 8, N'Путешествие в Пекин #73', CAST(N'2024-06-02' AS Date), CAST(N'2024-05-28' AS Date), CAST(3766.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (74, 5, N'Путешествие в  #74', CAST(N'2024-10-21' AS Date), CAST(N'2024-02-22' AS Date), CAST(765.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (75, 1, N'Путешествие в  #75', CAST(N'2023-08-28' AS Date), CAST(N'2024-11-28' AS Date), CAST(1511.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (76, 12, N'Путешествие в Токио #76', CAST(N'2023-11-25' AS Date), CAST(N'2024-06-21' AS Date), CAST(5122.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (77, 8, N'Путешествие в  #77', CAST(N'2023-08-22' AS Date), CAST(N'2023-04-11' AS Date), CAST(5161.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (78, 13, N'Путешествие в Лондон #78', CAST(N'2024-12-08' AS Date), CAST(N'2024-01-03' AS Date), CAST(4927.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (79, 16, N'Путешествие в  #79', CAST(N'2024-01-07' AS Date), CAST(N'2023-01-16' AS Date), CAST(1822.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (80, 15, N'Путешествие в  #80', CAST(N'2023-06-04' AS Date), CAST(N'2024-08-13' AS Date), CAST(4488.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (81, 13, N'Путешествие в Нью-Йорк #81', CAST(N'2024-07-02' AS Date), CAST(N'2024-05-20' AS Date), CAST(1103.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (82, 9, N'Путешествие в  #82', CAST(N'2024-02-10' AS Date), CAST(N'2023-02-08' AS Date), CAST(3215.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (83, 4, N'Путешествие в Берлин #83', CAST(N'2023-06-04' AS Date), CAST(N'2024-02-28' AS Date), CAST(4454.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (84, 18, N'Путешествие в Рим #84', CAST(N'2023-11-22' AS Date), CAST(N'2024-12-11' AS Date), CAST(1230.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (85, 15, N'Путешествие в  #85', CAST(N'2024-02-26' AS Date), CAST(N'2024-07-20' AS Date), CAST(2056.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (86, 14, N'Путешествие в Дубай #86', CAST(N'2023-05-21' AS Date), CAST(N'2023-12-06' AS Date), CAST(5321.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (87, 20, N'Путешествие в Лондон #87', CAST(N'2023-10-22' AS Date), CAST(N'2023-02-16' AS Date), CAST(2743.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (88, 3, N'Путешествие в  #88', CAST(N'2023-06-26' AS Date), CAST(N'2023-12-17' AS Date), CAST(4397.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (89, 7, N'Путешествие в  #89', CAST(N'2024-04-22' AS Date), CAST(N'2024-10-02' AS Date), CAST(4433.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (90, 11, N'Путешествие в  #90', CAST(N'2023-07-04' AS Date), CAST(N'2024-09-02' AS Date), CAST(1635.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (91, 14, N'Путешествие в  #91', CAST(N'2023-09-25' AS Date), CAST(N'2024-06-19' AS Date), CAST(2774.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (92, 19, N'Путешествие в  #92', CAST(N'2024-08-20' AS Date), CAST(N'2024-12-15' AS Date), CAST(870.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (93, 5, N'Путешествие в Лондон #93', CAST(N'2024-03-06' AS Date), CAST(N'2023-05-08' AS Date), CAST(4525.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (94, 7, N'Путешествие в Москву #94', CAST(N'2023-08-06' AS Date), CAST(N'2024-10-02' AS Date), CAST(2324.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (95, 18, N'Путешествие в Нью-Йорк #95', CAST(N'2024-03-11' AS Date), CAST(N'2023-09-26' AS Date), CAST(3551.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (96, 3, N'Путешествие в Берлин #96', CAST(N'2024-07-07' AS Date), CAST(N'2024-01-21' AS Date), CAST(1563.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (97, 19, N'Путешествие в Лондон #97', CAST(N'2024-10-13' AS Date), CAST(N'2024-12-29' AS Date), CAST(1801.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (98, 7, N'Путешествие в Пекин #98', CAST(N'2023-11-17' AS Date), CAST(N'2023-07-11' AS Date), CAST(2704.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (99, 8, N'Путешествие в  #99', CAST(N'2023-04-12' AS Date), CAST(N'2023-08-18' AS Date), CAST(2446.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (100, 5, N'Путешествие в  #100', CAST(N'2023-02-24' AS Date), CAST(N'2024-06-15' AS Date), CAST(2566.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (101, 16, N'Путешествие в Дубай #101', CAST(N'2024-02-08' AS Date), CAST(N'2024-05-03' AS Date), CAST(3508.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (102, 20, N'Путешествие в Нью-Йорк #102', CAST(N'2023-01-13' AS Date), CAST(N'2024-01-12' AS Date), CAST(1570.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (103, 19, N'Путешествие в  #103', CAST(N'2023-08-25' AS Date), CAST(N'2023-01-13' AS Date), CAST(2388.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (104, 15, N'Путешествие в  #104', CAST(N'2023-03-16' AS Date), CAST(N'2023-10-15' AS Date), CAST(1034.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (105, 10, N'Путешествие в Берлин #105', CAST(N'2024-08-16' AS Date), CAST(N'2023-04-19' AS Date), CAST(3817.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (106, 1, N'Путешествие в  #106', CAST(N'2023-06-07' AS Date), CAST(N'2024-02-02' AS Date), CAST(4602.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (107, 2, N'Путешествие в Лондон #107', CAST(N'2024-08-13' AS Date), CAST(N'2023-01-18' AS Date), CAST(5051.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (108, 13, N'Путешествие в Париж #108', CAST(N'2024-07-12' AS Date), CAST(N'2024-07-21' AS Date), CAST(4856.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (109, 14, N'Путешествие в  #109', CAST(N'2023-05-07' AS Date), CAST(N'2024-05-24' AS Date), CAST(3513.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (110, 10, N'Путешествие в  #110', CAST(N'2023-01-08' AS Date), CAST(N'2024-05-04' AS Date), CAST(5467.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (111, 11, N'Путешествие в  #111', CAST(N'2023-03-01' AS Date), CAST(N'2023-07-26' AS Date), CAST(5466.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (112, 14, N'Путешествие в Рим #112', CAST(N'2024-11-21' AS Date), CAST(N'2023-09-26' AS Date), CAST(3481.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (113, 9, N'Путешествие в Дубай #113', CAST(N'2023-05-18' AS Date), CAST(N'2023-12-14' AS Date), CAST(1763.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (114, 19, N'Путешествие в Париж #114', CAST(N'2023-07-10' AS Date), CAST(N'2023-11-09' AS Date), CAST(5315.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (115, 18, N'Путешествие в Дубай #115', CAST(N'2024-03-16' AS Date), CAST(N'2024-09-05' AS Date), CAST(4708.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (116, 19, N'Путешествие в  #116', CAST(N'2023-07-21' AS Date), CAST(N'2023-03-03' AS Date), CAST(3952.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (117, 2, N'Путешествие в Барселону #117', CAST(N'2024-01-21' AS Date), CAST(N'2023-03-21' AS Date), CAST(1711.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (118, 12, N'Путешествие в Лондон #118', CAST(N'2023-07-21' AS Date), CAST(N'2023-01-19' AS Date), CAST(1367.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (119, 10, N'Путешествие в Нью-Йорк #119', CAST(N'2023-11-29' AS Date), CAST(N'2024-12-21' AS Date), CAST(3470.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[trips] ([id], [user_id], [name], [start_date], [end_date], [budget]) VALUES (120, 1, N'Путешествие в  #120', CAST(N'2023-04-26' AS Date), CAST(N'2023-07-25' AS Date), CAST(5204.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[trips] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (1, N'user1', N'user1@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (2, N'user2', N'user2@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (3, N'user3', N'user3@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (4, N'user4', N'user4@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (5, N'user5', N'user5@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (6, N'user6', N'user6@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (7, N'user7', N'user7@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (8, N'user8', N'user8@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (9, N'user9', N'user9@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (10, N'user10', N'user10@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (11, N'user11', N'user11@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (12, N'user12', N'user12@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (13, N'user13', N'user13@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (14, N'user14', N'user14@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (15, N'user15', N'user15@test.com', 1, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (16, N'user16', N'user16@test.com', 2, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (17, N'user17', N'user17@test.com', 2, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (18, N'user18', N'user18@test.com', 2, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (19, N'admin1', N'admin1@test.com', 3, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
INSERT [dbo].[users] ([id], [username], [email], [role_id], [created_at]) VALUES (20, N'admin2', N'admin2@test.com', 3, CAST(N'2026-05-08T15:15:09.983' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__booking___72E12F1BDD69F9AE]    Script Date: 08.05.2026 15:17:13 ******/
ALTER TABLE [dbo].[booking_statuses] ADD UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__booking___72E12F1B234AEC15]    Script Date: 08.05.2026 15:17:13 ******/
ALTER TABLE [dbo].[booking_types] ADD UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__expense___72E12F1B38E9D8C1]    Script Date: 08.05.2026 15:17:13 ******/
ALTER TABLE [dbo].[expense_categories] ADD UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__roles__72E12F1BC834B9F8]    Script Date: 08.05.2026 15:17:13 ******/
ALTER TABLE [dbo].[roles] ADD UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__AB6E6164809B0402]    Script Date: 08.05.2026 15:17:13 ******/
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__F3DBC572539E982B]    Script Date: 08.05.2026 15:17:13 ******/
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[travel_notes] ADD  DEFAULT (getdate()) FOR [note_date]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [role_id]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([booking_type_id])
REFERENCES [dbo].[booking_types] ([id])
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([status_id])
REFERENCES [dbo].[booking_statuses] ([id])
GO
ALTER TABLE [dbo].[bookings]  WITH CHECK ADD FOREIGN KEY([trip_id])
REFERENCES [dbo].[trips] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[documents]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[expenses]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [dbo].[expense_categories] ([id])
GO
ALTER TABLE [dbo].[expenses]  WITH CHECK ADD FOREIGN KEY([trip_id])
REFERENCES [dbo].[trips] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[route_items]  WITH CHECK ADD FOREIGN KEY([attraction_id])
REFERENCES [dbo].[attractions] ([id])
GO
ALTER TABLE [dbo].[route_items]  WITH CHECK ADD FOREIGN KEY([route_id])
REFERENCES [dbo].[routes] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[routes]  WITH CHECK ADD FOREIGN KEY([trip_id])
REFERENCES [dbo].[trips] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[travel_notes]  WITH CHECK ADD FOREIGN KEY([trip_id])
REFERENCES [dbo].[trips] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[trips]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([id])
GO
/****** Object:  StoredProcedure [dbo].[sp_add_expense]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =====================================================
-- 6. Создание хранимых процедур для разных ролей
-- =====================================================

-- Процедура для пользователя: добавить расход
CREATE PROCEDURE [dbo].[sp_add_expense]
    @trip_id INT,
    @user_id INT,
    @category_id INT,
    @amount DECIMAL(10,2),
    @expense_date DATE,
    @description NVARCHAR(MAX)
AS
BEGIN
    -- Проверка, что поездка принадлежит пользователю
    IF EXISTS (SELECT 1 FROM trips WHERE id = @trip_id AND user_id = @user_id)
    BEGIN
        INSERT INTO expenses (trip_id, category_id, amount, expense_date, description)
        VALUES (@trip_id, @category_id, @amount, @expense_date, @description);
        SELECT 'Expense added successfully' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Access denied: Trip does not belong to user' AS Message;
    END
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_admin_delete_user]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Процедура для администратора: удалить пользователя
CREATE PROCEDURE [dbo].[sp_admin_delete_user]
    @user_id INT
AS
BEGIN
    -- Проверка, что пользователь не админ (защита)
    IF EXISTS (SELECT 1 FROM users WHERE id = @user_id AND role_id = 3)
    BEGIN
        SELECT 'Cannot delete admin user' AS Message;
        RETURN;
    END
    
    DELETE FROM users WHERE id = @user_id;
    SELECT 'User deleted successfully' AS Message;
END;

GO
/****** Object:  StoredProcedure [dbo].[sp_manager_report]    Script Date: 08.05.2026 15:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Процедура для менеджера: отчет по пользователю
CREATE PROCEDURE [dbo].[sp_manager_report]
    @user_id INT = NULL
AS
BEGIN
    IF @user_id IS NULL
    BEGIN
        SELECT * FROM v_manager_stats;
    END
    ELSE
    BEGIN
        SELECT * FROM v_manager_stats WHERE user_id = @user_id;
    END
END;

GO
USE [master]
GO
ALTER DATABASE [travel_planner] SET  READ_WRITE 
GO
