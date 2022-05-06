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
    @NSManaged var createdAt: Data
}

extension ManagedSearch {
    static func keywords(in context: NSManagedObjectContext) throws -> [ManagedSearch] {
        if let entityName = entity().name {
            let request = NSFetchRequest<ManagedSearch>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            return try context.fetch(request)
        }
        
        return []
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedSearch {
        return ManagedSearch(context: context)
    }
}
