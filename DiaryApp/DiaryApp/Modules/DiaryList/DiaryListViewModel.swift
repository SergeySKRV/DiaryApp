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
    
    private(set) var isSearching = false
    private var searchWorkItem: DispatchWorkItem?
    
    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchEntries() {
        isSearching = false
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
    
    func search(_ query: String) {
        searchWorkItem?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            fetchEntries()
            return
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.isSearching = true
            self?.repository.search(query: trimmedQuery) { result in
                switch result {
                case .success(let models):
                    self?.entries = models
                case .failure(let error):
                    print("Failed to search entries: \(error)")
                    self?.entries = []
                }
                self?.onDataUpdated?()
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
}
