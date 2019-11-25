//
//  ResponseHandler.swift
//  Worker App
//
//  Created by Aniruddha Kadam on 04/09/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation
import Alamofire

typealias HandleRCResponse = (RCResponse<Any>) -> Void

public enum RCResponse<Value> {
    case success(Any)
    case failure(Error)
}

protocol HandleAlamoResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponseForRequest(_ response: DataResponse<Any>, then: CallRCResponse<Any>)
}

extension HandleAlamoResponse {
    func handleResponseForRequest(_ response: DataResponse<Any>, then: CallRCResponse<Any>) {
        RidecellGCD.mainQueue(codeBlock: {_ in
            switch response.result {
            case .failure(let error):
                then?(RCResponse.failure(error))
            case .success(let value):
                then?(RCResponse.success(value))
            }
        })
    }
}
