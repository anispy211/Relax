//
//  APIConfiguration.swift
//  Worker App
//
//  Created by Aniruddha Kadam on 04/09/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation
import Alamofire

/// Response completion handler beautified.
typealias CallRCResponse<T> = ((RCResponse<T>) -> Void)?

extension JSONDecoder {
    public static var snakeCaseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

class RCNetworkManager: HandleAlamoResponse {
    
    static let sharedInstance: RCNetworkManager = {
        let instance = RCNetworkManager()
        return instance
    }()
    
    private var sessionManager: SessionManager!
    // TODO: Refactor later. We need to be able to make multiple request, without a previous request
    // being cancelled.
    private func getSessionManager(_ request: URLRequestBuilder) -> DataRequest {
        if let sharedsession = sessionManager {
            return sharedsession.request(request)
        } else {
            sessionManager = SessionManager.default
            return sessionManager!.request(request)
        }
    }
    
    // Request for API without JSON response (Non-Codable response)
    func request(_ request: URLRequestBuilder, then: CallRCResponse<Any>) {
        // request.
        let dataRequest = getSessionManager(request)
        dataRequest.validate().responseJSON(completionHandler: { (response) in
            print(response)
            self.handleResponseForRequest(response, then: then)
        })
    }
    
    func send(_ request: URLRequestBuilder, data: UploadData? = nil, progress: ((Progress) -> Void)? = nil, then: CallRCResponse<Any>) {
            if let data = data {
                uploadToServerWith(data: data, request: request, parameters: request.parameters, progress: progress, then: then)
            } else {
                // request.
                let dataRequest = getSessionManager(request)
                dataRequest.validate().responseData(completionHandler: { (response) in
                }).responseJSON(completionHandler: { [weak self] (response) in
                    // handle debug
                    self?.handleResponseForRequest(response, then: then)
                })
        }
    }
    
    private func uploadToServerWith(data: UploadData, request: URLRequestConvertible, parameters: Parameters?, progress: ((Progress) -> Void)?, then: CallRCResponse<Any>) {
        
        upload(multipartFormData: { (mul) in
            mul.append(data.data, withName: data.name, fileName: data.fileName, mimeType: data.mimeType)
            guard let parameters = parameters else { return }
            for (key, value) in parameters {
                mul.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, with: request) { (response) in
            switch response {
            case .success(let requestUp, _, _):
                requestUp.responseData(completionHandler: { (results) in
                }).responseJSON(completionHandler: { [weak self] (response) in
                    // handle debug
                    self?.handleResponseForRequest(response, then: then)
                })
                
            case .failure(let error):
                then?(RCResponse.failure(error))
            }
        }
    }
}
