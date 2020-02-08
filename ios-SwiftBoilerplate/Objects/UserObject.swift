//
//  UserObject.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 2/8/20.
//

import Foundation
import RealmSwift

class CompanyObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var catchPhrase: String = ""
    @objc dynamic var bs: String = ""
    
    convenience init(with company: Company) {
        self.init()
        self.name = company.name
        self.catchPhrase = company.catchPhrase
        self.bs = company.bs
    }
}

class UserObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var company: CompanyObject?
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    override static func indexedProperties() -> [String] {
        return ["email"]
    }
    
    convenience init(with user: User) {
        self.init()
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.phone = user.phone
        self.website = user.website
        if let aCompany = user.company {
            self.company = CompanyObject(with: aCompany)
        }
    }
}
