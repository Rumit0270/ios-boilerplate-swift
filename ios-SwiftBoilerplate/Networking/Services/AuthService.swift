//
//  AuthService.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/13/20.
//

import Foundation

/// Class handling all the authentication related tasks for the user.
class AuthService: BaseAPIService<Auth> {
    
    static let sharedInstance = AuthService()
    
    func login(body: LoginModel, _ success: @escaping () -> Void,
               _ failure: @escaping () -> Void) {
        
        request(for: .login(loginModel: body), onSuccess: { (moyaResponse) in
            do {
                let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes().mapJSON()
                guard let responseObject = filteredResponse as? [String: String] else {
                    logger.error("Error while parsing the login response.")
                    failure()
                    return
                }

                guard let accessToken = responseObject["accessToken"],
                    let refreshToken = responseObject["refreshToken"] else {
                        logger.error("No valid access token or refresh token received on login response.")
                        failure()
                        return
                }
                
                // TODO: - Store the tokens in KeyChain instead.
                UserDefaults.standard.setValue(accessToken, forKey: UserDefaultKeys.accessToken)
                UserDefaults.standard.setValue(refreshToken, forKey: UserDefaultKeys.refreshToken)
                success()
            } catch {
                failure()
            }
        }) { (error, response) in
            logger.error("Error logging in: \(error).")
            logger.error("Failure response is: \(String(describing: response))")
            failure()
        }
        
    }
    
}
