//
//  ProductionView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI

struct ProductionView: View {

    let production: Production

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("This is a placeholder interface for \(production.show.title). The show will be performed at \(production.company.name).")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationBarTitle(production.show.title)
    }

}

struct ProductionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductionView(production: DemoProductions.constellations)
        }
    }
}
