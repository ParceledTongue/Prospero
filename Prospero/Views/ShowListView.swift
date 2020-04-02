//
//  ShowListView.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import SwiftUI
import CoreLocation

struct ShowListView: View {

    @State var shows: [Show]
    @State private var isAddingShow: Bool = false
    @State private var deletionContext: DeletionContext?
    @State private var selection: Int?

    var body: some View {

        NavigationView {
            List {
                ForEach(shows) {
                    ShowRow(show: $0, selection: self.$selection)
                }
                    .onDelete {
                        self.deletionContext = DeletionContext(offsets: $0)
                    }
                addShowRow
            }
                .navigationBarTitle("Shows")
                .navigationBarItems(
                    trailing: EditButton().disabled(shows.isEmpty)
                )
                .sheet(isPresented: $isAddingShow) {
                    AddShowView(
                        isAddingShow: self.$isAddingShow,
                        onSuccess: self.addShow
                    )
                }
                .alert(
                    item: $deletionContext,
                    content: deletionConfirmationAlert
                )
        }

    }

    private var addShowRow: some View {
        Button(action: {
            self.isAddingShow = true
        }) {
            HStack {
                Text("Add New Show")
                    .foregroundColor(.accentColor)
                Spacer()
                Image(systemName: "plus.circle")
                    .foregroundColor(.accentColor)
            }
        }
    }

    private func addShow(_ newShow: Show) {
        if !shows.contains(where: { $0.id == newShow.id }) {
            shows.insert(newShow, at: shows.firstIndex(where: {
                alphabeticalCollator(newShow, $0)
            }) ?? shows.endIndex)
        }
        selection = newShow.id
    }

    private func deletionConfirmationAlert(_ ctx: DeletionContext) -> Alert {

        let alertTitle: Text
        let alertMessage: Text

        if ctx.offsets.count == 1 {
            let show = shows[ctx.offsets.first!]
            alertTitle = Text("Remove \(show.name)?")
            alertMessage = Text("The show can be re-added later.")
        } else {
            alertTitle = Text("Delete Selected Shows?")
            alertMessage = Text("These shows can be re-added later.")
        }

        return Alert(
            title: alertTitle,
            message: alertMessage,
            primaryButton: .destructive(Text("Remove")) {
                self.shows.remove(atOffsets: ctx.offsets)
            },
            secondaryButton: .cancel()
        )

    }

}

private struct ShowRow: View {

    let show: Show

    @Binding var selection: Int?

    var body: some View {

        NavigationLink(
            destination: ShowView(show: show),
            tag: show.id,
            selection: $selection
        ) {
            VStack(alignment: .leading) {
                Text(show.name)
                    .font(.headline)
                Text(show.theatre.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }

    }

}

private struct DeletionContext: Identifiable {
    let id = UUID()
    let offsets: IndexSet
}

struct ShowListView_Previews: PreviewProvider {
    static var previews: some View {
        ShowListView(shows: [])
    }
}

private let alphabeticalCollator: (Show, Show) -> Bool = { lhs, rhs in
    let lhs = lhs.name.lowercased().hasPrefix("the ")
        ? String(lhs.name.lowercased().dropFirst(4))
        : lhs.name.lowercased()
    let rhs = rhs.name.lowercased().hasPrefix("the ")
        ? String(rhs.name.lowercased().dropFirst(4))
        : rhs.name.lowercased()
    return lhs < rhs
}
