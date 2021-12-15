//
//  ProductionListView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI
import CoreLocation

struct ProductionListView: View {

    @EnvironmentObject var config: AppConfiguration

    @Binding var selection: Int?

    @State private var editMode = EditMode.inactive

    @State private var isAddingProduction: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(config.productions) {
                        ProductionRow(production: $0, selection: $selection)
                    }
                    .onMove(perform: config.moveProductions)
                    .onDelete(perform: config.removeProductions)
                }
                Section {
                    addProductionRow
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarItems(
                trailing: EditButton().disabled(config.productions.isEmpty)
            )
            .environment(\.editMode, $editMode)
            .navigationBarTitle("Productions")
            .sheet(isPresented: $isAddingProduction) {
                NewProductionModalView(
                    isOpen: $isAddingProduction,
                    onSuccess: addAndOpenProduction
                )
            }
        }
    }

    private var addProductionRow: some View {
        Button() { isAddingProduction = true } label: {
            HStack {
                Text("Add Production")
                    .foregroundColor(.accentColor)
                Spacer()
                Image(systemName: "plus.circle")
                    .foregroundColor(.accentColor)
            }
        }
        .disabled(editMode != .inactive)
    }

    func addAndOpenProduction(_ newProduction: UserProduction) {
        if !config.productions.contains(newProduction) {
            config.addProduction(newProduction)
        }
        selection = newProduction.id.hashValue
    }
}

private struct ProductionRow: View {

    let production: UserProduction

    @Binding var selection: Int?

    var body: some View {
        NavigationLink(
            destination: ProductionView(production: production),
            tag: production.id.hashValue,
            selection: $selection
        ) {
            VStack(alignment: .leading) {
                Text(production.show.title)
                    .font(.system(.headline, design: .rounded))
                Text(production.company.name)
                    .font(Font.system(.subheadline, design: .rounded).smallCaps())
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ProductionListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProductionListView(selection: .constant(nil))
                .environmentObject(AppConfiguration())
        }
    }
}

// MARK: - Custom Menu Context Implementation
struct PreviewContextMenu<Content: View> {
    let destination: Content
    let actionProvider: UIContextMenuActionProvider?

    init(destination: Content, actionProvider: UIContextMenuActionProvider? = nil) {
        self.destination = destination
        self.actionProvider = actionProvider
    }
}
