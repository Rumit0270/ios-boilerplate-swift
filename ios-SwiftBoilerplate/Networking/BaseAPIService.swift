//
//  BaseAPIService.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/6/20.
//

import Foundation
import Moya

public enum HTTPHeader: String {
    case expiry = "expiry"
    case accept = "Accept"
    case contentType = "Content-Type"
    case accessToken = "Authorization"
    case refreshToken = "refresh-token"
}

struct StatusCode {
    static let unauthorized = 401
}

enum ErrorMessage: String {
    case invalidAccessToken = "INVALID ACCESS TOKEN"
}

/**
 Public protocol that defines the minimum configurations that an APIService should expose.
 The APIService is the component in charge of handling all network request for
 an specific TargetType.
 */
public protocol APIService {
    
    /// The associated TargetType of the Service.
    associatedtype ProviderType: TargetType
    /// The MoyaProvider instance used to make the network requests.
    var provider: MoyaProvider<ProviderType> { get }
    /// The JSON decoding strategy to be used for JSON Responses.
    var jsonDecoder: JSONDecoder { get }
}

/**
 Base ApiService class that implements generic behaviour to
 be extended and used by subclassing it.
 The base service has an associated TargetType, this means
 that you should have **one and only one** manager for each TargetType.
 This base implementation provides helpers to make requests with automatic
 encoding if you provide a proper model as the expected result type.
 The model for result type however has to conform to the Decodable Protocol.
 */
public class BaseAPIService<T>: APIService where T: TargetType {
    
    public typealias ProviderType = T
    
    public typealias SuccessHandlerWithType<P> = (_ result: P, _ response: Response) -> Void
    public typealias SuccessHandlerWithResponse = (_ response: Response) -> Void
    public typealias FailureHandler = (Error, Response?) -> Void
    
    private var sharedProvider: MoyaProvider<T>!
    
    private var sharedAuthProvider: MoyaProvider<Auth>!
    
    /**
     Configure Moya middleware for logging requests and responses.
     */
    private var plugins: [PluginType] {
        return [
            NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter(_:))
        ]
    }
    
    /**
     Default provider implementation as a singleton. Override this var to add more
     middlewares.
     */
    public var provider: MoyaProvider<T> {
        guard let provider = sharedProvider else {
            sharedProvider = MoyaProvider<T>(plugins: plugins)
            return sharedProvider
        }
        return provider
    }
    
    /// Auth provider implementaion as a singleton. Used to make subsequent request
    /// in case of access token expiration.
    private var authProvider: MoyaProvider<Auth> {
        guard let provider = sharedAuthProvider else {
            sharedAuthProvider = MoyaProvider<Auth>(plugins: [])
            return sharedAuthProvider
        }
        return provider
    }
    
    /**
     Default JSON decoder setup, uses the most common case of keyDecoding,
     converting from camel_case to snakeCase before attempting to match
     override this var if you need to customize your JSON decoder.
     */
    open var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
    
    public required init() {}
    
    init(mock: Bool = false) {
        if mock {
            sharedProvider = MoyaProvider<T>(stubClosure: MoyaProvider.immediatelyStub)
            sharedAuthProvider = MoyaProvider<Auth>(stubClosure: MoyaProvider.immediatelyStub)
        }
    }
    
    /**
     Makes a request to the provided target and tries to decode its response
     using the provided keyPath and return type and returning it on the onSuccess callback.
     - Parameters:
     - target: The TargetType used to make the request.
     - P: Return type after decoding.
     - onSuccess: Success Handler of type (_ result: P, _ response: Response) -> Void
     - onFailure: Failure Handler of type (Error, Response?) -> Void
     - keyPath: The keypath used to decode from JSON (if passed nil,
     it will try to decode from the root).
     */
    public func request<P>(for target: ProviderType,
                           at keyPath: String? = nil,
                           onSuccess: @escaping SuccessHandlerWithType<P>,
                           onFailure: FailureHandler? = nil) where P: Codable {
        provider.request(target) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case let .success(moyaResponse):
                self.handleSuccess(with: moyaResponse, at: keyPath, onSuccess: onSuccess, onFailure: onFailure)
            case let .failure(error):
                //self.handleError(with: error, onFailure)
                if self.isCurrentAccessTokenInvalid(error: error) {
                    self.renewAccessToken({
                        self.request(for: target, at: keyPath, onSuccess: onSuccess, onFailure: onFailure)
                    }, {
                        self.handleError(with: error, onFailure)
                    })
                } else {
                    self.handleError(with: error, onFailure)
                }
            }
        }
    }
    
    /**
     Makes a request to the provided target and returns the bare response without decoding.
     - Parameters:
     - target: The TargetType used to make requests.
     - onSuccess: Success Handler of type (_ response: Response) -> Void
     - onFailure: (Error, Response?) -> Void
     */
    public func request(for target: ProviderType,
                        onSuccess: @escaping SuccessHandlerWithResponse,
                        onFailure: FailureHandler? = nil) {
        provider.request(target) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case let .success(moyaResponse):
                onSuccess(moyaResponse)
            case let .failure(error):
                //self.handleError(with: error, onFailure)
                if self.isCurrentAccessTokenInvalid(error: error) {
                    // Make an API call to fetch the new access token.
                    self.renewAccessToken({
                        self.request(for: target, onSuccess: onSuccess, onFailure: onFailure)
                    }, {
                        self.handleError(with: error, onFailure)
                    })
                } else {
                    self.handleError(with: error, onFailure)
                }
            }
        }
    }
    
    // MARK: Success and Failure handlers
    private func handleSuccess<T>(with response: Response,
                                  at keyPath: String? = nil,
                                  onSuccess: @escaping SuccessHandlerWithType<T>,
                                  onFailure: FailureHandler? = nil) where T: Decodable {
        do {
            // use filterSuccessfulStatusAndRedirectCodes method to include redirects
            let filteredResponse = try response.filterSuccessfulStatusCodes()
            let decodedresult = try filteredResponse.map(T.self,
                                                         atKeyPath: keyPath,
                                                         using: jsonDecoder,
                                                         failsOnEmptyData: false)
            onSuccess(decodedresult, filteredResponse)
        } catch let error {
            self.handleError(with: error, onFailure)
        }
    }
    
    private func handleError(with error: Error, _ onFailure: FailureHandler? = nil) {
        guard let moyaError = error as? MoyaError else {
            onFailure?(error, nil)
            return
        }
        
        switch moyaError {
        case .statusCode(let response):
            onFailure?(error, response)
        case .stringMapping(let response),
             .jsonMapping(let response),
             .imageMapping(let response):
            onFailure?(error, response)
        case .objectMapping(let mappingError, let response):
            onFailure?(mappingError, response)
        case .encodableMapping(let error), .parameterEncoding(let error):
            onFailure?(error, nil)
        case .underlying(let underlyingError, let response):
            onFailure?(underlyingError, response)
        case .requestMapping:
            onFailure?(error, nil)
        }
    }
    
    /**
     Makes a subsequent request in case of API error due to expired access token.
     - Parameters:
     - success: Success handler to be invoked after successfully refreshing the access token.
     The success handler invokes the previously failed API call with the new valid access token.
     - failure: Failure handler to be invoked if new access token is not obtained.
     */
    private func renewAccessToken(_ success: @escaping () -> Void,
                                  _ failure: @escaping () -> Void) {
        //TODO: - Provide userAccount dynamically
        authProvider.request(.renewAccessToken(userAccount: "")) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes().mapJSON()
                    guard let responseObject = filteredResponse as? [String: String],
                        let accessToken = responseObject["accessToken"] else {
                            failure()
                            return
                    }
//                    KeyChainHandler.save(for: "", inService: .accessToken, key: .refreshToken, value: accessToken)
                    
                    UserDefaults.standard.setValue(accessToken, forKey: UserDefaultKeys.accessToken)
                    success()
                } catch {
                    failure()
                }
            case .failure:
                failure()
            }
        }
    }
    
    // MARK: - Base API class helpers
    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(
                withJSONObject: dataAsJSON, options: .prettyPrinted
            )
            return prettyData
        } catch {
            return data
        }
    }
    
    private func isCurrentAccessTokenInvalid(error: Error) -> Bool {
        guard let moyaError = error as? MoyaError,
            let statusCode = moyaError.response?.statusCode,
            let errorBody = try? moyaError.response?.mapJSON() else {
                return false
        }
        
        guard let errorObject = errorBody as? [String: String],
            statusCode == 401 else {
                return false
        }
        
        guard let errorMessage = errorObject["error"],
            errorMessage.uppercased().contains(ErrorMessage.invalidAccessToken.rawValue)
            else {
                return false
        }
        
        return true
    }
    
}
