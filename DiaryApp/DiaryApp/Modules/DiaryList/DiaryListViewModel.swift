//
//  DiaryListViewModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import Foundation

final class DiaryListViewModel {
    
    private let repository: DiaryRepositoryProtocol
    private(set) var entries: [DiaryEntryModel] = []
    
    var onDataUpdated: (() -> Void)?
    
    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchEntries() {
        repository.fetchAll { [weak self] result in
            switch result {
            case .success(let models):
                self?.entries = models
            case .failure(let error):
                print("Failed to fetch entries: \(error)")
                self?.entries = []
            }
            self?.onDataUpdated?()
        }
    }
}
