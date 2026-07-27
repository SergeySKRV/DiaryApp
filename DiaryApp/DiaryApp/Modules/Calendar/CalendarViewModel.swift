//
//  CalendarViewModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 21.07.2026.
//

import Foundation

final class CalendarViewModel {
    
    private let repository: DiaryRepositoryProtocol
    private(set) var visibleDates: Set<DateComponents> = []
    
    var onDataUpdated: (() -> Void)?
    
    init(repository:DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDatesWithEntries() {
        repository.fetchAll { [weak self] result in
            switch result {
            case .success(let entries):
                let calendar = Calendar.current
                self?.visibleDates = Set(entries.map { calendar.dateComponents([.year, .month, .day], from: $0.createdAt) })
            case .failure:
                self?.visibleDates = []
            }
            self?.onDataUpdated?()
        }
    }
}
