//
//  PlistReader.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 2/8/20.
//

import Foundation

/**
 Helper class to read values from .plist file.
 - Parameters:
 - for: The key to read from Plist file.
 - on: Plist filename.
 - returns an optional wrapping the read value..
 */
class PlistReader: NSObject {
    
    class func getValue(for key: String, on fileName: String) -> Any? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                logger.error("Could not read the contents of the \(fileName).plist")
                return nil
        }
        
        guard let value = dict[key] else {
            logger.error("Could not find \(key) field in \(fileName).plist.")
            return nil
        }
        
        return value
    }
}
