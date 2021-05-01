//
//  Colours.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit

struct AppUI {
    static var accentColour: UIColor = UIColor(named: "AccentColour")!
}

enum Colours {
    case spaceSuitOrange
    case cosmonautSuitGreen
    case nasaWormRed
    case moonSurfaceGrey
    case moonCraterGrey
    case white

    var ui: UIColor {
        let red = CGFloat(rgbValues["red"]!)/255.0
        let green = CGFloat(rgbValues["green"]!)/255.0
        let blue = CGFloat(rgbValues["blue"]!)/255.0
        let alapha: CGFloat = 1
        let colour  = UIColor(red: red, green: green, blue: blue, alpha: alapha)
        return colour
    }
    
    var cg: CGColor {
        let red = CGFloat(rgbValues["red"]!)/255.0
        let green = CGFloat(rgbValues["green"]!)/255.0
        let blue = CGFloat(rgbValues["blue"]!)/255.0
        let alapha: CGFloat = 1
        let colour  = CGColor(red: red, green: green, blue: blue, alpha: alapha)
        return colour
    }

    var rgbValues: [String: Float] {
        switch self {
        case .spaceSuitOrange:   return [ "red": 230,   "green": 115,   "blue": 50   ]
        case.cosmonautSuitGreen: return [ "red": 161,   "green": 214,   "blue": 172  ]
        case.nasaWormRed:        return [ "red": 187,   "green": 39,    "blue": 45   ]
        case .moonSurfaceGrey:   return [ "red": 227,   "green": 227,    "blue": 227   ]
        case .moonCraterGrey:    return [ "red": 100,   "green": 100,    "blue": 100   ]
        case .white:             return [ "red": 246,   "green": 247,   "blue": 249  ]
        }
    }
}
