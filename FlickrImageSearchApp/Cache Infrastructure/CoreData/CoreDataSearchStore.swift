//
//  CoreDataSearchStore.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import CoreData

final class CoreDataSearchStore {
    private static let modelName = "ImageSearchStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataSearchStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    init(storeURL: URL) throws {
        guard let model = CoreDataSearchStore.model else { throw StoreError.modelNotFound }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataSearchStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform {
            action(context)
        }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.perform {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
