//
//  ShowView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI

struct ShowView: View {

    let show: Show

    var body: some View {

        ScrollView {

            VStack(alignment: .leading) {

                Text("This is a placeholder interface for \(show.name). The show will be performed at \(show.theatre.name).")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)

            }
                .padding()

        }
            .navigationBarTitle(show.name)

    }

}

struct ShowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShowView(show: TestData.generateRandomShow())
        }
    }
}
