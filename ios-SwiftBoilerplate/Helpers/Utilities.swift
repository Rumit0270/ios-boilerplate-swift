//
//  Utilities.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/7/20.
//

/// Various utilities and helper functions.
import Foundation

let stringLanguage = "en"

class Utilities: NSObject {
    
}

// MARK: - Localization Helpers
public func localizedString(_ key: String) -> String {
    return NSLocalizedString(key, tableName: stringLanguage, comment: "")
}

public func localizeLater(string: String) -> String {
    return string
}

// MARK: - Delay helpers
public func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

public func mainQueue(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

public func backgroundQueue(_ block: @escaping () -> Void) {
    let dispatchQueue = DispatchQueue(label: "background", qos: .background)
    dispatchQueue.async(execute: block)
}

/// Print JSON data from an object.
public func printJSON(_ object: [String: AnyObject]) {
    do {
        let data = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let string = String(data: data, encoding: .utf8) {
            print("\(string)")
        }
    } catch let error {
        logger.error("Error parsing JSON: \(error)")
    }
}

/// Reads a JSON file and returns its JSON representation.
public func getDataFromJSON(filename: String) -> Data {
    guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
        return Data()
    }
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    } catch {
        logger.error("Error reading file \(filename).json")
        return Data()
    }
}
