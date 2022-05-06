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
}

extension ManagedSearch {
    
}
