//
//  LaunchStatusController.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 11/04/2021.
//

import Foundation
import UIKit

struct Countdown {
    var days: String
    var hours: String
    var minutes: String
    var seconds: String
    var t: String
}

struct StatusController {
    
    private enum Status: Int {
        case go = 1
        case tbd = 2
        case success = 3
        case failure = 4
        case hold
    }
    
    private var blankClockElement = "--"
    private var launch: Launch
    private var status: Status
    private let dateTimeStyles = DateTimeStyles()
    
    init(launch: Launch) {
        self.launch = launch
        if launch.isOnHold {
            self.status = .hold
        } else {
            self.status =  Status(rawValue: Int(launch.statusID)) ?? .tbd
        }
    }
    
    
    var color: UIColor {
        if status == .go {
            if launch.isPendingDate || launch.isPendingTime {
                return Colours.cosmonautSuitGreen.ui
            }
        }
        if status == .tbd {
            if !launch.isPendingDate && !launch.isPendingTime {
                return Colours.cosmonautSuitGreen.ui
            }
        }

        
        switch status {
        case .go: return Colours.cosmonautSuitGreen.ui
        case .tbd:  return Colours.moonSurfaceGrey.ui
        case .hold: return Colours.moonCraterGrey.ui
        case .success: return Colours.cosmonautSuitGreen.ui
        case .failure: return Colours.nasaWormRed.ui
        }
    }
    
    var secondaryColor: UIColor {
        switch status {
        case .go, .tbd, .hold: return Colours.moonCraterGrey.ui
        case .success: return Colours.cosmonautSuitGreen.ui
        case .failure: return Colours.nasaWormRed.ui
        }
    }
    
    var launchDescription: String {
        if status == .go {
            if launch.isPendingDate || launch.isPendingTime {
                return "Launching"
            }
        }
        if status == .tbd {
            if !launch.isPendingDate && !launch.isPendingTime {
                return "Pending Confirmation"
            }
        }
        switch status {
        case .go: return "Launching"
        case .tbd: return "Pending"
        case .success: return "Success"
        case .failure: return "Failed"
        case .hold: return "Holding"
        }
    }
    
    var dateDescription: String {
        if status == .go {
            if launch.isPendingDate || launch.isPendingTime {
                return "Launching"
            }
        }
        if status == .tbd {
            if !launch.isPendingDate && !launch.isPendingTime {
                return "Targeting"
            }
        }
        switch status {
        case .go: return "Launching"
        case .tbd: return "TBC"
        case .success: return "Departed"
        case .failure: return "Failed"
        case .hold: return "Holding"
        }
    }
    
    var countdownComponents: Countdown {
        var isPreLaunch = "-"
        let noCountdown = Countdown(days: blankClockElement, hours: blankClockElement, minutes: blankClockElement, seconds: blankClockElement, t: isPreLaunch)
        guard let date = launch.date else { return noCountdown }
        if launch.isPendingDate && launch.isPendingTime && status != .go { return noCountdown }
        let countdownComponents = dateTimeStyles.countdownComponentsFromNowTo(date: date)
        let components = [countdownComponents.day, countdownComponents.hour, countdownComponents.minute, countdownComponents.second]
        for component in components {
            if component! < 0 {
                isPreLaunch = "+"
            }
        }
        
        var days = String(format: "%02d", countdownComponents.day!)
        var hours = String(format: "%02d", countdownComponents.hour!)
        var minutes = String(format: "%02d", countdownComponents.minute!)
        var seconds = String(format: "%02d", countdownComponents.second!)
        if countdownComponents.day! < 0 { days =  String(format: "%02d", countdownComponents.day! * -1) }
        if countdownComponents.hour! < 0 { hours =  String(format: "%02d", countdownComponents.hour! * -1) }
        if countdownComponents.minute! < 0 { minutes =  String(format: "%02d", countdownComponents.minute! * -1) }
        if countdownComponents.second! < 0 { seconds =  String(format: "%02d", countdownComponents.second! * -1) }
    
        let countdown = Countdown(days: days, hours: hours, minutes: minutes, seconds: seconds, t: isPreLaunch)
        return countdown
    }
    
    var launchTime: String {
        if launch.isPendingTime { return "Pending" }
        guard let date = launch.date else { return "Pending" }
        return dateTimeStyles.standardStringOf(time: date) ?? "Pending"
    }
    
    var launchDate: String {
        guard let date = launch.date else { return "Pending" }
        if !launch.isPendingDate {
            return dateTimeStyles.dayMonthYearStringOf(date: date)
        } else if status == .go {
            return dateTimeStyles.monthYearStringOf(date: date)
        } else {
            return "Pending"
        }
    }
    
    var targetedDate: String {
        guard let date = launch.date else { return "Pending" }
        return dateTimeStyles.dayMonthYearStringOf(date: date)
    }
}
