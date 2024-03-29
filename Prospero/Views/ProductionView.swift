//
//  ProductionView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI

struct ProductionView: View {

    let production: UserProduction

    var body: some View {
        Text("// TODO")
            .font(.system(.largeTitle, design: .monospaced))
            .foregroundColor(.secondary)
            .navigationBarTitle(production.show.title)
    }

}

struct ProductionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductionView(production: .init(
                id: .init(),
                production: DemoProductions.constellations,
                member: DemoMembers.zachPalumbo
            ))
        }
    }
}
