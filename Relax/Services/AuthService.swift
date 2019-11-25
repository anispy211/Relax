//
//  AuthService.swift
//  Relax
//
//  Created by Aniruddha Kadam on 24/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation

class AuthService {

    // MARK: - Signin Request
    static func doSigninRequest(groupID: String, phoneNumber: String, deviceToken: String, successCompletion: ((String?) -> Void)?, failureCompletion: ((Error?) -> Void)?) {
        var responseHandler: HandleRCResponse {
                  return { (response) in
                      switch response {
                      case .failure(let error):
                          failureCompletion?((error))
                      case .success(let value):
                          if let dictionary = value as? [String: Any], let status = dictionary["status"] as? String, let apiKey = dictionary["api_key"] as? String, status == "OK"  {
                                successCompletion?(apiKey)
                          } else {
                            failureCompletion?((nil))
                        }
                      }
                  }
              }
        
        let request = LoginRequestBuilder.authorize(groupId: groupID, function: "SUBSCRIBE", firebaseToken: deviceToken, mobileNumber: phoneNumber)
        RCNetworkManager.sharedInstance.request(request, then: responseHandler)
    }
    
    // MARK: - Server Status Request
    static func doServerStatusRequest(apiKey: String, successCompletion: ((ServerStateBean?) -> Void)?, failureCompletion: ((Error?) -> Void)?) {
        var responseHandler: HandleRCResponse {
                  return { (response) in
                      switch response {
                      case .failure(let error):
                          failureCompletion?((error))
                      case .success(let value):
                         if let dictionary = value as? [String: Any] {
                             do {
                                 let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
                                 let serverStateBean = try JSONDecoder().decode(ServerStateBean.self, from: jsonData)
                                 successCompletion?(serverStateBean)
                             } catch {
                                 failureCompletion?((error))
                             }
                         }

                      }
                  }
              }
        
        let request = LoginRequestBuilder.getServerStatus(apiKey: apiKey, function: "UPDATE")
        RCNetworkManager.sharedInstance.request(request, then: responseHandler)
    }
    
}
