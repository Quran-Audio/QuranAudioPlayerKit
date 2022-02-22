//
//  File.swift
//  
//
//  Created by Mohammed Shafeer on 05/02/22.
//

import UIKit
import UserNotifications

public class PushService: NSObject {
    public static let shared = PushService()
    private override init(){}
    
    public func askForPushPermission() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
                break
            case .authorized:
                print("The application is authorized to post user notifications.")
                break
            case .denied:
                print("The application is not authorized to post user notifications.")
                break
            case .provisional:
                print("The application is authorized to post non-interruptive user notifications.")
                break
            case .ephemeral:
                print("ephemeral state")
            @unknown default:
                print("Some Unknow Notification state")
            }
        }
    }
    
    private func invitationToRead() -> UNNotificationRequest {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Come Back".localize
        notificationContent.body = "Lets listen Quran. May ALLAH bless you".localize
        
        //Firday Trigger
        var date = DateComponents()
        date.hour = 7 // 7 AM
        date.minute = 1 // First Minute
        //        date.day = 6 // Friday
        let dailyTrigger = UNCalendarNotificationTrigger(dateMatching: date ,
                                                         repeats: true)
        
        // Time Interval Trigger
//         let dailyTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: true)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "thafseer_app_firday local_notification",
                                                        content: notificationContent,
                                                        trigger: dailyTrigger)
        return notificationRequest
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Request
        let notificationRequest = invitationToRead()
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
}


//MARK: UNUserNotificationCenterDelegate
extension PushService:UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
}
