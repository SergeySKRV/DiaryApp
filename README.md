# DiaryApp
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 22 03 55" src="https://github.com/user-attachments/assets/30e57aa0-1d23-4449-8c78-a61d9f7d87e2" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 21 14 33" src="https://github.com/user-attachments/assets/066ec0d5-a561-428e-a25d-efa5eecbca33" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 21 14 39" src="https://github.com/user-attachments/assets/f5158629-54e2-4c09-aa75-2ed9425a5290" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 21 14 50" src="https://github.com/user-attachments/assets/fb7c90c3-52b4-487f-b7c1-e1a2167dcc16" />

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
