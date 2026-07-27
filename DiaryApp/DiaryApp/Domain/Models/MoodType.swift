//
//  MoodType.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import Foundation

/// Represents the user's mood attached to a diary entry.
enum MoodType: String, CaseIterable {
    case happy
    case calm
    case neutral
    case sad
    case angry
    
    var localizedName: String {
        switch self {
        case .happy: return L10n.moodHappy
        case .calm: return L10n.moodCalm
        case .neutral: return L10n.moodNeutral
        case .sad: return L10n.moodSad
        case .angry: return L10n.moodAngry
        }
    }
    
            var emoji: String {
                switch self {
                case .happy: return "😄"
                case .calm: return "😌"
                case .neutral: return "😑"
                case .sad: return "😔"
                case .angry: return "😡"
                }
            }
        }
