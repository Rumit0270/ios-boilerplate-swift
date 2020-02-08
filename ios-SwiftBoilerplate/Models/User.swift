//
//  StockPoint.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/14/20.
//

import Foundation

/// Model representing an individual User.
struct User: Codable {
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    var company: Company? = nil
    
    init(with object: UserObject) {
        self.name = object.name
        self.username = object.username
        self.email = object.email
        self.phone = object.phone
        self.website = object.website
        if let aCompany = object.company {
            self.company = Company(with: aCompany)
        }
    }
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
    
    init(with object: CompanyObject) {
        self.name = object.name
        self.catchPhrase = object.catchPhrase
        self.bs = object.bs
    }
}
