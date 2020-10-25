//
//  MemberConfirmationView.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct MemberConfirmationView: View {

    let production: Production

    var onCompletion: (Production.Member) -> Void = { _ in }

    @State private var emailAddress = ""

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
            TextField("someone@example.com", text: $emailAddress, onCommit: {
                if let member = production.members.first(where: { $0.email == emailAddress }) {
                    onCompletion(member)
                } else {
                    failedAttempts += 1
                    emailAddress = ""
                }
            })
            .font(.system(.subheadline, design: .monospaced))
            .multilineTextAlignment(.center)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.bottom)
            .modifier(Shake(animatableData: failedAttempts).animation(.default))
        }
    }
}

struct MemberConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        MemberConfirmationView(production: DemoProductions.stupidFuckingBird)
    }
}
