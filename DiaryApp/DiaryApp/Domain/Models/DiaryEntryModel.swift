//
//  DiaryEntryModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import Foundation

/// Domain model describing a diary entry used across the app.
struct DiaryEntryModel: Equatable {
    let id: UUID
    let title: String
    let text: String
    let createdAt: Date
    let updatedAt: Date
    let isFavorite: Bool
    let mood: MoodType?
    let dayKey: String
}
