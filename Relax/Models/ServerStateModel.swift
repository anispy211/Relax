//
//  ServerStateModel.swift
//  Relax
//
//  Created by Aniruddha Kadam on 24/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation

// MARK: - ServerStateBean
struct ServerStateBean: Codable {
    let status: String?
    let count: Int?
    let severity: Int?
    let items: [ServerPendingItemBean]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case count = "count"
        case severity = "severity"
        case items = "items"
    }
}

// MARK: - Item
struct ServerPendingItemBean: Codable {
    let id: Int?
    let name: String?
    let severity: Int?
    let downtime: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case severity = "severity"
        case downtime = "downtime"
    }
}
