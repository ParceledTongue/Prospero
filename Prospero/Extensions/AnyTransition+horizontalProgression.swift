//
//  AnyTransition+horizontalProgression.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

extension AnyTransition {

    static let horizontalProgression = AnyTransition.asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )

}
