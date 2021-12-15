//
//  MockServer.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation
import PhoneNumberKit
import UserNotifications
import UIKit

actor MockServer {

    private static let instance = MockServer([
        "CNSTL": DemoProductions.constellations,
        "STUFB": DemoProductions.stupidFuckingBird,
        "WRLDB": DemoProductions.worldBuilders,
    ])

    private static var deviceID: UUID {
        get async throws {
            if let id = await UIDevice.current.identifierForVendor {
                return id
            } else {
                throw ServerError.noDeviceID
            }
        }
    }

    private var productionCodeDict: [String: Production]
    private var verificationCodeDict = [UUID: AuthCode]()

    static func getProduction(
        for code: String,
        latency: TimeInterval = 0.5
    ) async -> Production? {
        await Task.sleep(seconds: latency)
        return await instance.productionCodeDict[code.uppercased()]
    }

    static func requestAuthentication(
        with confirmationInfo: ConfirmationInfo,
        latency: TimeInterval = 0.5
    ) async throws {
        await Task.sleep(seconds: latency)
        let id = try await deviceID
        let code = await instance.requestAuthentication(id: id)
        try await requestNotificationPermissionIfNeeded()
        try await sendMockAuthNotification(authCode: code, confirmationInfo: confirmationInfo)
    }

    static func authenticate(
        code: Int,
        latency: TimeInterval = 0.5
    ) async throws -> Bool {
        await Task.sleep(seconds: latency)
        let id = try await deviceID
        if let realCode = await instance.verificationCodeDict[id] {
            return realCode.code == code && realCode.expiration >= .now
        } else {
            return false
        }
    }

    private static func requestNotificationPermissionIfNeeded() async throws {
        let canSendNotifications = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        if !canSendNotifications { throw ServerError.cannotSendNotification }
    }

    private static func sendMockAuthNotification(
        authCode: AuthCode,
        confirmationInfo: ConfirmationInfo
    ) async throws {
        let title: String
        switch confirmationInfo {
        case .email: title = "Mock Email 2FA Notification"
        case .phone: title = "Mock Phone 2FA Notification"
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "Your verification code is \(authCode.code)."
        content.sound = .default
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        try await UNUserNotificationCenter.current().add(request)
    }

    private init(_ productionCodeDict: [String: Production]) {
        self.productionCodeDict = productionCodeDict
    }

    private func requestAuthentication(id: UUID) -> AuthCode {
        let code = AuthCode(timeToLive: .init(value: 5, unit: .minutes))
        verificationCodeDict[id] = code
        return code
    }

}

struct AuthCode {
    let code: Int
    let expiration: Date

    init(timeToLive: Measurement<UnitDuration>) {
        code = Int.random(in: 10000...99999)
        expiration = Date(timeInterval: timeToLive.converted(to: .seconds).value, since: .now)
    }
}

enum ServerError: Error {
    case noDeviceID
    case cannotSendNotification
}

// swiftlint:disable force_try

enum DemoProductions {

    static let constellations = Production(
        show: .init(
            title: "Constellations",
            playwright: .init(name: try! .init("Nick Payne"))
        ),
        company: .init(name: "Players' Theatre Group"),
        members: [DemoMembers.jonahRoth]
    )

    static let stupidFuckingBird = Production(
        show: .init(
            title: "Stupid Fucking Bird",
            playwright: .init(name: try! .init("Aaron Posner"))
        ),
        company: .init(name: "Players' Theatre Group"),
        members: [DemoMembers.zachPalumbo]
    )

    static let worldBuilders = Production(
        show: .init(
            title: "World Builders",
            playwright: .init(name: try! .init("Johnna Adams"))
        ),
        company: .init(name: "convergence-continuum"),
        members: [DemoMembers.jonahRoth, DemoMembers.zachPalumbo]
    )

}

enum DemoMembers {

    private static let phoneNumberKit = PhoneNumberKit()

    static let jonahRoth = Production.Member(
        person: .init(name: try! .init("Jonah Roth")),
        email: "jonah.r.roth@gmail.com",
        phoneNumber: try! phoneNumberKit.parse("(513) 305-1404")
    )

    static let zachPalumbo = Production.Member(
        person: .init(name: try! .init("Zach Palumbo")),
        email: "zach@palumbo.io",
        phoneNumber: try! phoneNumberKit.parse("(585) 298-4122")
    )

}

// swiftlint:enable force_try
