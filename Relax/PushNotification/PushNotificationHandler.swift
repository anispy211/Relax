//
//  PushNotificationHandler.swift
//  SPCMobile
//
//  Created by Aniruddha Kadam on 15/09/19.
//  Copyright © 2019 Ridecell. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
/**
 * Anyone who inherits this protocol conforms to the push notification
 * handler protocol and will be expected to know how to handle push
 * notification events.
 */
protocol PushNotificationHandlerProtocol {
    func onNotificationEventReceived(event: NotificationEvent, body: String?)
}

class PushNotification: NSObject {

    static let kAFMDeviceId = "kAFMDeviceId"
    static let kFirebaseConfigDataFile = "GoogleService-Info.plist"
    
    static let sharedInstance: PushNotification = {
        let instance = PushNotification()
        return instance
    }()
    
    var afmDeviceId: String? {
        get {
            if let thisValue = UserDefaults.standard.string(forKey: PushNotification.kAFMDeviceId) {
                return thisValue
            } else {
                return nil
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PushNotification.kAFMDeviceId)
        }
    }
    
    func getPushServiceFilePath() -> String {
        let fileManager = FileManager.default
        let docsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let spcDocURL = docsURL.appendingPathComponent("WorkerApp")
        return spcDocURL.appendingPathComponent(PushNotification.kFirebaseConfigDataFile).path
    }
    
    func registerDeviceForPushNotification() {
        // TOOD: AHHHHHHHHHHHHHHH What is this!?!!!
    }
    
    func deregisterDeviceForPushNotification() {
        if let thisId = self.afmDeviceId {
            deregisterDevice(thisId, completionBlock: {_, _, _ in })
            self.afmDeviceId = nil
        }
    }
    
    func logPushToken() {
        // [START log_fcm_reg_token]
//        let token = Messaging.messaging().fcmToken
//        print("FCM token: \(token ?? "")")
        // [END log_fcm_reg_token]
    }
}

// MARK: API's Calls
extension PushNotification {
    func registerDevice(_ deviceInfo: String, completionBlock completion:@escaping RCBlocks.ResultBlock) {}
    func deregisterDevice(_ deviceId: String, completionBlock completion:@escaping RCBlocks.CompletionBlock) {}
}

// MARK: AppDelegate PushNotification
extension AppDelegate {
    
    // Callback when login is success and view is shown
    func userLoginSuccessNotification(notification: Notification) {
        print("userLoginSuccessNotification")
        let googleServiceFilePath = PushNotification.sharedInstance.getPushServiceFilePath()
        if FileManager.default.fileExists(atPath: googleServiceFilePath) {
            print("Registering device for push notification.")
            PushNotification.sharedInstance.registerDeviceForPushNotification()
        } else {
            print("Device registering failed as push notification is not configured.")
        }
    }
    
    // Initialize firebase
    func initPushNotification(_ application: UIApplication) {
        print("initPushNotification")
        if application.isRegisteredForRemoteNotifications {
//            if FirebaseApp.app() == nil {
//                let googleServiceFilePath = PushNotification.sharedInstance.getPushServiceFilePath()
//                if FileManager.default.fileExists(atPath: googleServiceFilePath) {
//                    print("Configuring firebase...")
//                    if let fireOption = FirebaseOptions(contentsOfFile: googleServiceFilePath) {
//                        //Asking this at app launch
//                        registerForPushNotifications(application)
//                        FirebaseApp.configure(options: fireOption)
//                        Messaging.messaging().delegate = self
//                        PushNotification.sharedInstance.logPushToken()
//                    } else {
//                        print("Failed to initialise firebase configuration file.")
//                    }
//                } else {
//                    print("Firebase service configuration file not found.")
//                }
//            } else {
//                print("Firebase is already initialized.")
//            }
        } else {
            print("Push Notification is disabled by user.")
            // TOOD: Notify up the customer, this is required in order to use our application
        }
    }
    
    // Deinitialize firebase
    func deinitPushNotification() {
        PushNotification.sharedInstance.deregisterDeviceForPushNotification()
        //Remove firebase reference
        if let firebaseApp = FirebaseApp.app() {
            firebaseApp.delete({ (success) in
                if success {
                    print("Firebase has been unintialized.")
                } else {
                    print("Failed to unintialise Firebase.")
                }
            })
        }
    }
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (granted, error) in
                if granted {
                    print("Push Notification access granted.")
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    print("Push Notification access denied.")
                    application.unregisterForRemoteNotifications()
                }
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    // Push Notification message parsing and loading view
    func receivedPushNotification(_ userInfo: [AnyHashable: Any]) {
        // Print full message.
        print("receivedPushNotification: \(userInfo)")
        let message: PushNotificationMessage = PushNotificationMessage(withDataDict: userInfo as! [String: AnyObject])
       // if user logged out
       //  --- Do Nothing
       // else
//        AppNotificationRouter.handleRoute(forMessage: message)
    }
    
    // [START receive_message]
    func pushNotification(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print full message.
    }
    
    //For a push notification to trigger a download operation, the notification’s payload must include the content-available key with its value set to 1.
    //When that key is present, the system wakes the app in the background (or launches it into the background) and calls this app delegate’s
    func pushNotification(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        switch application.applicationState {
        case .inactive:
            print("Inactive")
            //Show the view with the content of the push
            receivedPushNotification(userInfo)
            completionHandler(.newData)
            
        case .background:
            print("Background")
            //Refresh the local model
            completionHandler(.newData)
            
        case .active:
            print("Active")
            completionHandler(.newData)
        @unknown default:
            print("default")
        }
    }
    // [END receive_message]
    
    func pushNotification(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func pushNotification(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
         Messaging.messaging().apnsToken = deviceToken
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func playNotifcationSound() {
//        RidecellGCD.mainQueue { (value) in
//            Utils.playPushNotificationSound()
//        }
    }
    
    // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Change this to your preferred presentation option
        let userInfo = notification.request.content.userInfo
        // make silent push refresh
        receivedPushNotification(userInfo)
        let message: PushNotificationMessage = PushNotificationMessage(withDataDict: userInfo as! [String: AnyObject])
        switch message.eventType {
        case .jobRequest, .jobAssigned, .batchCompleted, .batchJobsOrderChanged:
            playNotifcationSound()
            completionHandler([.sound])
            return
        case .jobCommentsChanged:
            playNotifcationSound()
            completionHandler([.alert, .sound])
            return
        default:
            break
        }
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        // Print full message.
        print(userInfo)
        
        receivedPushNotification(userInfo)

        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate: MessagingDelegate {

    // [START refresh_token]
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        PushNotification.sharedInstance.registerDeviceForPushNotification()
    }
    // [END refresh_token]

    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

extension AppDelegate {
    
    func getFcmToken() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                User.shared.deviceToken = result.token
                self.instanceIDTokenMessage  = "Remote InstanceID token: \(result.token)"
            }
        }
    }
}
