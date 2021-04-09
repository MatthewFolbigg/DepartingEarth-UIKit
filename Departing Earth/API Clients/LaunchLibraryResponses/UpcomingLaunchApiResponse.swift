//
//  LaunchLibraryApiResponses.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation

//MARK: Response Array
struct UpcomingLaunchApiResponse: Codable {
    let results: [LaunchInfo]
}

//MARK: Main Response Object
struct LaunchInfo: Codable {
    let id: String
    let name: String
    let rocket: RocketLaunching
    let mission: MissionInfo?
    let launchServiceProvider: LaunchServiceProvider
    let noEarlierThan: String
    let launchStatus: LaunchStatus
    let inhold: Bool
    let tbdtime: Bool
    let tbddate: Bool
    let holdreason: String?
    let windowStart: String
    let windowEnd: String
    let pad: Pad
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case rocket = "rocket"
        case mission = "mission"
        case launchServiceProvider = "launch_service_provider"
        case noEarlierThan = "net"
        case launchStatus = "status"
        case inhold = "inhold"
        case tbdtime = "tbdtime"
        case tbddate = "tbddate"
        case holdreason = "holdreason"
        case windowStart = "window_start"
        case windowEnd = "window_end"
        case pad = "pad"
    }
}

//MARK: Launch Provider
struct LaunchServiceProvider: Codable {
    let name: String
    let type: String?
    let id: Int
}

//MARK: Rocket
struct RocketLaunching: Codable {
    let configuration: RocketConfiguration
}

struct RocketConfiguration: Codable {
    let name: String
    let family: String
    let variant: String
}

//MARK: Mission
struct MissionInfo: Codable {
    let id: Int
    let name: String
    let description: String
    let type: String
    let orbit: Orbit?
}

struct Orbit: Codable {
    let id: Int
    let name: String
    let abbrev: String
}

struct LaunchStatus: Codable {
    let id: Int
    let name: String
}

struct Pad: Codable {
    let id: Int
    let name: String
    let latitude: String
    let longitude: String
    let location: PadLocation
}

struct PadLocation: Codable {
    let name: String
}
