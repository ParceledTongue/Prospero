//
//  AddProductionView.swift
//  Prospero
//
//  Created by Zach Palumbo on 6/25/21.
//

import SwiftUI

struct AddProductionView: View {

    enum Step: Equatable {
        case enterCode
        case confirmProduction(Production)
        case twoFactor(UserProduction)
    }

    @EnvironmentObject var config: AppConfiguration

    var stepAnimation: Animation? = .default

    var onSuccess: (UserProduction) -> Void

    @State private var step = Step.enterCode

    var body: some View {
        Group {
            switch step {
            case .enterCode:
                ProductionCodeEntryView(
                    onCompletion: { production in
                        if let existingProduction = config.productions.first(where: { localProduction in
                            localProduction.production == production
                        }) {
                            onSuccess(existingProduction)
                        } else {
                            step = .confirmProduction(production)
                        }
                    }
                )
                .transition(.horizontalProgression)
            case .confirmProduction(let production):
                VStack {
                    MemberConfirmationView(
                        production: production,
                        onCompletion: { step = .twoFactor($0) },
                        onCancel: { step = .enterCode }
                    )
                }
                .transition(.horizontalProgression)
            case .twoFactor(let production):
                VStack {
                    TwoFactorView(
                        production: production,
                        onCompletion: onSuccess,
                        onCancel: { step = .enterCode }
                    )
                    .padding(.bottom)
                }
                .transition(.horizontalProgression)
            }
        }
        .animation(stepAnimation, value: step)
    }
}

struct AddProductionViewNew_Previews: PreviewProvider {
    static var previews: some View {
        AddProductionView(onSuccess: { print($0) })
            .environmentObject(AppConfiguration())
    }
}
