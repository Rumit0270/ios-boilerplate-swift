//
//  UserViewModel.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import Foundation
class UserViewModel {
    
    var users: Box<[User]> = Box([])
        
    func fetchUsers() {
        UserService.sharedInstance.fetchUsers(success: { (users) in
            self.users.value = users
        }) { (error) in
            logger.error("Error fetching users: \(error)")
        }
    }
}
