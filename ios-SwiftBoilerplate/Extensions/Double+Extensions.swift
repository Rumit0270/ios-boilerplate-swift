//
//  Double+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/15/20.
//

import Foundation

extension Double {
    
    var localDateValue: Date? {
        get {
            let date = Date(timeIntervalSince1970: self)
            return date.toLocalTime()
        }
    }
}
