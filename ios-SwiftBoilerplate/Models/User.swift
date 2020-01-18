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
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}
