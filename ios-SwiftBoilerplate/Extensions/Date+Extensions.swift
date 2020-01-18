//
//  Date+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/15/20.
//

import Foundation

/// Date Converters
extension Date {
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Date {
    
    func getStringValue(dateFormat: String) -> String? {
        let dateFormattter = DateFormatter()
        dateFormattter.dateFormat = dateFormat
        return dateFormattter.string(from: self)
    }
    
}
