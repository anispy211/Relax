//
//  User.swift
//  Relax
//
//  Created by Aniruddha Kadam on 24/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation

class User {
static let shared = User()
    var authToken: String?
    var deviceToken: String?
}
