//
//  CodeField.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

struct CodeField: View {

    private static let inputFont = Font.system(.title, design: .monospaced)

    private static let placeholder = "·"

    @Binding var code: String

    let length: Int

    var body: some View {
        ZStack(alignment: Alignment.center) {
            Text(displayTextFor(code: code))
                .font(CodeField.inputFont)
            // Invisible text field to handle actual input.
            TextField("", text: $code)
                .font(CodeField.inputFont)
                .multilineTextAlignment(.center)
                .keyboardType(.alphabet)
                .autocapitalization(.allCharacters)
                .disableAutocorrection(true)
                .colorMultiply(.clear)
                .onChange(of: code, perform: { _ in
                    code = code.trimmingCharacters(in: CharacterSet.letters.inverted)
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
        CodeField(code: .constant(""), length: 5)
    }
}
