//
//  LaunchManager.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 10/04/2021.
//

import Foundation
import CoreData

class LaunchManager {
    
    var context: NSManagedObjectContext
    var apiAdapter: LaunchLibraryAPICoreDataAdapter
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.apiAdapter = LaunchLibraryAPICoreDataAdapter(context: self.context)
    }
    
    //MARK: Creation
    func createLaunchesFrom(results: [LaunchInfo]) -> [Launch] {
        var launches: [Launch] = []
        for result in results {
            launches.append(apiAdapter.createLaunchFrom(launchInfo: result))
        }
        do {
            try context.save()
        } catch {
            //TODO: Handle failed to save error
            print("Failed to save launches generated from results")
        }
        return launches
    }
    
    //MARK: Fetches
    func fetchStoredLaunches() -> [Launch]? {
        let sort = NSSortDescriptor(key: "date", ascending: true)
        let fetchRequest = NSFetchRequest<Launch>(entityName: "Launch")
        fetchRequest.sortDescriptors = [sort]
        let fetchedLaunhces = try? context.fetch(fetchRequest)
        return fetchedLaunhces
    }
    
    func fetchStoredProviders() -> [Provider]? {
        let sort = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<Provider>(entityName: "Provider")
        fetchRequest.sortDescriptors = [sort]
        let fetchedProviders = try? context.fetch(fetchRequest)
        return fetchedProviders
    }
        
    //MARK: Deletion
    func deleteStoredLaunches() {
        if let storedLaunches = fetchStoredLaunches() {
            for launch in storedLaunches {
                context.delete(launch)
            }
            try? context.save()
        }
    }
    
    
}

