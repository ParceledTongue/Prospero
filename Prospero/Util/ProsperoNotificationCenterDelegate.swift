//
//  ProsperoNotificationCenterDelegate.swift
//  Prospero
//
//  Created by Zach Palumbo on 6/25/21.
//

import Foundation
import UserNotifications

class ProsperoNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {

    static let instance = ProsperoNotificationCenterDelegate()

    private override init() {
        super.init()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.list, .banner, .sound, .badge]
    }

}
