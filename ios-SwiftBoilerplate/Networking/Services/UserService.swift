//
//  UserService.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import Foundation

class UserService: BaseAPIService<UserResource> {
    
    static let sharedInstance = UserService()
    
    func fetchUsers(success: @escaping () -> Void,
                    failure: @escaping (Error?) -> Void) {
        request(for: .fetchUsers, onSuccess: { (users: [User], _) in
            
            var userObjects: [UserObject] = []
            for user in users {
                userObjects.append(UserObject(with: user))
            }
            
            RealmHelper.saveOrUpdateObjects(objects: userObjects, onSuccess: success, onFailure: failure)
        }, onFailure: { (error, _) in
            failure(error)
        })
    }
}
