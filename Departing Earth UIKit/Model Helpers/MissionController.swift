//
//  MissionController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 21/04/2021.
//

import Foundation
import UIKit

class MissionController {
    
    class func missionTypeIconFor(mission: Mission) -> UIImage {
        switch mission.type {
        case "Human Exploration": return UIImage(systemName: "person.2")!
        case "Test Flight": return UIImage(systemName: "wrench")!
        case "Communications": return UIImage(systemName: "antenna.radiowaves.left.and.right")!
        case "Government/Top Secret": return UIImage(systemName: "lock")!
        case "Earth Science": return UIImage(systemName: "leaf")!
        case "Planetary Science": return UIImage(systemName: "circle.dashed.inset.fill")!
        case "Resupply": return UIImage(systemName: "shippingbox")!
        case "Suborbital": return UIImage(systemName: "circle.bottomhalf.fill")!
        case "Dedicated Rideshare": return UIImage(systemName: "circles.hexagongrid")!
        default: return UIImage(systemName: "doc.plaintext")!
        }
    }
    
}
