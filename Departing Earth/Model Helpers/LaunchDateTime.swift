//
//  LaunchDateTimes.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation

class LaunchDateTime {
    
    enum Month: Int {
        case Jan = 1, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
    }
    
    //MARK: Public Methods    
    static func countdownTimerString(launch: Launch) -> String? {
        let defaultString = "-- -- -- --"
        guard let launchStatus = LaunchHelper.LaunchStatus(rawValue: Int(launch.statusId)) else { return defaultString }
        guard let launchDate = launch.netDate else { return defaultString }
        guard let remainingSeconds = secondsUntil(isoString: launchDate) else { return defaultString }
        
        switch launchStatus {
        case .hold, .success, .failure: return launchStatus.description
        case .tbd: return defaultString
        case .go:
            let countdownString = countdownStringFrom(seconds: remainingSeconds)
            return "T- \(countdownString)"
        }
    }
    
    static func launchDateString (isoString: String?) -> String {
        guard let date = convertToDate(isoString: isoString) else { return "Pending" }
        let userTimeZoneDate = convertToUserTimeZone(date: date)
        let calendar = Calendar.current
        let dayInt = calendar.component(.day, from: userTimeZoneDate)
        let yearInt = calendar.component(.year, from: userTimeZoneDate)
        let monthInt = calendar.component(.month, from: userTimeZoneDate)
        let monthString = Month(rawValue: monthInt)
        return "\(dayInt) \(monthString!) \(yearInt)"
    }
    
    static func launchTimeString(isoString: String?) -> String {
        guard let date = convertToDate(isoString: isoString) else { return "Pending" }
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = calendar.component(.hour, from: date)
        components.minute = calendar.component(.minute, from: date)
        return basicTimeStringFrom(timeComponents: components)
    }
    
    static func launchDate(launch: Launch) -> Date? {
        guard let isoString = launch.netDate else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: isoString)
        return date
    }

    //MARK: Private Methods
    private static func convertToDate(isoString: String?) -> Date? {
        guard let isoString = isoString else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: isoString)
        return date
    }
    
    private static func convertToUserTimeZone(date: Date) -> Date {
        let calendar = Calendar.current
        let userDateComponents = calendar.dateComponents(in: calendar.timeZone, from: date)
        let date = calendar.date(from: userDateComponents)!
        return date
    }
        
    private static func secondsUntil(isoString: String) -> Double? {
        guard let date = convertToDate(isoString: isoString) else {
            print("Invalid ISO String provided")
            return nil
        }
        let interval = date.timeIntervalSinceNow
        return interval
    }
    
    private static func countdownStringFrom(seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        guard let formattedString = formatter.string(from: seconds) else {
            return ""
        }
        return formattedString
    }
    
    private static func basicTimeStringFrom(timeComponents: DateComponents) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        guard let formattedString = formatter.string(from: timeComponents) else {
            return ""
        }
        return formattedString
    }
    
        
}
