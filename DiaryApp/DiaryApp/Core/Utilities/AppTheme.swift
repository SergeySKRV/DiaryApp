//
//  AppTheme.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 27.07.2026.
//

import UIKit

enum AppTheme: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
    
    var localizedName: String {
        switch self {
        case .system: return L10n.themeSystem
        case .light: return L10n.themeLight
        case .dark: return L10n.themeDark
        }
    }
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}
