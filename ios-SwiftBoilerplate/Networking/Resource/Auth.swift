//
//  Auth.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/13/20.
//

import Foundation
import Moya

struct LoginModel: Codable {
    let username: String
    let password: String
}

/// Authentication resource for handling user authorization and authentication.
enum Auth {
    case login(loginModel: LoginModel)
    case renewAccessToken(userAccount: String)
}

extension Auth: TargetType {
    
    public var path: String {
        switch self {
        case .login:
            return APIEndpoints.login
        case .renewAccessToken:
            return APIEndpoints.renewAccessToken
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .renewAccessToken:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .login(let body):
            return .requestJSONEncodable(body)
        case .renewAccessToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .renewAccessToken(let userAccount):
            // TODO: - Use keychain instead of User Default
//            if var headers = getHeaders(),
//                let refreshToken = KeyChainHandler.load(for: userAccount, inService: .refreshToken, key: .refreshToken) as? String {
//                headers[HTTPHeader.refreshToken.rawValue] = refreshToken
//                return headers
//            }
            if var headers = getHeaders(),
                let refreshToken = UserDefaults.standard.string(forKey: UserDefaultKeys.refreshToken) {
                headers[HTTPHeader.refreshToken.rawValue] = refreshToken
                return headers
            }

            return getHeaders()
        default:
            return getHeaders()
        }
    }
    
}
