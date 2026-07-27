# DiaryApp
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 22 03 55" src="https://github.com/user-attachments/assets/30e57aa0-1d23-4449-8c78-a61d9f7d87e2" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 23 43 25" src="https://github.com/user-attachments/assets/b0c0ab9c-604a-437c-8981-69dfc7bac6fe" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 21 14 33" src="https://github.com/user-attachments/assets/066ec0d5-a561-428e-a25d-efa5eecbca33" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-28 at 00 09 56" src="https://github.com/user-attachments/assets/f8d5996b-0e76-475a-8121-26219b41dba4" />

DiaryApp — это учебно-портфельное iPhone-приложение дневника на UIKit, в котором можно создавать, редактировать, искать и просматривать личные записи по датам.

## Возможности
- 📝 Создание, редактирование и удаление записей
- 📅 Просмотр записей списком и через встроенный календарь (`UICalendarView`)
- 🔍 Поиск по заголовку и тексту (с debounce 300мс)
- ⭐ Избранные записи (свайп влево для добавления в избранное)
- 🗑️ Удаление записей (через свайп или контекстное меню по долгому тапу)
- 🎭 Выбор настроения для каждой записи + отображение эмодзи в списке
- 🔔 Локальные напоминания о ведении дневника (`UNUserNotificationCenter`)
- 🌙 Ручное переключение темы (Светлая / Темная / Авто)
- 📳 Тактильная отдача (Haptic Feedback) при действиях
- ⬇️ Pull-to-Refresh (потянуть вниз для обновления) на главном экране
- 🌍 Локализация интерфейса (Русский / Английский)
- ♿ Поддержка VoiceOver (Accessibility)

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
