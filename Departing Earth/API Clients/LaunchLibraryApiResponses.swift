//
//  LaunchLibraryApiResponses.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation

//MARK: Response Array
struct LaunchLibraryApiResponse: Codable {
    let results: [LaunchInfo]
}

//MARK: Main Response Object
struct LaunchInfo: Codable {
    let name: String
    let rocket: RocketLaunching
    let mission: Mission?
    let launchServiceProvider: LaunchServiceProvider
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rocket = "rocket"
        case mission = "mission"
        case launchServiceProvider = "launch_service_provider"
    }
}

//MARK: Launch Provider
struct LaunchServiceProvider: Codable {
    let name: String
    let type: String?
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
struct Mission: Codable {
    let name: String
    let description: String
    let type: String
    let orbit: Orbit?
}

struct Orbit: Codable {
    let name: String
    let abbrev: String
}
