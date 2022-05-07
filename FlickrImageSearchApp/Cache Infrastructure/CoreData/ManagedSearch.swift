//
//  ManagedSearch.swift
//  FlickrImageSearchApp
//
//  Created by Mohammad Bitar on 5/6/22.
//

import CoreData

@objc(ManagedSearch)
class ManagedSearch: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var keyword: String
    @NSManaged var createdAt: NSDate
}

extension ManagedSearch {
    static func keywords(in context: NSManagedObjectContext) throws -> [ManagedSearch] {
        if let entityName = entity().name {
            let request = NSFetchRequest<ManagedSearch>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            return try context.fetch(request)
        }
        
        return []
    }
    
    static func find(where keyword: String, in context: NSManagedObjectContext) throws -> ManagedSearch? {
        if let entityName = entity().name {
            let request = NSFetchRequest<ManagedSearch>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedSearch.keyword), keyword])
            request.fetchLimit = 1
            return try context.fetch(request).first
        }
        
        return .none
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedSearch {
        return ManagedSearch(context: context)
    }
}
