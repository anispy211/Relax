//
//  Constants.swift
//   Worker App
//
//  Created by Aniruddha Kadam on 2/9/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit
import CoreLocation

struct KConstants {
    struct ProductionServer {
        static let baseURL = "https://api.relax.net"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

// MARK: - Date
enum DateFormat {
    
    case day
    case dayOfWeek
    case month
    case YYYY
    case ddMMYYYY
    case ddMMYYYYHHmm
    case ddMMYYYYhhmma
    case serverISO
    case serverISOShort
    case time12Hour
    
    var format: String {
        switch self {
        case .day: return "dd"
        case .dayOfWeek: return "EEEE"
        case .month: return "MM"
        case .YYYY: return "YYYY"
        case .ddMMYYYY: return "dd/MM/YYYY"
        case .ddMMYYYYHHmm: return "dd/MM/YYYY HH:mm"
        case .ddMMYYYYhhmma: return "dd/MM/YYYY hh:mm a"
        case .serverISO: return "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        case .serverISOShort: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .time12Hour: return "hh:mm a"
        }
    }
}

enum ServerStatus {
    case good
    case warning
    case danger
}

struct Constants {
    
    static let goodColor = #colorLiteral(red: 0.5544208884, green: 0.8115461469, blue: 0.3286285996, alpha: 1)
    static let warningColor = #colorLiteral(red: 0.9423475862, green: 0.7137446404, blue: 0, alpha: 1)
    static let dangerColor = #colorLiteral(red: 0.9992548823, green: 0.4393817186, blue: 0.2791463137, alpha: 1)

    // Should this really be here?
  //  static let allowPinCertificates = Environment().configuration(Plist.isSslPinningEnabled).toBool()
    static let defaultPageSize = 12
    static let screenSize = UIScreen.main.bounds.size
    static let isIPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad ? true : false)
    
    struct NotificationsKeys {
        static let locationUpdated = NSNotification.Name(rawValue: "location_updated")
    }
    
    struct Keys {
        static let AuthToken: String = "auth_token"
        static let AuthTokenValidFrom: String = "auth_token_valid_from"
        static let AuthTokenExpiry: String = "auth_token_expiry"
        static let TenantID: String = "tenanat_id"
        static let UserId: String = "user_id"
        static let UserName: String = "user_name"
        static let ServiceRegionID: String = "service_region_id"
        static let ServiceName: String = "service_name"
        static let SelectedVehcileID: String = "selcted_vehcile_ID"
        static let IsSelfVehcile: String = "is_self_vehcile"
    }
}

struct RCBlocks {

    // MARK: - Blocks
    typealias ResultBlock = (_ success: Bool, _ result: AnyObject?) -> Void
    typealias ActionBlock = (_ sender: AnyObject?) -> Void
    typealias ReturnBlock = () -> AnyObject?
    typealias WithParamReturnBlock = (_ result: AnyObject?) -> AnyObject?
    typealias VoidBlock = () -> Void
    typealias UpdateActionBlock = (_ result: AnyObject, _ cond: Bool) -> Void
    typealias ResultActionBlock = (_ sender: AnyObject?, _ result: AnyObject?) -> Void
    typealias CompletionBlock = (_ success: Bool, _ result: AnyObject?, _ error: Error?) -> Void
    typealias FinishedBlock = (_ finished: Bool) -> Void
    typealias BoolReturnBlock = () -> Bool
    typealias ArrayReturnBlock = () -> [AnyObject]
    typealias DictionaryReturnBlock = () -> [String: AnyObject]
    typealias NumberReturnBlock = () -> NSNumber?
   // typealias FailureBlock = (ErrorUtil?) -> Void
}

struct RidecellGCD {
    // MARK: - GCD related
    static func bgQueue(queueName: String, completion codeBlock: @escaping RCBlocks.FinishedBlock) {
        DispatchQueue.global(qos: .background).async {
            codeBlock(true)
        }
    }

    static func mainQueue(codeBlock: @escaping RCBlocks.FinishedBlock) {
        DispatchQueue.main.async {
            codeBlock(true)
        }
    }
}


