//
//  ProductionCodeEntryView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI
import PromiseKit

struct ProductionCodeEntryView: View {

    static let codeLength = 5

    @State var productionCode = ""

    var onCompletion: (Production) -> Void = { _ in }

    @State private var isShowingHelp = false

    @State private var isProcessing = false

    @State private var errorMessage = ""

    @State private var failedAttempts: CGFloat = 0

    var body: some View {
        VStack {
            Text("Please enter your production code.")
                .font(Font.system(.callout))
                .foregroundColor(.secondary)
            CodeField(code: $productionCode, length: ProductionCodeEntryView.codeLength)
            .onChange(of: productionCode, perform: { _ in
                if !productionCode.isEmpty {
                    errorMessage = ""
                }
                if !isProcessing && productionCode.count == ProductionCodeEntryView.codeLength {
                    submit()
                }
            })
            .disabled(isProcessing)
            .modifier(Shake(animatableData: failedAttempts).animation(.default))
            .padding(.bottom)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom)
            }

            if isShowingHelp {
                Text("You should have recieved a short code for your production. If you're unable to find this code, reach out to your production team.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            } else {
                Button("Production code?") { isShowingHelp = true }
                    .font(.footnote)
            }
        }
    }

    struct ShowNotFoundError: Error, LocalizedError {
        public var errorDescription: String? {
            "The code was not valid. Please try again."
        }
    }

    private func submit() {
        isProcessing = true
        firstly {
            MockServer(latency: .milliseconds(500)).getProduction(for: productionCode)
        }.done { production in
            guard let production = production else {
                failedAttempts += 1
                throw ShowNotFoundError()
            }
            onCompletion(production)
        }.catch { err in
            errorMessage = err.localizedDescription
        }.finally {
            productionCode = ""
            isProcessing = false
        }
    }
}

struct ProductionCodeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ProductionCodeEntryView()
    }
}
