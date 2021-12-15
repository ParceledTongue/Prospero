//
//  ProductionCodeEntryView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct ProductionCodeEntryView: View {

    static let codeLength = 5

    @State var productionCode = ""

    var onCompletion: (Production) -> Void

    @State private var isShowingHelp = false

    @State private var isProcessing = false

    @State private var errorMessage = ""

    @State private var failedAttempts: CGFloat = 0

    var body: some View {
        VStack {
            Text("Please enter your production code.")
                .font(Font.system(.callout))
                .foregroundColor(.secondary)
            CodeField(
                code: $productionCode,
                length: ProductionCodeEntryView.codeLength,
                entryType: .alphabetic
            )
                .disabled(isProcessing)
                .opacity(isProcessing ? 0 : 1)
                .overlay { if isProcessing { ProgressView() } }
                .shake(with: failedAttempts)
                .padding(.bottom)
                .onChange(of: productionCode, perform: { _ in
                    if !productionCode.isEmpty {
                        errorMessage = ""
                    }
                    if !isProcessing && productionCode.count >= ProductionCodeEntryView.codeLength {
                        Task { await submit() }
                    }
                })

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(.footnote, design: .rounded))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .neverTruncated()
                    .padding(.horizontal, 40)
                    .padding(.bottom)
            }

            if isShowingHelp {
                Text("You should have recieved a short code for your production. If you're unable to find this code, reach out to your production team.")
                    .font(.system(.footnote, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            } else {
                Button("Production code?") {
                    isShowingHelp = true
                }
                .font(.system(.footnote, design: .rounded))
            }
        }
        .animation(.default, value: isShowingHelp)
        .animation(.default, value: isProcessing)
        .animation(.default, value: errorMessage)
    }

    private func submit() async {
        isProcessing = true
        if let production = await MockServer.getProduction(for: productionCode) {
            onCompletion(production)
        } else {
            failedAttempts += 1
            errorMessage = "The code was not valid. Please try again."
        }
        productionCode = ""
        isProcessing = false
    }
}

struct ProductionCodeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ProductionCodeEntryView(onCompletion: { print($0) })
    }
}
