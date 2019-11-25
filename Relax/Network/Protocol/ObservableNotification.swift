//
//  ObservableNotification.swift
//  Worker App
//
//  Created by Aniruddha Kadam on 15/09/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation

public protocol ObservableNotificationDelegate: class {
    func notification(didPost observableNotification: ObservableNotification)
}

public protocol RCObserver {
    func dispose()
}

public protocol ObservableNotification {
    
    var notificationCenter: NotificationCenter { get }
    var name: Notification.Name { get }
    var object: Any? { get }
    var userInfo: [AnyHashable: Any]? { get }
    
    init?(notification: Notification)
    
    func observe(delegate: ObservableNotificationDelegate) -> RCObserver
    
    func post()
    
}

public extension ObservableNotification {
    
    var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    func observe(delegate: ObservableNotificationDelegate) -> RCObserver {
        let observer = notificationCenter.addObserver(
            forName: self.name,
            object: self.object,
            queue: nil
        ) { [weak delegate] notification in
            if let observableNotification = Self(notification: notification) {
                delegate?.notification(didPost: observableNotification)
            }
        }
        return RCNotificationObserver(observer: observer, notification: self)
    }
    
    func post() {
        notificationCenter.post(name: name, object: object, userInfo: userInfo)
    }
    
}

class RCNotificationObserver: RCObserver {
    
    weak var observer: NSObjectProtocol?
    var notification: ObservableNotification
    
    init(observer: NSObjectProtocol, notification: ObservableNotification) {
        self.observer = observer
        self.notification = notification
    }
    
    func dispose() {
        notification.notificationCenter.removeObserver(observer as Any)
        observer = nil
    }
    
}
