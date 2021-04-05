//
//  Fonts.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit

enum Fonts {
    case customMonospaced(CGFloat, UIFont.Weight)
    case customMonospacedDigit(CGFloat, UIFont.Weight)
    case cellTitle
    case cellSmall
    case cellBody
    case navigationTitleLarge
    case navigationTitleSmall
    
    var uiFont: UIFont {
        switch self {
        case .customMonospaced(let size, let weight):
            return UIFont.monospacedSystemFont(ofSize: size, weight: weight)
        case .customMonospacedDigit(let size, let weight):
            return UIFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
        case .cellTitle:
            return UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
        case .cellSmall:
            return UIFont.monospacedSystemFont(ofSize: 10, weight: .light)
        case .cellBody:
            return UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .medium)
        case .navigationTitleLarge:
            return UIFont.monospacedSystemFont(ofSize: 28, weight: .semibold)
        case .navigationTitleSmall:
            return UIFont.monospacedSystemFont(ofSize: 18, weight: .semibold)
        }
    }
    
}

func test() {

}
