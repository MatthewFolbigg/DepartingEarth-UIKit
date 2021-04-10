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
    
    enum LaunchStatus: Int {
        case go = 1
        case tbd = 2
        case success = 3
        case failure = 4
        case hold = 5
        
        var description: String {
            switch self {
            case .go: return "Go"
            case .tbd: return "Pending"
            case .success: return "Success"
            case .failure: return "Failure"
            case .hold: return "On Hold"
            }
        }
        
        var countdownDescription: String {
            switch self {
            case .go: return "Launching"
            case .tbd: return "Estimated"
            case .success: return "Launched"
            case .failure: return "Failed"
            case .hold: return "Holding"
            }
        }
        
        var colour: UIColor {
            switch self {
            case .go: return Colours.cosmonautSuitGreen.ui
            case .tbd: return Colours.moonSurfaceGrey.ui
            case .success: return Colours.cosmonautSuitGreen.ui
            case .failure: return Colours.nasaWormRed.ui
            case .hold: return Colours.nasaWormRed.ui
            }
        }
        
        var alternateColour: UIColor {
            switch self {
            case .go: return Colours.moonCraterGrey.ui.withAlphaComponent(0.8)
            case .tbd: return Colours.moonCraterGrey.ui.withAlphaComponent(0.2)
            case .success: return Colours.cosmonautSuitGreen.ui.withAlphaComponent(0.8)
            case .failure: return Colours.nasaWormRed.ui.withAlphaComponent(0.6)
            case .hold: return Colours.nasaWormRed.ui.withAlphaComponent(0.6)
            }
        }
    }
    
    static func createLaunchObjectFrom(launchInfo: LaunchInfo, context: NSManagedObjectContext) -> Launch {
        let launch = Launch(context: context)
        let rocket = Rocket(context: context)
        let pad = LaunchPad(context: context)
        let mission = Mission(context: context)
        
        launch.launchId = launchInfo.id
        launch.name = launchInfo.name
        launch.netDate = launchInfo.noEarlierThan
        launch.launchProviderId = Int64(launchInfo.launchServiceProvider.id)
        launch.datePending = launchInfo.tbddate
        launch.timePending = launchInfo.tbdtime
        launch.onHold = launchInfo.inhold
        launch.windowStart = launchInfo.windowStart
        launch.windowEnd = launchInfo.windowEnd
        setLaunchStatusId(launch: launch, launchInfo: launchInfo)
        
        rocket.name = launchInfo.rocket.configuration.name
        rocket.family = launchInfo.rocket.configuration.family
        rocket.variant = launchInfo.rocket.configuration.variant
        
        pad.name = launchInfo.pad.name
        pad.latitude = launchInfo.pad.latitude
        pad.longitude = launchInfo.pad.longitude
        pad.padID = Int64(launchInfo.pad.id)
        pad.loacationName = launchInfo.pad.location.name
        
        mission.missionID = Int64(launchInfo.mission?.id ?? 0)
        mission.name = launchInfo.mission?.name
        mission.type = launchInfo.mission?.type
        mission.objectives = launchInfo.mission?.description
        mission.orbit = launchInfo.mission?.orbit?.name
        mission.orbitID = Int64(launchInfo.mission?.orbit?.id  ?? 0)
        
        launch.rocket = rocket
        launch.launchPad = pad
        launch.mission = mission
        
        let updatedAt = Date()
        launch.lastUpdated = updatedAt
        
        try? context.save()
        return launch
    }
    
    static private func setLaunchStatusId(launch: Launch, launchInfo: LaunchInfo) {
        let apiStatusID = launchInfo.launchStatus.id
        if apiStatusID == 4 {
            launch.statusId = 4
            launch.statusDescription = LaunchStatus.failure.description
            return
        }
        if apiStatusID == 3 {
            launch.statusId = 3
            launch.statusDescription = LaunchStatus.success.description
            return
        }
        if launchInfo.inhold == true {
            launch.statusId = 5
            launch.statusDescription = LaunchStatus.hold.description
            return
        }
        if launchInfo.tbddate || launchInfo.tbdtime {
            launch.statusId = 2
            launch.statusDescription = LaunchStatus.tbd.description
            return
        }
        launch.statusId = 1
        launch.statusDescription = LaunchStatus.go.description
        
    }
    
    static func checkAgeOfDataIsAcceptable(launch: Launch) -> Bool {
        guard let lastUpdated = launch.lastUpdated else { return false }
        let now = Date()
        let ageInSeconds = now.timeIntervalSince(lastUpdated)
        let maximumAcceptableAgeInSeconds: Double = 3600 //1 Hour
        if ageInSeconds > maximumAcceptableAgeInSeconds {
            return false
        } else {
            return true
        }
    }
    
    static func fetchStoredLaunches(context: NSManagedObjectContext) -> [Launch]? {
        let fetchRequest = NSFetchRequest<Launch>(entityName: "Launch")
        let fetchedLaunhces = try? context.fetch(fetchRequest)
        return fetchedLaunhces
    }
    
    static func deleteStoredLaunches(context: NSManagedObjectContext) {
        if let storedLaunches = LaunchHelper.fetchStoredLaunches(context: context) {
            for launch in storedLaunches {
                context.delete(launch)
            }
            try? context.save()
        }
    }
        
    
}

