//
//  PushHelper.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import UserNotifications
import CloudKit

protocol PushHelperDelegate{
    func refreshPosts()
}

class PushHelper: NSObject, UNUserNotificationCenterDelegate{
    static let sharedInstance = PushHelper()
    var delegate: PushHelperDelegate?
    
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func registerForPushNotifications(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Enable or disable features based on authorization
            if granted{
                self.subscribeToPosts()
            }
        }
        (UIApplication.shared.registerForRemoteNotifications())
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification)
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        self.delegate?.refreshPosts()
    }

    
    
    
    func subscribeToPosts(){
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        
        
        let subscription = CKQuerySubscription(recordType: "Posts",
                                               predicate: predicate,
                                               options: .firesOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        //        notificationInfo.shouldSendContentAvailable = true
        var desiredKeys = [String]()
        
        desiredKeys.append(Post.keys.message)
        
        notificationInfo.alertLocalizationKey = "Someone wrote: \"%1$@\""
        notificationInfo.alertLocalizationArgs = desiredKeys
        
        subscription.notificationInfo = notificationInfo
        
        
        publicDatabase.fetchAllSubscriptions { (subscriptions, error) in
            if error == nil {
                if let subscriptions = subscriptions {
                    var didFindSubscription = false
                    for savedSubscription in subscriptions {
                        if let savedQuerySubscription = savedSubscription as? CKQuerySubscription, savedQuerySubscription.recordType == subscription.recordType{
                            didFindSubscription = true
                        }
                    }
                    if !didFindSubscription{
                        self.subscribe(database: publicDatabase, subscription: subscription)
                    }
                }else{
                    self.subscribe(database: publicDatabase, subscription: subscription)
                }
            } else {
                // do your error handling here!
                print(error!.localizedDescription)
                self.subscribe(database: publicDatabase, subscription: subscription)
            }
        }
    }
    
    private func subscribe(database: CKDatabase, subscription: CKQuerySubscription){
        database.save(subscription,
                      completionHandler: ({returnRecord, error in
                        if let err = error {
                            print("subscription failed %@",
                                  err.localizedDescription)
                        } else {
                            print("Subscription to Posts was successful")
                        }
                      }))
    }

    
    
}
