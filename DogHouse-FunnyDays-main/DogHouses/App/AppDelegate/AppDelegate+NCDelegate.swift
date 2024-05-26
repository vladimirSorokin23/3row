//
//  AppDelegate+NCDelegate.swift
//  DogHouses
//
//

import UserNotifications
import UIKit

extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .badge, .sound]])
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        #if DEBUG
        print("DEBUG: didRegisterForRemoteNotificationsWithDeviceToken \(deviceToken)")
        #endif
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        #if DEBUG
        print("DEBUG: didFailToRegisterForRemoteNotificationsWithError \(error)")
        #endif
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
