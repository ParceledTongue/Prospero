//
//  ProductionListView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI
import CoreLocation

struct ProductionListView: View {

    @Environment(\.editMode) var editMode

    @EnvironmentObject var userProductions: UserProductions

    @Binding var selection: Int?

    @State private var isAddingProduction: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(userProductions.list) {
                    ProductionRow(production: $0, selection: $selection)
                }
                .onDelete {
                    userProductions.removeProductions(atOffsets: $0)
                }

                addProductionRow
            }
            .navigationBarTitle("Productions")
            .navigationBarItems(
                trailing: EditButton().disabled(userProductions.list.isEmpty)
            )
            .sheet(isPresented: $isAddingProduction) {
                AddProductionView(
                    isAddingProduction: $isAddingProduction,
                    onSuccess: addProduction
                )
            }
        }
    }

    private var addProductionRow: some View {
        Button(action: { isAddingProduction = true }) {
            HStack {
                Text("Add Production")
                    .foregroundColor(.accentColor)
                Spacer()
                Image(systemName: "plus.circle")
                    .foregroundColor(.accentColor)
            }
        }
        // XXX This doesn't seem to listen to `editMode`... Think I need to map the var somehow
        .disabled(editMode?.wrappedValue != .inactive)
    }

    func addProduction(_ newProduction: Production) {
        userProductions.addProduction(newProduction)
        selection = newProduction.id
    }
}

private struct ProductionRow: View {

    let production: Production

    @Binding var selection: Int?

    var body: some View {
        NavigationLink(
            destination: ProductionView(production: production),
            tag: production.id,
            selection: $selection
        ) {
            VStack(alignment: .leading) {
                Text(production.show.title)
                    .font(.headline)
                Text(production.company.name)
                    .font(Font.subheadline.smallCaps())
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ProductionListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductionListView(selection: .constant(nil))
            .environmentObject(UserProductions())
    }
}
