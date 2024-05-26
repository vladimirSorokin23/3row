//
//  AppDelegate+FCM.swift
//  FruttyTreats
//
//

import Foundation

import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // #if DEBUG
        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("DEBUG: Device token - ", deviceToken) // This token can be used for testing notifications on FCM
        // #endif
    }
}
