//
//  Date+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import Foundation
import UIKit

func current(_ component: Calendar.Component) -> Int {
    Calendar.current.component(component, from: Date())
}

extension Date {
    var daySuffix: String {
        switch Calendar.current.component(.day, from: self) {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 33: return "rd"
        default: return "th"
        }
    }
    
    func current(_ component: Calendar.Component) -> Int {
        Calendar.current.component(component, from: self)
    }

    func toString(
        format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        timezone: TimeZone? = TimeZone.current
    ) -> String {
        let formatter = with(DateFormatter()) {
            $0.dateStyle = .short
            $0.dateFormat = format
            $0.timeZone = timezone
        }
        
        return formatter.string(from: self)
    }
    
    func appendAsString(
        format: String = "yyyy-MM-dd'T'HH:mm:ss",
        timezone: TimeZone? = TimeZone.current
    ) -> String {
        let formatter = with(DateFormatter()) {
            $0.dateStyle = .short
            $0.dateFormat = format
            $0.timeZone = timezone
        }
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func string(format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func datePart(format: String = "dd MMM yyyy") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: formatter.string(from: self))!
    }
    
    func usingFormat(_ format: String = "dd MMM yyyy HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: formatter.string(from: self))!
    }
   
    func timeOnlyString(format: String = "HH:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var startOfMonth: Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    var endOfMonth: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func addMonths(_ numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func addMinutes(_ numberOfMinutes: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .minute, value: numberOfMinutes, to: self)
        return endDate ?? Date()
    }
    
    func addHours(_ numberOfHours: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .hour, value: numberOfHours, to: self)
        return endDate ?? Date()
    }
    
    func addDays(_ numberOfDays: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
        return endDate ?? Date()
    }
    
    func plus(_ number: Int, component: Calendar.Component) -> Date {
        Calendar.current.date(byAdding: component, value: number, to: self) ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    
    
    func time(since fromDate: Date) -> String {
        let earliest = self < fromDate ? self : fromDate
        let latest = (earliest == self) ? fromDate : self

        let allComponents: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components: DateComponents = Calendar.current.dateComponents(allComponents, from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0

        let descendingComponents = ["year": year, "month": month, "week": week, "day": day, "hour": hour, "minute": minute, "second": second]
        for (period, timeAgo) in descendingComponents {
            if timeAgo > 0 {
                return "\(timeAgo.of(period)) ago"
            }
        }

        return "Just now"
    }
    
    func timeBetween(endDate: Date, timeComponent: Calendar.Component) -> Int {
        let components = Calendar.current.dateComponents([timeComponent], from: self, to: endDate)
        var time: Int?
        switch timeComponent {
        case .hour:
            time = components.hour
        case .year:
            time = components.year
        case .month:
            time = components.month
        case .day:
            time = components.day
        case .minute:
            time = components.minute
        case .second:
            time = components.second
        case .nanosecond:
            time = components.nanosecond
        default:
            time = 0
        }
        return time ?? 0
    }
}

extension Int {
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}

extension String {
    func toDate(format: String = "dd MMM yyyy HH:mm a") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
    
    func displayDate(format: String = "dd MMM yy") -> String {
        let dateStringArray = self.components(separatedBy: "T")[0].components(separatedBy: "-")
        let date = Calendar.current.date(from: DateComponents(year: Int(dateStringArray[0]), month: Int(dateStringArray[1]), day: Int(dateStringArray[2])))
        
        return date?.toString(format: format) ?? ""
    }
    
    func displayTime() -> String {
        let timeStringArray = self.components(separatedBy: "T")[1].components(separatedBy: ":")
        return timeStringArray[0] + ":" + timeStringArray[1] + (Int(timeStringArray[0])! < 12 ? " AM" : " PM")
    }
    
    func isValidDate(format: String = DJConstants.dateFormat) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return dateFormatter.date(from: self).isNotNil
    }
}

func currentDate(format: String = "dd MMM yyyy HH:mm a") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    
    return dateFormatter.date(from: dateFormatter.string(from: Date()))!
}
