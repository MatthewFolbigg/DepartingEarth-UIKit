//
//  LaunchDateTimes.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 31/03/2021.
//

import Foundation

class LaunchDateTimes {
    
    class func convertStringToDate(isoString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: isoString)
        return date
    }
    
    class func convertDateToFormattedString(date: Date, showDate: Bool, showTime: Bool) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = showDate ? .none : .short
        dateFormatter.dateStyle = showTime ? .none : .short
        let date = dateFormatter.string(from: date)
        return date
    }
    
    class func formatIsoDateString(isoString: String, showDate: Bool, showTime: Bool) -> String? {
        guard let date = convertStringToDate(isoString: isoString) else {
            print("Failed to convert ISO string to date. String may be invalid.")
            return nil
        }
        let formatedString = convertDateToFormattedString(date: date, showDate: showDate, showTime: showTime)
        return formatedString
    }
    
    class func deafultNetDateFormatFor(launch: Launch) -> String? {
        guard let isoDate = launch.netDate else { return nil }
        if let netDateFormatted = LaunchDateTimes.formatIsoDateString(isoString: isoDate, showDate: true, showTime: false) {
            return netDateFormatted
        }
        return nil
    }
    
    
}
