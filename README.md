# DiaryApp
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-28 at 22 47 13" src="https://github.com/user-attachments/assets/a61b6c21-8530-42a3-b540-07501f150cbe" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-28 at 22 47 51" src="https://github.com/user-attachments/assets/2dc86930-73dc-4a96-9bb7-7255927c5500" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-28 at 22 47 37" src="https://github.com/user-attachments/assets/d19ccbcc-eb22-4072-960a-127a7d313935" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-27 at 21 14 33" src="https://github.com/user-attachments/assets/066ec0d5-a561-428e-a25d-efa5eecbca33" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-28 at 00 09 56" src="https://github.com/user-attachments/assets/f8d5996b-0e76-475a-8121-26219b41dba4" />
<img width="117" height="253" alt="Simulator Screenshot - iPhone13 - 2026-07-28 at 21 37 32" src="https://github.com/user-attachments/assets/4e958e16-4870-4fb3-acb7-105f9350c43b" />

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
- 📈 График настроения (отслеживание эмоций с помощью SwiftUI Charts)
  
## Технологии
- **Язык:** Swift
- **UI:** UIKit + Auto Layout (программная верстка) + SwiftUI (для графиков)
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
├── Core/                # Расширения, утилиты (L10n, Date+, HapticManager, DesignSystem)
│   ├── DesignSystem/    # Переиспользуемые UI-компоненты (EmptyStateView)
│   ├── Extensions/      # Расширения (Date+Extensions)
│   └── Utilities/       # Утилиты (L10n, HapticManager, AppTheme, DiaryRouter)
├── Resources/           # Assets, Localizable.strings (Ru/En)
├── Services/            # CoreDataStack, NotificationService
│   ├── Notifications/   # Логика локальных уведомлений
│   └── Persistence/     # Настройка Core Data стэка
├── Data/                # Слой работы с данными
│   └── Repositories/    # Репозитории и протоколы доступа к БД
├── Domain/              # Доменные модели (DiaryEntryModel, MoodType, MoodDataPoint)
│   └── Models/          
├── Modules/             # Экраны приложения (UIKit + SwiftUI)
│   ├── Calendar/        # Экран календаря (UICalendarView)
│   ├── DiaryDetails/    # Создание и редактирование записи
│   ├── DiaryList/       # Список записей
│   │   └── Views/       # Кастомные ячейки таблицы
│   ├── MoodChart/       # График настроения (SwiftUI Charts)
│   │   └── Views/       # SwiftUI представления графика
│   └── Settings/        # Настройки уведомлений и темы
└── DiaryAppTests/       # Unit-тесты (Repository, ViewModel, Mocks)
