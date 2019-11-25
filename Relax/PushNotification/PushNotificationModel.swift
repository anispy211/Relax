//
//  PushNotificationMessage.swift
//  SPCMobile
//
//  Created by Aniruddha Kadam on 15/09/19.
//  Copyright © 2019 Ridecell. All rights reserved.
//

import Foundation

class APNSModel: NSObject {

    var title: String?
    var body: String?
    var sound: String?
    
    override init() {
        super.init()
    }
    
    convenience init(withDataDict dictionary: [String: AnyObject]) {
        self.init()
        
        if let alert = dictionary["alert"] as? [String: AnyObject], let title = alert["title"] as? String, let body = alert["body"] as? String {
            
            self.title = title
            self.body = body
        }
        
        if let thisSound = dictionary["sound"] as? String {
            self.sound = thisSound
        }
    }
}

class PushNotificationMessage: NSObject {
    var aps: APNSModel?
    var id: String?
    var recipientID: String?
    var eventType: NotificationEvent = .none
    var entityId: String?
    var entityType: String?
    
    override init() {
        super.init()
    }
    
    convenience init(withDataDict dictionary: [String: AnyObject]) {
        self.init()
        
        if let thisDict = dictionary["aps"] as? [String: AnyObject] {
            self.aps = APNSModel(withDataDict: thisDict)
        }
        
        if let eventType = dictionary["message_subject"] as? String {
            if let type = NotificationEvent(rawValue: eventType) {
                self.eventType = type
            } else {
                self.eventType = .none
            }
        }
        
        if let recipient = dictionary["recipient"] as? String {
            self.recipientID = recipient
        }
        
        if let entityId = dictionary["entity_id"] as? String {
            self.entityId = entityId
        }
        
        if let entityTypeValue = dictionary["entity_type"] as? String {
            self.entityType = entityTypeValue
        }
    }
}
