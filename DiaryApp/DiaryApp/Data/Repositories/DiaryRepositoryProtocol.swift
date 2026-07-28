//
//  DiaryRepositoryProtocol.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import Foundation

/// Describes operations for working with diary entries
protocol DiaryRepositoryProtocol {
    func fetchAll(completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void)
    func fetchEntries(for dayKey: String, completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void)
    func search(query: String, completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void)
    func create(
        title: String,
        text: String,
        mood: MoodType?,
        imageData: Data?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func update(_ entry: DiaryEntryModel, imageData: Data?, completion: @escaping (Result<Void, Error>) -> Void)
    func toggleFavorite(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
}
