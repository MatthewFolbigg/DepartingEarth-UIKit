//
//  LaunchController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 10/04/2021.
//

import Foundation
import CoreData

struct LaunchLibraryAPICoreDataAdapter {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: Construction Methods
    func createLaunchFrom(launchInfo: LaunchInfo) -> Launch {
        //CoreData merge policy and constraints will prevent duplicates of the entities that have an ID.
        let launch = Launch(context: context)
        launch.launchID = launchInfo.id
        launch.name = launchInfo.name
        launch.date = convertToDate(isoString: launchInfo.noEarlierThan)
        launch.windowStart = convertToDate(isoString: launchInfo.windowStart)
        launch.windowEnd = convertToDate(isoString: launchInfo.windowEnd)
        launch.isPendingDate = launchInfo.tbddate
        launch.isPendingTime = launchInfo.tbdtime
        launch.isOnHold = launchInfo.inhold
        launch.statusID = Int16(launchInfo.launchStatus.id)
        launch.statusDescription = launchInfo.launchStatus.name
        launch.pad = padFrom(padInfo: launchInfo.pad)
        launch.provider = providerFrom(providerInfo: launchInfo.launchServiceProvider)
        launch.rocket = rocketFrom(rocketInfo: launchInfo.rocket)
        if let missionInfo = launchInfo.mission {
            launch.mission = missionFrom(missionInfo: missionInfo)
        }
        return launch
    }
    
    private func missionFrom(missionInfo: MissionInfo) -> Mission {
        let mission = Mission(context: context)
        mission.missionID = Int16(missionInfo.id)
        mission.name = missionInfo.name
        mission.type = missionInfo.type
        mission.objectives = missionInfo.description
        mission.orbitName = missionInfo.orbit?.name
        mission.orbitAbbreviation = missionInfo.orbit?.abbrev
        return mission
    }
    
    private func padFrom(padInfo: PadInfo) -> Pad {
        let pad = Pad(context: context)
        pad.name = padInfo.name
        pad.padID = Int16(padInfo.id)
        pad.latitude = padInfo.latitude
        pad.longitude = padInfo.longitude
        pad.loacationName = padInfo.location.name
        return pad
    }
    
    private func providerFrom(providerInfo: providerInfo) -> Provider {
        let provider = Provider(context: context)
        provider.providerID = Int16(providerInfo.id)
        provider.name = providerInfo.name
        provider.logoURL = providerInfo.logoUrl
        provider.abbreviation = providerInfo.abbreviation
        provider.type = providerInfo.type
        let logo = Logo(context: context)
        provider.logo = logo
        return provider
    }
    
    private func rocketFrom(rocketInfo: RocketInfo) -> Rocket {
        let rocket = Rocket(context: context)
        rocket.name = rocketInfo.configuration.name
        rocket.family = rocketInfo.configuration.family
        rocket.variant = rocketInfo.configuration.variant
        return rocket
    }
    
    //MARK: Converter Methods
    private func convertToDate(isoString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: isoString)
        return date
    }
}
