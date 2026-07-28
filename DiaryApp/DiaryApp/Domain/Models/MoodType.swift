//
//  MoodType.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import Foundation

/// Represents the user's mood attached to a diary entry.
enum MoodType: String, CaseIterable {
    case calm
    case happy
    case sad
    case angry
    case neutral
    
    var localizedName: String {
        switch self {
        case .calm: return L10n.moodCalm
        case .happy: return L10n.moodHappy
        case .sad: return L10n.moodSad
        case .angry: return L10n.moodAngry
        case .neutral: return L10n.moodNeutral
        }
    }
    
            var emoji: String {
                switch self {
                case .calm: return "😌"
                case .happy: return "😄"
                case .sad: return "😔"
                case .angry: return "😡"
                case .neutral: return "😑"
                }
            }
    
    var score: Double {
        switch self {
        case .angry: return 0
        case .sad: return 1
        case .neutral: return 2
        case .calm: return 3
        case .happy: return 4
        }
    }
        }
