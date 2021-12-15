//
//  Task+sleep.swift
//  Prospero
//
//  Created by Zach Palumbo on 6/10/21.
//

import Foundation

extension Task where Success == Never, Failure == Never {

    /**
     Sugar for `Task.sleep(nanoseconds:)` which takes a `TimeInterval` instead. Additionally, this
     version does not throw when the task is cancelled, logging and returning instead.
     */
    static func sleep(seconds: TimeInterval) async {
        do {
            try await sleep(nanoseconds: UInt64(seconds.converted(to: .nanoseconds)))
        } catch {
            print("Sleep cancelled: \(error)")
        }
    }

}
