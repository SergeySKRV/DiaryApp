//
//  DiaryDetailsViewModel.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import UIKit

final class DiaryDetailsViewModel {
    
    private let repository: DiaryRepositoryProtocol
    let existingEntry: DiaryEntryModel?
    
    var onSaved: (() -> Void)?
    
    var isEditMode: Bool {
        existingEntry != nil
    }
    
    var currentImageData: Data?
    
    init(repository: DiaryRepositoryProtocol, entry: DiaryEntryModel? = nil) {
        self.repository = repository
        self.existingEntry = entry
        self.currentImageData = entry?.imageData
    }
    
    func save(title: String, text: String, mood: MoodType?, completion: @escaping (Result<Void, Error>) -> Void) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedText.isEmpty else {
            completion(.failure(NSError(domain: "DiaryDetailsError", code: 400, userInfo: [NSLocalizedDescriptionKey: L10n.detailsEmptyError])))
            return
        }
        
        if let existingEntry {
            let updatedEntry = DiaryEntryModel(
                id: existingEntry.id,
                title: trimmedTitle,
                text: trimmedText,
                createdAt: existingEntry.createdAt,
                updatedAt: Date(),
                isFavorite: existingEntry.isFavorite,
                mood: mood,
                dayKey: existingEntry.dayKey,
                imageData: currentImageData
                )
            repository.update(updatedEntry, imageData: currentImageData) { [weak self] result in
                if result.isSuccess {
                    self?.onSaved?()
                }
                completion(result)
            }
        } else {
            repository.create(title: trimmedTitle, text: trimmedText, mood: mood, imageData: currentImageData) { [weak self] result in
                if result.isSuccess {
                    self?.onSaved?()
                }
                completion(result)
            }
        }
    }
}

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}
