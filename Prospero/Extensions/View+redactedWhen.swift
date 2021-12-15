//
//  View+redactedWhen.swift
//  Prospero
//
//  Created by Zach Palumbo on 6/17/21.
//

import Foundation
import SwiftUI

extension View {

    func redacted(reason: RedactionReasons, when condition: Bool) -> some View {
        redacted(reason: condition ? reason : [])
    }

}
