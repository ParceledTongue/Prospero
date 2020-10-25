//
//  RootView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var userProductions: UserProductions

    @State var needsOnboarding: Bool

    @State var selection: Int?

    var body: some View {
        ProductionListView(selection: $selection)
            .opacity(needsOnboarding ? 0 : 1)
            .fullScreenCover(isPresented: $needsOnboarding, content: {
                OnboardingView(
                    onCompletion: { production in
                        userProductions.addProduction(production)
                        selection = production.id
                        needsOnboarding = false
                    }
                )
            })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(needsOnboarding: true)
            .environmentObject(UserProductions())
    }
}
