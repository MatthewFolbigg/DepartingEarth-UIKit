//
//  colours.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit

enum Colours {
    case spaceSuitOrange
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
    //CGColor(red: 246/255, green: 247/255, blue: 249/255, alpha: 1)
    var rgbValues: [String: Float] {
        switch self {
        case .spaceSuitOrange: return [ "red": 230,   "green": 115,   "blue": 50  ]
        case .white:           return [ "red": 246,   "green": 247,   "blue": 249  ]
        }
    }
}
