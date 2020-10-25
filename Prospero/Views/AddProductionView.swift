//
//  AddProductionView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI
import PromiseKit

struct AddProductionView: View {

    enum Step {
        case enterCode
        case confirmProduction(Production)
    }

    @Binding var isAddingProduction: Bool

    var onSuccess: (Production) -> Void = { _ in }

    @State private var step = Step.enterCode

    var body: some View {
        Group {
            switch step {
            case .enterCode:
                VStack {
                    ProductionCodeEntryView(
                        onCompletion: { step = .confirmProduction($0) }
                    )
                    .padding(.bottom)
                    .padding(.bottom)
                    Button("Cancel") { isAddingProduction = false }
                }
                .transition(.horizontalProgression)
            case .confirmProduction(let production):
                VStack {
                    MemberConfirmationView(
                        production: production,
                        onCompletion: { _ in
                            onSuccess(production)
                            isAddingProduction = false
                        }
                    )
                    Button("This is not my production") { step = .enterCode }
                        .font(.system(.footnote, design: .rounded))
                }
                .transition(.horizontalProgression)
            }
        }
        .animation(.default)
    }

}

struct AddProductionView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductionView(isAddingProduction: .constant(true))
    }
}
