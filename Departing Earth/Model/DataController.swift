//
//  DataController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation
import CoreData

class DataController {
    let persistantContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext { persistantContainer.viewContext }
    
    init(modelName: String) {
        persistantContainer = NSPersistentContainer(name: modelName)
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func load(completion: @escaping (NSPersistentStoreDescription?) -> Void) {
        persistantContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error?.localizedDescription ?? "Error Loading Persistant stores")
            }
            completion(description)
        }
    }
    
}
