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
    let onSuccess: (Show) -> Void

    @State private var showCodeString: String = ""
    @State private var isProcessing = false
    @State private var errorString = ""
    @State var currentCancelContext: CancelContext?

    private var showCode: Int? {
        let trimmedString = showCodeString.trimmingCharacters(in: .whitespaces)
        return trimmedString.count == 5 ? Int(trimmedString) : nil
    }

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
                    "Enter Code", // TODO localize
                    text: $showCodeString,
                    onCommit: submitCode
                )
                    .font(.title)
                    .padding([.leading, .trailing])
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
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

                Button(action: { self.isAddingShow = false }) {

                    Text("Cancel")

                }

                Text(errorString)
                    .foregroundColor(Color(.systemRed))

            }

        }
            .padding()
            .onDisappear { self.currentCancelContext?.cancel() }

    }

    private func submitCode() {

        errorString = ""
        isProcessing = true

        simulateShowFetch()
            .ensure {
                self.isProcessing = false
                self.currentCancelContext = nil
            }
            .done { newShow in
                self.isAddingShow = false
                self.onSuccess(newShow)
            }
            .catch { error in
                self.errorString = error.localizedDescription
            }

    }

    private func simulateShowFetch() -> CancellablePromise<Show> {

        let promise = after(.milliseconds(.random(in: 500...3000)))
            .map { () -> Show in
                guard let showCode = self.showCode, showCode % 3 != 0 else {
                    throw ShowFetchFailure.badCode
                }
                return TestData.generateRandomShow(id: self.showCode)
            }
            .cancellize()

        currentCancelContext = promise.cancelContext

        return promise

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
