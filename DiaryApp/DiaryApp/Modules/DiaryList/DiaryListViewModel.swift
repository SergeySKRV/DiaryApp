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
    private let filterDayKey: String?
    
    private(set) var isShowingFavoritesOnly = false
    private(set) var moodFilter: MoodType?
    
    init(repository: DiaryRepositoryProtocol, dayKey: String? = nil) {
        self.repository = repository
        self.filterDayKey = dayKey
    }
    
    func fetchEntries() {
        isSearching = false
        
        if let dayKey = filterDayKey {
            repository.fetchEntries(for: dayKey) { [weak self] result in
                self?.processResult(result)
            }
        } else {
            repository.fetchAll { [weak self] result in
                self?.processResult(result)
            }
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
                self?.processResult(result)
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
    
    func deleteEntry(at index: Int) {
        let entry = entries[index]
        
        entries.remove(at: index)
        onDataUpdated?()
        
        repository.delete(id: entry.id) { result in
            switch result {
            case .success:
                break
            case .failure(_):
                print("Failed to delete entry: /(error")
            }
        }
    }
    
    // MARK: - Filters & Favorites
    
    func toggleFavoritesFilter() {
        isShowingFavoritesOnly.toggle()
        fetchEntries()
    }
    
    func toggleFavorite(id: UUID) {
        repository.toggleFavorite(id: id) { [weak self] _ in
            self?.fetchEntries()
        }
    }
    
    // MARK: - Private Helpers
    
    private func processResult(_ result: Result<[DiaryEntryModel], Error>) {
        switch result {
        case .success(let models):
            applyFilters(to: models)
        case .failure(let error):
            print("Failed to fetch entries: \(error)")
            self.entries = []
            self.onDataUpdated?()
        }
    }
    
    private func applyFilters(to models: [DiaryEntryModel]) {
        var filtered = models
        
        if isShowingFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        if let mood = moodFilter {
            filtered = filtered.filter { $0.mood == mood }
        }
        
        self.entries = filtered
        self.onDataUpdated?()
    }
}

