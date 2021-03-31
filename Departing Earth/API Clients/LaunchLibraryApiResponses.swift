//
//  LaunchLibraryApiResponses.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation

struct LaunchLibraryApiResponse: Codable {
    let results: [LaunchInfo]
}

//TODO: For testing, will replace with coreData entity
struct LaunchInfo: Codable {
    let name: String
}

