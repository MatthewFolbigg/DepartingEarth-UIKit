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
    
}
