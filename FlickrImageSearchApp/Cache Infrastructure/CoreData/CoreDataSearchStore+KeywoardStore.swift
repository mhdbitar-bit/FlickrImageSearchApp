//
//  CoreDataSearchStore+KeywoardStore.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import CoreData

extension CoreDataSearchStore: SearchKeywoardStore {
    
    func insert(_ keyword: String, completion: @escaping (InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                let managedSearch = try ManagedSearch.newUniqueInstance(in: context)
                managedSearch.id = UUID()
                managedSearch.keyword = keyword
                managedSearch.createdAt = NSDate()
                try context.save()
            })
        }
    }
    
    func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedSearch.keywords(in: context).map {
                    $0.keyword
                }
            })
        }
    }
    
    func delete(where keyword: String, completion: @escaping (DeletionResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedSearch.find(where: keyword, in: context).map(context.delete).map(context.save)
            })
        }
    }
}
