//
//  AddShowView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI
import PromiseKit

struct AddShowView: View {

    @Binding var isAddingShow: Bool
    var onSuccess: (Show) -> ()

    @State private var showCodeString: String = ""
    private var showCode: Int? {
        Int(showCodeString).flatMap { (10000...99999).contains($0) ? $0 : nil }
    }

    @State private var isProcessing = false

    @State private var errorString = ""

    var body: some View {

        ScrollView {

            VStack(alignment: .center, spacing: 25) {

                Text("Please enter the 5-digit show code.")
                    .font(.headline)
                    .padding(.top)

                Text("Some explanatory text about the show code would probably go here. Also, this would probably be one of those fancy PIN entry interfaces that pops the keyboard for you and auto-submits when all the digits are typed.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField(
                    "Show Code",
                    text: $showCodeString,
                    onCommit: submitCode
                )
                    .font(.title)
                    .padding([.leading, .trailing])
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isProcessing)

                HStack {
                    Button(action: submitCode) {
                        Text("Submit")
                            .bold()
                    }
                        .disabled(showCode == nil || isProcessing)
                    if isProcessing {
                        ActivityIndicator(
                            isAnimating: .constant(true), style: .medium
                        )
                    }
                }

                Text(errorString)
                    .foregroundColor(.red)

            }
        }
            .padding()

    }

    private func submitCode() {

        errorString = ""
        isProcessing = true

        simulateShowFetch()
            .ensure { self.isProcessing = false }
            .done { newShow in
                self.isAddingShow = false
                self.onSuccess(newShow)
            }
            .catch { error in
                self.errorString = error.localizedDescription
            }

    }

    private func simulateShowFetch() -> Promise<Show> {
        after(.milliseconds(.random(in: 500...3000)))
            .map { _ in
                guard let showCode = self.showCode, showCode % 3 != 0 else {
                    throw ShowFetchFailure.badCode
                }
                return TestData.generateRandomShow(id: self.showCode)
            }
    }

}

private enum ShowFetchFailure: LocalizedError {

    case badCode

    var errorDescription: String? {
        switch self {
        case .badCode: return "This code is not valid. It may have expired." // TODO localize
        }
    }

}

struct AddShowView_Previews: PreviewProvider {

    static var previews: some View {
        AddShowView(
            isAddingShow: .constant(true)
        ) { show in
            print("Generated the following show:")
            dump(show)
        }
    }

}
