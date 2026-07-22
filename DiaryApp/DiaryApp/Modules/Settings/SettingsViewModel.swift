//
//  SettingsViewModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 22.07.2026.
//

import Foundation

final class SettingsViewModel {
    
    private let notificationService: NotificationService
    
    init(notificationService: NotificationService = .shared) {
        self.notificationService = notificationService
    }
    
    var isRemindersEnabled: Bool {
        UserDefaults.standard.bool(forKey: "isRemindersEnabled")
    }
    
    var reminderTime: Date {
        get {
            if let date =  UserDefaults.standard.object(forKey: "reminderTime") as? Date {
                return date
            } else {
                let components = DateComponents(hour: 20, minute: 0)
                return Calendar.current.date(from: components) ?? Date()
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reminderTime")
        }
    }
    
    func toggleReminders(enabled: Bool, completion: @escaping (Bool) -> Void) {
        if enabled {
            notificationService.requestAuthorization { [weak self] granted in
                guard let self else { return }
                
                if granted {
                    self.notificationService.scheduleDailyReminder(at: self.reminderTime)
                    UserDefaults.standard.set(true, forKey: "isRemindersEnabled")
                    completion(true)
                } else {
                    UserDefaults.standard.set(false, forKey: "isRemindersEnabled")
                    completion(false)
                }
            }
        } else {
            notificationService.cancelReminder()
            UserDefaults.standard.set(false, forKey: "isRemindersEnabled")
            completion(false)
        }
    }
    
    func updateReminderTime(_ time: Date) {
        reminderTime = time
        if isRemindersEnabled {
            notificationService.scheduleDailyReminder(at: time)
        }
    }
}
