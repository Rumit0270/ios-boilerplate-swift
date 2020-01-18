//
//  KeyChainService.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/9/20.
//

import Foundation
import Locksmith

/// Enum with all the keys used to store data in KeyChain.
public enum KeyChainKeys: String {
    case accessToken = "com.example.keyChainKey.appAccessToken"
    case refreshToken = "com.example.keyChainKey.appRefreshToken"
}

/// Enum for all the Keychain services.
public enum KeyChainServices: String {
    case accessToken = "com.example.keyChainService.appAccessToken"
    case refreshToken = "com.example.keyChainService.appRefreshToken"
}

/// This is a helper class for interacting with the KeyChain service.
public class KeyChainHandler {
    
    // MARK: - Generic Keychain services
    class func save(for userAccount: String, inService: KeyChainServices, key: KeyChainKeys, value: Any) {
        do {
            try? Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: inService.rawValue)
            try Locksmith.saveData(data: [key.rawValue: value], forUserAccount: userAccount, inService: inService.rawValue)
        } catch let error {
            logger.error("Error saving in keychain: \(error)")
        }
    }
    
    class func load(for userAccount: String, inService: KeyChainServices, key: KeyChainKeys) -> Any? {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: userAccount, inService: inService.rawValue),
            let data = dictionary[key.rawValue] else {
                return nil
        }
        return data
    }
    
    class func updateData(for userAccount: String, inService: KeyChainServices, key: KeyChainKeys, value: Any) {
        do {
            try Locksmith.updateData(data: [key.rawValue: value], forUserAccount: userAccount, inService: inService.rawValue)
        } catch let error {
            logger.error("Error updating data in keychain: \(error)")
        }
    }
    
    class func deleteData(for userAccount: String, inService: KeyChainServices) {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: inService.rawValue)
        } catch let error {
            logger.error("Error deleting data from keychain: \(error)")
        }
    }
    
    // MARK: - Delete all the keychain data
    class func deleteAllKeys(for userAccount: String) {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: KeyChainServices.accessToken.rawValue)
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount, inService: KeyChainServices.refreshToken.rawValue)
        } catch let error {
            logger.error("Error deleting data from keychain: \(error)")
        }
    }
    
}
