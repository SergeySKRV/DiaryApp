//
//  NotificationService.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 22.07.2026.
//

import Foundation
import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    private init() {}
    
    private let center = UNUserNotificationCenter.current()
    private let notificationId = "diary_daily_reminder"
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleDailyReminder(at time: Date) {
        cancelReminder()
        
        let content = UNMutableNotificationContent()
        content.title = "Дневник"
        content.body = "Время сделать запись в дневнике!"
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    func cancelReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [notificationId])
    }
}
