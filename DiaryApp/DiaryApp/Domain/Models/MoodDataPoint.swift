//
//  MoodDataPoint.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 28.07.2026.
//

import Foundation

struct MoodDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let score: Double
}
