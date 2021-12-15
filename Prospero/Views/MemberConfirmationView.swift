//
//  MemberConfirmationView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct MemberConfirmationView: View {

    let production: Production

    var onCompletion: (UserProduction) -> Void

    var onCancel: () -> Void

    @State private var emailAddress = ""

    @State private var errorMessage = ""

    @State private var failedAttempts: CGFloat = 0

    var body: some View {
        VStack {
            Text(production.show.title)
                .font(.system(.title, design: .rounded))
                .bold()
            Text("at")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
            Text(production.company.name)
                .font(.system(.title2, design: .rounded))
                .padding(.bottom)
                .padding(.bottom)
            Text("To confirm, please enter your email address:")
                .foregroundColor(.secondary)
            TextField("someone@example.com", text: $emailAddress, onCommit: submitEmailAddress)
                .font(.system(.subheadline, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .shake(with: failedAttempts)
                .padding(.bottom)
                .onChange(of: emailAddress, perform: { _ in
                    if !emailAddress.isEmpty {
                        errorMessage = ""
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

            Button("This is not my production", action: onCancel)
                .font(.system(.footnote, design: .rounded))
        }
        .animation(.default, value: errorMessage)
    }

    private func submitEmailAddress() {
        guard emailAddress.isValidEmailAddress else {
            failWithMessage("Please enter a valid email address.")
            return
        }
        if let member = production.members.first(where: { $0.email == emailAddress }) {
            onCompletion(UserProduction(id: UUID(), production: production, member: member))
        } else {
            failWithMessage("We couldn't find anyone with that email address. Make sure you're using the same email you gave to your production team.")
        }
    }

    private func failWithMessage(_ errorMessage: String) {
        self.errorMessage = errorMessage
        failedAttempts += 1
        emailAddress = ""
    }
}

struct MemberConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        MemberConfirmationView(
            production: DemoProductions.stupidFuckingBird,
            onCompletion: { print($0) },
            onCancel: { print("Cancelled") }
        )
    }
}
