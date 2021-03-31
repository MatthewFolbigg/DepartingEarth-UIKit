//
//  ModelHelpers.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation
import CoreData

class ModelHelpers {
    
    class func createLaunchObjectFrom(launchInfo: LaunchInfo, context: NSManagedObjectContext) -> Launch {
        let launch = Launch(context: context)
        let launchProvider = LaunchProvider(context: context)
        let rocket = Rocket(context: context)
        launch.name = launchInfo.name
        launchProvider.name = launchInfo.launchServiceProvider.name
        launchProvider.type = launchInfo.launchServiceProvider.type
        rocket.name = launchInfo.rocket.configuration.name
        rocket.family = launchInfo.rocket.configuration.family
        rocket.variant = launchInfo.rocket.configuration.variant
        launch.rocket = rocket
        launch.launchProvider = launchProvider
        return launch
    }
    
}
