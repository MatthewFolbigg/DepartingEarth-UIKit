//
//  ModelHelpers.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation
import CoreData
import UIKit

class LaunchHelper {
    
    static func createLaunchObjectFrom(launchInfo: LaunchInfo, context: NSManagedObjectContext) -> Launch {
        let launch = Launch(context: context)
        let rocket = Rocket(context: context)
        launch.launchId = launchInfo.id
        launch.name = launchInfo.name
        launch.netDate = launchInfo.noEarlierThan
        rocket.name = launchInfo.rocket.configuration.name
        rocket.family = launchInfo.rocket.configuration.family
        rocket.variant = launchInfo.rocket.configuration.variant
        launch.rocket = rocket
        launch.launchProviderId = Int64(launchInfo.launchServiceProvider.id)
        try? context.save()
        return launch
    }
    
    static func fetchStoredLaunches(context: NSManagedObjectContext) -> [Launch] {
        let fetchRequest = NSFetchRequest<Launch>(entityName: "Launch")
        if let fetchedLaunhces = try? context.fetch(fetchRequest) {
            return fetchedLaunhces
        }
        return []
    }
        
    
}

