//
//  Fonts.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 05/04/2021.
//

import Foundation
import UIKit

enum Fonts {
    case cellTitle
    case cellSubtitle
    case cellSubtitleTwo
    case cellSmall
    case cellCountdown
    case cellDate
    case cellBody
    
    case detailSmall
    case detailCountdown
    
    case customMonospaced(CGFloat, UIFont.Weight)
    case customMonospacedDigit(CGFloat, UIFont.Weight)
    case navigationTitleLarge
    case navigationTitleSmall
    
    var uiFont: UIFont {
        switch self {
        case .cellTitle:
            return UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .semibold)
        case .cellSubtitle:
            return UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        case .cellSubtitleTwo:
            return UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .light)
        case .cellSmall:
            return UIFont.monospacedDigitSystemFont(ofSize: 8, weight: .light)
        case .cellCountdown:
            return UIFont.monospacedSystemFont(ofSize: 16, weight: .semibold)
        case .cellDate:
            return UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .semibold)
        case .cellBody:
            return UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .light)
            
        case .detailCountdown:
            return UIFont.monospacedSystemFont(ofSize: 26, weight: .semibold)
        case .detailSmall:
            return UIFont.monospacedDigitSystemFont(ofSize: 10, weight: .light)
            
        case .customMonospaced(let size, let weight):
            return UIFont.monospacedSystemFont(ofSize: size, weight: weight)
        case .customMonospacedDigit(let size, let weight):
            return UIFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
        case .navigationTitleLarge:
            return UIFont.monospacedSystemFont(ofSize: 28, weight: .semibold)
        case .navigationTitleSmall:
            return UIFont.monospacedSystemFont(ofSize: 18, weight: .semibold)
        }
    }
    
}

func test() {

}
