//
//  TwoFactorView.swift
//  Prospero
//
//  Created by Zach Palumbo on 6/24/21.
//

import SwiftUI
import PhoneNumberKit

enum ConfirmationInfo: Equatable {
    case phone(PhoneNumber)
    case email(String)
}

struct TwoFactorView: View {

    static let codeLength = 5

    let production: UserProduction

    var onCompletion: (UserProduction) -> Void

    var onCancel: () -> Void

    @State private var confirmationCode = ""

    @State private var isProcessing = false

    @State private var errorMessage = ""

    @State private var failedAttempts: CGFloat = 0

    @State private var confirmationInfo: ConfirmationInfo?

    var body: some View {
        VStack {
            if !isProcessing, let confirmationInfo = confirmationInfo {
                Text("We've sent a confirmation code to \(infoString(for: confirmationInfo)). Please enter it below.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                CodeField(
                    code: $confirmationCode,
                    length: ProductionCodeEntryView.codeLength,
                    entryType: .numeric
                )
                    .onChange(of: confirmationCode, perform: { _ in
                        if !confirmationCode.isEmpty {
                            errorMessage = ""
                        }
                        if !isProcessing && confirmationCode.count >= TwoFactorView.codeLength {
                            Task { await submit() }
                        }
                    })
                    .disabled(isProcessing)
                    .shake(with: failedAttempts)
                    .padding(.bottom)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .neverTruncated()
                        .padding(.horizontal, 40)
                        .padding(.bottom)
                }

                Button("Resend", role: nil) {
                    Task { await requestAuthentication(with: confirmationInfo) }
                }
                .font(.system(.footnote, design: .rounded))
                .padding(.bottom)

                Button(switchButtonString(for: confirmationInfo), role: nil) {
                    Task { await switchButtonPressed(for: confirmationInfo) }
                }
                .font(.system(.footnote, design: .rounded))
                .padding(.bottom)

                Button("Add a different production", action: onCancel)
                    .font(.system(.footnote, design: .rounded))
            } else {
                ProgressView()
            }
        }
        .task {
            await requestAuthentication(with: .phone(production.member.phoneNumber))
        }
        .animation(.default, value: isProcessing)
        .animation(.default, value: errorMessage)
    }

    private func infoString(for confirmationInfo: ConfirmationInfo) -> String {
        switch confirmationInfo {
        case .phone(let phoneNumber):
            return phoneNumber.numberString.nonBreaking
        case .email(let email):
            return email
        }
    }

    private func switchButtonString(for confirmationInfo: ConfirmationInfo) -> String {
        switch confirmationInfo {
        case .phone: return "Send Email Instead"
        case .email: return "Send Text Instead"
        }
    }

    private func switchButtonPressed(for confirmationInfo: ConfirmationInfo) async {
        switch confirmationInfo {
        case .phone: await requestAuthentication(with: .email(production.member.email))
        case .email: await requestAuthentication(with: .phone(production.member.phoneNumber))
        }
    }

    private func requestAuthentication(with confirmationInfo: ConfirmationInfo) async {
        isProcessing = true
        do {
            try await MockServer.requestAuthentication(with: confirmationInfo)
            self.confirmationInfo = confirmationInfo
            errorMessage = ""
        } catch {
            self.confirmationInfo = nil
            if let error = error as? LocalizedError {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "An authorization code could not be requested."
            }
        }
        withAnimation { isProcessing = false }
    }

    private func submit() async {
        guard let numberCode = Int(confirmationCode) else {
            failedAttempts += 1
            confirmationCode = ""
            errorMessage = "Your confirmation code should be a number."
            return
        }

        withAnimation { isProcessing = true }
        do {
            if try await MockServer.authenticate(code: numberCode) {
                onCompletion(production)
            } else {
                throw InvalidCodeError()
            }
        } catch {
            failedAttempts += 1
            confirmationCode = ""
            withAnimation { isProcessing = false }
            if let error = error as? LocalizedError {
                errorMessage = error.localizedDescription
            } else {
                errorMessage = "The code could not be submitted."
            }
        }
    }

}

private struct InvalidCodeError: LocalizedError {
    var errorDescription: String? { "The code you submitted was not valid. It may have expired." }
}

struct TwoFactorView_Previews: PreviewProvider {
    static var previews: some View {
        TwoFactorView(
            production: .init(
                id: .init(),
                production: DemoProductions.stupidFuckingBird,
                member: DemoMembers.zachPalumbo
            ),
            onCompletion: { print($0) },
            onCancel: { print("Cancelled") }
        )
    }
}
