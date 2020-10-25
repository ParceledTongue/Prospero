//
//  ProductionCodeEntryView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI
import PromiseKit

struct ProductionCodeEntryView: View {

    struct InfoConfiguration {
        let text: String
        let color: Color
    }

    static let codeLength = 5

    @State var productionCode = ""

    var onCompletion: (Production) -> Void = { _ in }

    @State private var extraInfo: InfoConfiguration?

    @State private var isProcessing = false

    @State private var failedAttempts: CGFloat = 0

    var body: some View {
        VStack {
            Text("Please enter your production code.")
                .font(Font.system(.callout))
                .foregroundColor(.secondary)
            CodeField(code: $productionCode, length: ProductionCodeEntryView.codeLength)
                .padding(.bottom)
                .onChange(of: productionCode, perform: { _ in
                    if !isProcessing && productionCode.count == ProductionCodeEntryView.codeLength {
                        submit()
                    }
                })
                .disabled(isProcessing)
                .modifier(Shake(animatableData: failedAttempts).animation(.default))

            if let extraInfo = extraInfo {
                Text(extraInfo.text)
                    .font(.footnote)
                    .foregroundColor(extraInfo.color)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            } else {
                Button("Production code?") {
                    extraInfo = .init(
                        text: "You should have recieved a short code for your production. If you're unable to find this code, reach out to your production team.",
                        color: .secondary
                    )
                }
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
            extraInfo = nil
            onCompletion(production)
        }.catch { err in
            extraInfo = .init(
                text: err.localizedDescription,
                color: .red
            )
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
