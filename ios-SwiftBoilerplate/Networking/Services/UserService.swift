//
//  UserService.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import Foundation

class UserService: BaseAPIService<UserResource> {
    
    static let sharedInstance = UserService()
    
    func fetchUsers(success: @escaping ([User]) -> Void,
                    failure: @escaping (_ error: Error) -> Void) {
        request(for: .fetchUsers, onSuccess: { (users: [User], _) in
            success(users)
        }) { (error, moyaResponse) in
            failure(error)
        }
    }
}
