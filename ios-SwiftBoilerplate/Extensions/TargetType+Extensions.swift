//
//  TargetType+Extensions.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/6/20.
//

import Foundation
import Moya

/// Extension with TargetType base configuations.
extension TargetType {
    
    var baseURL: URL {
        let url = AppConfig.DeploymentType.host
        return URL(string: url)!
    }
    
    var headers: [String: String]? {
        return getHeaders()
    }
    
    var sampleData: Data { return Data() }
    
    public var validationType: ValidationType {
        return .customCodes(Array(200..<300))
    }
}

extension TargetType {
    
    static private var baseHeaders: [String: String] {
        return [
            HTTPHeader.accept.rawValue: "application/json",
            HTTPHeader.contentType.rawValue: "application/json"
        ]
    }
    
    public func getHeaders() -> [String: String]? {
        // TODO: - Change the implementation to make userAccount dynamic.
//        if let accessToken = KeyChainHandler.load(for: "", inService: .accessToken, key: .accessToken) as? String {
//            var headers = Self.baseHeaders
//            headers[HTTPHeader.accessToken.rawValue] = "Bearer \(accessToken)"
//            return headers
//        }
        if let accessToken = UserDefaults.standard.string(forKey: UserDefaultKeys.accessToken) {
            var headers = Self.baseHeaders
            headers[HTTPHeader.accessToken.rawValue] = "Bearer \(accessToken)"
            return headers
        }

        return Self.baseHeaders
    }
    
    public func requestParameters(parameters: [String: Any]) -> Task {
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
    }
}
