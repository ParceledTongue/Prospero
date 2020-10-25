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

    var onEditingChanged: (Bool) -> Void = { _ in }

    var onCommit: () -> Void = {}

    var body: some View {
        ZStack(alignment: Alignment.center) {
            Text(displayTextFor(code: code))
                .font(CodeField.inputFont)
            // Invisible text field to handle actual input.
            TextField("", text: $code, onEditingChanged: onEditingChanged, onCommit: onCommit)
                .font(CodeField.inputFont)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .colorMultiply(.clear)
                .onChange(of: code, perform: { _ in
                    code = String(code.prefix(length))
                })
        }
    }

    private func displayTextFor(code: String) -> String {
        String(
            code.appending(
                String(
                    repeating: CodeField.placeholder,
                    count: max(0, length - code.count)
                )
            ).flatMap { "\($0) " }
        ).trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
struct CodeField_Previews: PreviewProvider {
    static var previews: some View {
        CodeField(code: .constant(""), length: 5)
    }
}
