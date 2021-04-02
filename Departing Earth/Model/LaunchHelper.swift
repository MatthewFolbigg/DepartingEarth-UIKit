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
    
    static func createLaunchObjectFrom(launchInfo: LaunchInfo, context: NSManagedObjectContext, completion: @escaping (Launch) -> Void){
        let launch = Launch(context: context)
        let rocket = Rocket(context: context)
        launch.name = launchInfo.name
        launch.netDate = launchInfo.noEarlierThan
        rocket.name = launchInfo.rocket.configuration.name
        rocket.family = launchInfo.rocket.configuration.family
        rocket.variant = launchInfo.rocket.configuration.variant
        launch.rocket = rocket
        
        AgencyHelper.getAgencyForId(id: launchInfo.launchServiceProvider.id, context: context, completion: { (agency) in
            launch.launchProvider = agency
            try? context.save()
            completion(launch)
        })
    }
    
}

