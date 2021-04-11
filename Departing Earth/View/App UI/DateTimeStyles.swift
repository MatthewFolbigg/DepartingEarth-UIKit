//
//  DateStyles.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 11/04/2021.
//

import Foundation

struct DateTimeStyles {
    
    private let calendar = Calendar.current
    
    enum Month: Int {
        case Jan = 1, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec
    }
    
    func dayMonthYearStringOf(date: Date) -> String {
        let dayInt = calendar.component(.day, from: date)
        let yearInt = calendar.component(.year, from: date)
        let monthInt = calendar.component(.month, from: date)
        let monthString = Month(rawValue: monthInt)
        return "\(dayInt) \(monthString!) \(yearInt)"
    }
    
    func monthYearStringOf(date: Date) -> String {
        let yearInt = calendar.component(.year, from: date)
        let monthInt = calendar.component(.month, from: date)
        let monthString = Month(rawValue: monthInt)
        return "\(monthString!) \(yearInt)"
    }
    
    func standardStringOf(time: Date) -> String? {
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: time)
        dateComponents.minute = calendar.component(.minute, from: time)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        guard let formattedString = formatter.string(from: dateComponents) else {
            return nil
        }
        return formattedString
    }
    
    func countdownStringFromNowTo(date: Date) -> String? {
        let interval = date.timeIntervalSinceNow
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        guard let formattedString = formatter.string(from: interval) else {
            return nil
        }
        return formattedString
    }
    
    func countdownComponentsFromNowTo(date: Date) -> DateComponents {
        let now = Date()
        let launch = date
        let components: Set<Calendar.Component> = [
            Calendar.Component.day,
            Calendar.Component.hour,
            Calendar.Component.minute,
            Calendar.Component.second
        ]
        let countdownComponents = calendar.dateComponents(components, from: now, to: launch)
        return countdownComponents
    }
    
}
