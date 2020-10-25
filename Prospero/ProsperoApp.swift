//
//  ProsperoApp.swift
//  Prospero
//
//  Created by Zach Palumbo on 9/26/20.
//

import SwiftUI

@main
struct ProsperoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.font, Font.system(.body, design: .rounded))
                .environmentObject(AppConfiguration())
        }
    }
}

struct ProsperoApp_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environment(\.font, Font.system(.body, design: .rounded))
            .environmentObject(AppConfiguration())
    }
}
