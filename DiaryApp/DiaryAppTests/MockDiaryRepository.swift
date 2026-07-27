//
//  MockDiaryRepository.swift
//  DiaryAppTests
//
//  Created by Сергей Скориков on 27.07.2026.
//

import XCTest
@testable import DiaryApp

// MARK: - Mock Repository

class MockDiaryRepository: DiaryRepositoryProtocol {
    
    var mockEntries: [DiaryEntryModel] = []
    
    func fetchAll(completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void) {
        completion(.success(mockEntries))
    }
    
    func fetchEntries(for dayKey: String, completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void) {
        let filtered = mockEntries.filter { $0.dayKey == dayKey }
        completion(.success(filtered))
    }
    
    func search(query: String, completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void) {
        let filtered = mockEntries.filter { $0.title.contains(query) || $0.text.contains(query) }
        completion(.success(filtered))
    }
    
    func create(title: String, text: String, mood: MoodType?, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func update(_ entry: DiaryEntryModel, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
    
    func toggleFavorite(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        if let index = mockEntries.firstIndex(where: { $0.id == id }) {
            let entry = mockEntries[index]
            mockEntries[index] = DiaryEntryModel(
                id: entry.id,
                title: entry.title,
                text: entry.text,
                createdAt: entry.createdAt,
                updatedAt: Date(),
                isFavorite: !entry.isFavorite,
                mood: entry.mood,
                dayKey: entry.dayKey
            )
        }
        completion(.success(()))
    }
}
