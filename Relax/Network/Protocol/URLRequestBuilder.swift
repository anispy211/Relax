//
//  RequestBuilderProtocol.swift
//  Worker App
//
//  Created by Aniruddha Kadam on 04/09/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation
import Alamofire

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

protocol URLRequestBuilder: URLRequestConvertible, HandleAlamoResponse {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: String { get }
    
    // MARK: - Parameters
    var parameters: Parameters? { get }
    
    // MARK: - additionalHttp Parameters
    var additionalHttpHeaders: Parameters? { get }
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
}

extension URLRequestBuilder {
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var mainURL: URL {
        let baseURL = KConstants.ProductionServer.baseURL
//        let tenantID = User.shared.tenantID
//        if tenantID.isEmpty {
//            let urlString = "\(protocolStr)\(baseURL)"
//            return URL(string: urlString)!
//        }
        let urlString = "\(baseURL)"
        return URL(string: urlString)!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    private func makeURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: requestURL, method: method, headers: nil)
        if let param = parameters {
            request = try  encoding.encode(request, with: param)
        }
        if let additionalHeaders = additionalHttpHeaders {
            for header in additionalHeaders {
                guard let value = header.value as? String else { continue }
                request.setValue(value, forHTTPHeaderField: header.key)
            }
        }
        request.cachePolicy = .reloadIgnoringCacheData
        return request
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try makeURLRequest()
    }
}
