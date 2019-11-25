//
//  LoginRequestRouter.swift
//  Worker App
//
//  Created by Aniruddha Kadam on 05/09/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation
import Alamofire

enum LoginRequestBuilder: URLRequestBuilder {    
    
    case getServerStatus(apiKey: String, function: String)
    case authorize(groupId: String, function: String, firebaseToken: String, mobileNumber: String)
    
    var protocolStr: String {
        return "https://"
    }
    
    var baseURL: String {
        return "\(KConstants.ProductionServer.baseURL)"
    }
    
    var authpath: String {
        return ""
    }
    
    var mainURL: URL {
        let urlString = "\(baseURL)"
        return URL(string: urlString)!
    }
    
    // MARK: - Path
    internal var path: String {
        return ""
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters()
        switch self {
        case .getServerStatus(let apiKey, let function):
            params["key"] = apiKey
            params["fn"] = function
        case .authorize(let groupId, let function, let firebaseToken, let mobileNumber):
            params["key"] = groupId
            params["fn"] = function
            params["token"] = firebaseToken
            params["phone"] = mobileNumber
        }
        return params
    }
    
    var additionalHttpHeaders: Parameters? {
        var params = Parameters()
        params["Content-Type"] = "application/json"
        return params
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        return .get
    }
}
