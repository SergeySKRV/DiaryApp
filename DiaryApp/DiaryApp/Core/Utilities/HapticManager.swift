//
//  HapticManager.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 27.07.2026.
//

import UIKit

final class HapticManager {
    
    static let shared = HapticManager()
    private init() {}
    
    func impactLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func impactMedium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
