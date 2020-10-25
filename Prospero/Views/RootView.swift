//
//  RootView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var config: AppConfiguration

    @SceneStorage("RootView.selection")
    var selection: Int?

    var body: some View {
        ProductionListView(selection: $selection)
            .opacity(config.isOnboarded ? 1 : 0)
            .fullScreenCover(isPresented: !$config.isOnboarded, content: {
                OnboardingView(
                    onCompletion: { production in
                        config.addProduction(production)
                        selection = production.id
                        config.isOnboarded = true
                    }
                )
            })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(AppConfiguration())
    }
}
