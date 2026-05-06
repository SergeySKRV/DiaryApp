//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Сергей Скориков on 06.05.2026.
//

import CoreData

/// Manages the Core Data stack used in the app.
final class CoreDataStack {
    
    // MARK: - Shared Instance
    
    static let shared = CoreDataStack()
    
    // MARK: - Properties
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Init
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "DiaryApp")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.loadPersistentStores { ( _, error) in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // MARK: - Saving
    
    /// Saves changes in the main view context if needed.
    func saveViewContext() {
        let context = viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to save view context: \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Background Work
    
    /// Performs Core Data work on a background context.
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            block(context)
        }
    }
    
    /// Creates and returns a new background context.
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}

