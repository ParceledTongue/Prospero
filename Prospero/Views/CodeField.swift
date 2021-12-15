//
//  CodeField.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct CodeField: View {

    enum EntryType {
        case alphabetic
        case numeric
        case alphanumeric

        var validCharacters: CharacterSet {
            switch self {
            case .alphabetic: return .letters
            case .numeric: return .decimalDigits
            case .alphanumeric: return .alphanumerics
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .alphabetic: return .alphabet
            case .numeric: return .numberPad
            case .alphanumeric: return .default
            }
        }

    }

    private static let inputFont = Font.system(.title, design: .monospaced)

    private static let placeholder = "·"

    @Binding var code: String

    let length: Int

    let entryType: EntryType

    var body: some View {
        ZStack(alignment: Alignment.center) {
            Text(displayTextFor(code: code))
                .font(CodeField.inputFont)
            // Invisible text field to handle actual input.
            TextField("", text: $code)
                .keyboardType(entryType.keyboardType)
                .font(CodeField.inputFont)
                .multilineTextAlignment(.center)
                .autocapitalization(.allCharacters)
                .disableAutocorrection(true)
                .colorMultiply(.clear)
                .onChange(of: code, perform: { _ in
                    code = code.trimmingCharacters(in: entryType.validCharacters.inverted)
                })
        }
    }

    private func displayTextFor(code: String) -> String {
        String(
            code.appending(String(
                repeating: CodeField.placeholder,
                count: max(0, length - code.count)
            ))
            .flatMap { "\($0) " }
            .dropLast()
        ).uppercased()
    }

}
struct CodeField_Previews: PreviewProvider {
    static var previews: some View {
        CodeField(code: .constant(""), length: 5, entryType: .alphabetic)
    }
}
