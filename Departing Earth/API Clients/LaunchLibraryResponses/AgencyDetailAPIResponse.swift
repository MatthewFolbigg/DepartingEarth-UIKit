//
//  AgencyByIdAPIResponse.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/04/2021.
//

import Foundation

struct AgencyDetail: Codable {
    
    let id: Int
    let name: String
    let abbreviation: String
    let logoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case abbreviation = "abbrev"
        case logoUrl = "logo_url"
    }
}
