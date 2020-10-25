//
//  ProsperoApp.swift
//  Prospero
//
//  Created by Zach Palumbo on 9/26/20.
//

import SwiftUI

@main
struct ProsperoApp: App {
    let onboarded = false

    var body: some Scene {
        WindowGroup {
            RootView(needsOnboarding: true)
                .environment(\.font, Font.system(.body, design: .rounded))
                .environmentObject(UserProductions())
        }
    }
}

struct ProsperoApp_Previews: PreviewProvider {
    static var previews: some View {
        RootView(needsOnboarding: true)
            .environment(\.font, Font.system(.body, design: .rounded))
            .environmentObject(UserProductions())
    }
}
