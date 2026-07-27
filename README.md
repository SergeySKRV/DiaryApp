# DiaryApp

DiaryApp — это учебно-портфельное iPhone-приложение дневника на UIKit, в котором можно создавать, редактировать, искать и просматривать личные записи по датам.

## Возможности
- 📝 Создание, редактирование и удаление записей
- 📅 Просмотр записей списком и через встроенный календарь (`UICalendarView`)
- 🔍 Поиск по заголовку и тексту (с debounce 300мс)
- ⭐ Избранные записи (свайп влево для добавления в избранное)
- 🎭 Выбор настроения для каждой записи
- 🔔 Локальные напоминания о ведении дневника (`UNUserNotificationCenter`)
- 🌍 Локализация интерфейса (Русский / Английский)
- ♿ Поддержка VoiceOver (Accessibility)
- 🌙 Полная поддержка темной темы (Dark Mode)

## Технологии
- **Язык:** Swift
- **UI:** UIKit + Auto Layout (программная верстка)
- **Хранение:** Core Data
- **Уведомления:** UserNotifications
- **Тесты:** XCTest

## Архитектура
Проект построен в модульном стиле (VIPER-lite / MVVM) с использованием паттерна Router для навигации. 
- **View / ViewController:** Отвечают за отображение данных и обработку действий пользователя.
- **ViewModel:** Содержит бизнес-логику экрана (фильтрация, поиск, debounce).
- **Router:** Инкапсулирует логику переходов между экранами.
- **Repository:** Изолирует слой работы с базой данных (Core Data).

## Структура проекта
```text
DiaryApp/
├── App/                 # AppDelegate, SceneDelegate, сборка TabBar
├── Core/                # Расширения, утилиты (L10n, Date+), DesignSystem
├── Resources/           # Assets, Localizable.strings (Ru/En)
├── Services/            # CoreDataStack, NotificationService
├── Data/                # Репозитории и протоколы доступа к данным
├── Domain/              # Доменные модели (DiaryEntryModel, MoodType)
├── Modules/             # Экраны (DiaryList, DiaryDetails, Calendar, Settings)
└── DiaryAppTests/       # Unit-тесты (Repository, ViewModel)
