//
//  CalendarViewModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 21.07.2026.
//

import Foundation

final class CalendarViewModel {
    
    private let repository: DiaryRepositoryProtocol
    private(set) var visibleDates: Set<String> = []
    
    var onDataUpdated: (() -> Void)?
    
    init(repository:DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchDatesWithEntries() {
        repository.fetchAll { [weak self] result in
            switch result {
            case .success(let entries):
                self?.visibleDates = Set(entries.map { $0.dayKey })
            case .failure:
                self?.visibleDates = []
            }
            self?.onDataUpdated?()
        }
    }
}
