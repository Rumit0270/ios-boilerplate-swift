//
//  User.swift.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/18/20.
//

import Foundation
import Moya

enum UserResource {
    case fetchUsers
}

extension UserResource: TargetType {
    
    var path: String {
        switch self {
        case .fetchUsers:
            return APIEndpoints.users
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchUsers:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .fetchUsers:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .fetchUsers:
            return getDataFromJSON(filename: "users")
        }
    }
    
}
