//
//  RealmHelper.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 2/8/20.
//

import Foundation
import RealmSwift

/// Custom Error struct for Realm.
struct RealmError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}

class RealmHelper: NSObject {
    
    static func saveObject<T: Object>(object: T,
                                      onSuccess: @escaping () -> Void,
                                      onFailure: @escaping (Error?) -> Void) {
        backgroundQueue {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(object)
                    }
                    mainQueue {
                        onSuccess()
                    }
                } catch let error {
                    logger.error("Could not save object: \(error).")
                    mainQueue {
                        onFailure(error)
                    }
                }
            }
        }
    }
    
    static func saveObjects<T: Object>(objects: [T],
                                       onSuccess: @escaping () -> Void,
                                       onFailure: @escaping (Error?) -> Void) {
        backgroundQueue {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(objects)
                    }
                    mainQueue {
                        onSuccess()
                    }
                } catch let error {
                    logger.error("Could not save objects: \(error).")
                    mainQueue {
                        onFailure(error)
                    }
                }
            }
        }
    }
    
    static func saveOrUpdateObject<T: Object>(object: T,
                                              onSuccess: @escaping () -> Void,
                                              onFailure: @escaping (Error?) -> Void) {
        autoreleasepool {
            backgroundQueue {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(object, update: .modified)
                    }
                    mainQueue {
                        logger.info("OBJECT SAVE SUCCESS")
                        onSuccess()
                    }
                } catch let error as NSError {
                    logger.error("Could not save or update object: \(error).")
                    mainQueue {
                        onFailure(error)
                    }
                }
                
            }
            
        }
    }
    
    static func saveOrUpdateObjects<T: Object>(objects: [T],
                                               onSuccess: @escaping () -> Void,
                                               onFailure: @escaping (Error?) -> Void ) {
        autoreleasepool {
            backgroundQueue {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(objects, update: .all)
                    }
                    mainQueue {
                        onSuccess()
                    }
                } catch let error {
                    logger.error("Could not save objects: \(error).")
                    mainQueue {
                        onFailure(error)
                    }
                }
            }
            
        }
    }
    
    static func fetchObjects<T: Object>(
        predicate: NSPredicate? = nil,
        onSuccess: @escaping (_ results: Results<T>) -> Void,
        onFailure: @escaping (Error?) -> Void) {
        
        autoreleasepool {
            backgroundQueue {
                do {
                    let realm = try Realm()
                    var results: Results<T>?
                    if let predicate = predicate {
                        results = realm.objects(T.self).filter(predicate)
                    } else {
                        results = realm.objects(T.self)
                    }
                    
                    guard let queryResults = results else {
                        logger.error("Failed to unwrap the moya results.")
                        throw RealmError("Failed to unwrap the moya results.")
                    }
                    
                    let resultsRef = ThreadSafeReference(to: queryResults)
                    mainQueue {
                        do {
                            let mainRealm = try Realm()
                            guard let results = mainRealm.resolve(resultsRef) else {
                                logger.error("Could not resolve the Result reference.")
                                return
                            }
                            onSuccess(results)
                        } catch let error {
                            logger.error("Error instantiating Realm in the main thread.")
                            onFailure(error)
                        }
                    }
                } catch let error {
                    logger.error("Could not fetch objects: \(error).")
                    mainQueue {
                        onFailure(error)
                    }
                }
            }
        }
    }
    
    /// Delete all the Realm data.
    static func deleteAll(
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (Error?) -> Void) {
        
        autoreleasepool {
            backgroundQueue {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.deleteAll()
                    }
                    mainQueue {
                        onSuccess()
                    }
                } catch let error {
                    logger.error("Could not delete the realm data: \(error).")
                    mainQueue {
                        onFailure(error)
                    }
                }
                
            }
            
        }
        
    }
}
