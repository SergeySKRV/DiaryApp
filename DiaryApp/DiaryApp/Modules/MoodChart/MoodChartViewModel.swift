//
//  MoodChartViewModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 28.07.2026.
//

import Foundation

final class MoodChartViewModel {
    
    private let repository: DiaryRepositoryProtocol
    private(set) var dataPoints: [MoodDataPoint] = []
    
    var onDataUpdated: (() -> Void)?
    
    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMoodData() {
        repository.fetchAll { [weak self] result in
            switch result {
            case .success(let entries):
                self?.dataPoints = entries
                    .filter { $0.mood != nil }
                    .sorted { $0.createdAt < $1.createdAt }
                    .map { MoodDataPoint(date: $0.createdAt, score: $0.mood!.score) }
            case .failure:
                self?.dataPoints = []
            }
            self?.onDataUpdated?()
        }
    }
}
