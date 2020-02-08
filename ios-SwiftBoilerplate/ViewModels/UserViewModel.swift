//
//  UserViewModel.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import Foundation
import RealmSwift

class UserViewModel {
    
    var users: Box<[User]> = Box([])
        
    func fetchUsers() {
        UserService.sharedInstance.fetchUsers(success: { [weak self] in
            guard let self = self else { return }
            self.setUsers()
        }, failure: { (error) in
            logger.error("Error fetching users: \(String(describing: error))")
        })
    }
    
    /// Function to set the ViewModel data by fetching data from the local Realm database.
    func setUsers() {
        RealmHelper.fetchObjects(onSuccess: { [weak self] (results: Results<UserObject>) in
            guard let self = self else { return }
            var aUsers: [User] = []
            
            for result in results {
                aUsers.append(User(with: result))
            }
            self.users.value = aUsers
        }, onFailure: { (error) in
            if let error = error {
                logger.error("Error fetching the UserObjects: \(error)")
            }
        })
    }
}
