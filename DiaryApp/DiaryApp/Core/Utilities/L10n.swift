//
//  L10n.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import Foundation

enum L10n {
    // MARK: - Tabs
    static let tabList = NSLocalizedString("tab.list", comment: "Tab Bar item for list")
    static let tabCalendar = NSLocalizedString("tab.calendar", comment: "Tab bar item for calendar")
    static let tabSettings = NSLocalizedString("tab.settings", comment: "Tab bar item for settings")
    
    // MARK: - Diary List
    static let diaryTitle = NSLocalizedString("diary.title", comment: "Title for the diary list screen")
    static let searchPlaceholder = NSLocalizedString("diary.search.placeholder", comment: "Search bar placeholder")
    static let emptyNoEntries = NSLocalizedString("diary.empty.noEntries", comment: "Empty state when no entries exist")
    static let emptyNoSearchResults = NSLocalizedString("diary.empty.noSearchResults", comment: "Empty state for search")
    static let emptyNoFavorites = NSLocalizedString("diary.empty.noFavorites", comment: "Empty state for favorites filter")
    static let untitled = NSLocalizedString("diary.untitled", comment: "Placeholder title if entry has no title")
    
    // MARK: - Diary Details
    static let detailsTitlePlaceholder = NSLocalizedString("details.title.placeholder", comment: "Placeholder for title text field")
    static let detailsEditTitle = NSLocalizedString("details.edit.title", comment: "Navigation title for edit mode")
    static let detailsCreateTitle = NSLocalizedString("details.create.title", comment: "Navigation title for create mode")
    static let detailsErrorTitle = NSLocalizedString("details.error.title", comment: "Error alert title")
    static let detailsEmptyError = NSLocalizedString("details.empty.error", comment: "Error message when trying to save empty entry")
    static let okAction = NSLocalizedString("action.ok", comment: "OK button action")
    
    // MARK: - Calendar
    static let calendarTitle = NSLocalizedString("calendar.title", comment: "Title for the calendar screen")
    
    // MARK: - Settings
    static let settingsTitle = NSLocalizedString("settings.title", comment: "Title for the settings screen")
    static let settingsReminders = NSLocalizedString("settings.reminders", comment: "Settings switch label")
    static let settingsNotificationsOffTitle = NSLocalizedString("settings.notifications.off.title", comment: "Alert title")
    static let settingsNotificationsOffMessage = NSLocalizedString("settings.notifications.off.message", comment: "Alert message")
    
    // MARK: - Notifications
    static let notificationTitle = NSLocalizedString("notification.title", comment: "Local notification title")
    static let notificationBody = NSLocalizedString("notification.body", comment: "Local notification body")
    
    // MARK: - Moods
    static let moodHappy = NSLocalizedString("mood.happy", comment: "Happy mood")
    static let moodCalm = NSLocalizedString("mood.calm", comment: "Calm mood")
    static let moodNeutral = NSLocalizedString("mood.neutral", comment: "Neutral mood")
    static let moodSad = NSLocalizedString("mood.sad", comment: "Sad mood")
    static let moodAngry = NSLocalizedString("mood.angry", comment: "Angry mood")
    static let moodNone = NSLocalizedString("mood.none", comment: "No mood selected")
    
    // MARK: - UI Polish
    static let detailsBodyPlaceholder = NSLocalizedString("details.body.placeholder", comment: "Placeholder for body text view")
    static let accessibilityEntryLabel = NSLocalizedString("accessibility.entry.label", comment: "VoiceOver label for diary entry")
    static let accessibilityEntryHint = NSLocalizedString("accessibility.entry.hint", comment: "VoiceOver hint for diary entry")
}

