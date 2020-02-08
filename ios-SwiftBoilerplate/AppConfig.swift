//
//  AppConfig.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/7/20.
//

import Foundation

/// Class to Set all the environment related configs.
public class AppConfig: NSObject {
    
    struct DeploymentType {
        static let host = APIURL.development
    }
    
    /// Realm filename to store data.
    static let LocalDB = "test"
}
