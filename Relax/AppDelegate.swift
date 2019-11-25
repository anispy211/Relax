//
//  AppDelegate.swift
//  Relax
//
//  Created by Aniruddha Kadam on 07/11/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var gcmMessageIDKey = "gcm.message_id"
       var instanceIDTokenMessage: String?
    var applicationObj: UIApplication?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        applicationObj = application
        registerForPushNotifications(application)
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        applicationObj = application
        registerForPushNotifications(application)
    }
}

