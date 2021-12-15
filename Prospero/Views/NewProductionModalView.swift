//
//  NewProductionModalView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI

struct NewProductionModalView: View {

    @EnvironmentObject var config: AppConfiguration

    @Binding var isOpen: Bool

    var onSuccess: (UserProduction) -> Void

    var body: some View {
        VStack {
            HStack {
                Button() { isOpen = false } label: { Image(systemName: "xmark") }
                Spacer()
            }
            .padding()
            Spacer()
            AddProductionView(onSuccess: {
                onSuccess($0)
                isOpen = false
            })
            Spacer()
        }
    }

}

struct AddProductionView_Previews: PreviewProvider {
    static var previews: some View {
        NewProductionModalView(isOpen: .constant(true), onSuccess: { print($0) })
    }
}
