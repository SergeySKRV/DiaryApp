//
//  CoreDataDiaryRepository.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 16.07.2026.
//

import CoreData
import Foundation

/// Core Data implementation of DiaryRepositoryProtocol
final class CoreDataDiaryRepository: DiaryRepositoryProtocol {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Fetch Entries
    
    func fetchAll(completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let fetchRequest = DiaryEntry.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                
                let entities = try context.fetch(fetchRequest)
                let models = entities.compactMap { self.mapToModel($0) }
                
                DispatchQueue.main.async {
                    completion(.success(models))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchEntries(for dayKey: String, completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let fetchRequest = DiaryEntry.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "dayKey == %@", dayKey)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                
                let entities = try context.fetch(fetchRequest)
                let models = entities.compactMap { self.mapToModel($0) }
                
                DispatchQueue.main.async {
                    completion(.success(models))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    //MARK: - Search
    
    func search(query: String, completion: @escaping (Result<[DiaryEntryModel], Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            do {
                let fetchRequest = DiaryEntry.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR text CONTAINS[cd] %@", query, query)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
                
                let entities = try context.fetch(fetchRequest)
                let models = entities.compactMap { self.mapToModel($0) }
                
                DispatchQueue.main.async {
                    completion(.success(models))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Create
    
    func create(
        title: String,
        text: String,
        mood: MoodType?,
        imageData: Data?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataStack.performBackgroundTask { context in
            let entry = DiaryEntry(context: context)
            entry.id = UUID()
            entry.title = title
            entry.text = text
            entry.createdAt = Date()
            entry.updatedAt = Date()
            entry.isFavorite = false
            entry.moodRawValue = mood?.rawValue
            entry.dayKey = Date().dayKey()
            entry.imageData = imageData
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Update
    
    func update(_ entry: DiaryEntryModel, imageData: Data?, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let fetchRequest = DiaryEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", entry.id as CVarArg)
            
            do {
                guard let entity = try context.fetch(fetchRequest).first else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "DiaryRepositoryError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entry not found"])))
                    }
                    return
                }
                
                entity.title = entry.title
                entity.text = entry.text
                entity.moodRawValue = entry.mood?.rawValue
                entity.isFavorite = entry.isFavorite
                entity.updatedAt = Date()
                entity.dayKey = entry.createdAt.dayKey()
                entity.imageData = imageData
                
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    //MARK: - Toggle Favorite
    
    func toggleFavorite(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let fetchRequest = DiaryEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                guard let entity = try context.fetch(fetchRequest).first else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "DiaryRepositoryError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entry not found"])))
                    }
                    return
                }
                
                entity.isFavorite.toggle()
                entity.updatedAt = Date()
                
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Delete
    
    func delete(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performBackgroundTask { context in
            let fetchRequest = DiaryEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                guard let entity = try context.fetch(fetchRequest).first else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "DiaryRepositoryError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Entry not found"])))
                    }
                    return
                }
                
                context.delete(entity)
                try context.save()
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Mapping
    
    private func mapToModel(_ entity: DiaryEntry) -> DiaryEntryModel? {
        guard let id = entity.id,
              let title = entity.title,
              let text = entity.text,
              let createdAt = entity.createdAt,
              let updatedAt = entity.updatedAt else {
            return nil
        }
        
        let dayKey = entity.dayKey ?? createdAt.dayKey()
        let mood = entity.moodRawValue.flatMap { MoodType(rawValue: $0) }
        
        return DiaryEntryModel(
            id: id,
            title: title,
            text: text,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isFavorite: entity.isFavorite,
            mood: mood,
            dayKey: dayKey,
            imageData: entity.imageData
        )
    }
}
