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
    
    private static func convertToDate(isoString: String) -> Date? {
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
    
    static func defaultDateString (isoString: String?) -> String? {
        guard let isoString = isoString else { return "TBD" }
        guard let date = convertToDate(isoString: isoString) else {
            print("Invalid ISO String provided in attempt to get default date string")
            return "TBD"
        }
        let userTimeZoneDate = convertToUserTimeZone(date: date)
        let calendar = Calendar.current
        let dayInt = calendar.component(.day, from: userTimeZoneDate)
        let yearInt = calendar.component(.year, from: userTimeZoneDate)
        let monthInt = calendar.component(.month, from: userTimeZoneDate)
        let monthString = Month(rawValue: monthInt)
        return "\(dayInt) \(monthString!) \(yearInt)"
    }
    
    static func countdownStringTo(isoString: String) -> String {
        guard let remainingSeconds = secondsUntil(isoString: isoString) else {
            return ""
        }
        let formattedString = hoursMinutesSecondsStringFrom(seconds: remainingSeconds)
        return formattedString
    }
    
    static private func secondsUntil(isoString: String) -> Double? {
        guard let date = convertToDate(isoString: isoString) else {
            print("Invalid ISO String provided")
            return nil
        }
        let interval = date.timeIntervalSinceNow
        return interval
    }
    
    static private func hoursMinutesSecondsStringFrom(seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        guard let formattedString = formatter.string(from: seconds) else {
            return ""
        }
        return formattedString
    }
    
}
