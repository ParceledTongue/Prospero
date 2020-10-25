//
//  AppConfiguration.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation

class AppConfiguration: ObservableObject {

    @Published private(set) var list: [Production]

    init(list: [Production] = []) {
        self.list = list
    }

    func addProduction(_ production: Production) {
        if !list.contains(where: { $0.id == production.id }) {
            let insertionIndex = list.firstIndex(where: { productionAtIdx in
                alphabeticalCollator(production, productionAtIdx)
            }) ?? list.endIndex
            list.insert(production, at: insertionIndex)
        }
    }

    func removeProductions(atOffsets offsets: IndexSet) {
        list.remove(atOffsets: offsets)
    }
}

private let alphabeticalCollator: (Production, Production) -> Bool = { lhs, rhs in
    let lhs = lhs.show.title.lowercased().hasPrefix("the ")
        ? String(lhs.show.title.lowercased().dropFirst(4))
        : lhs.show.title.lowercased()
    let rhs = rhs.show.title.lowercased().hasPrefix("the ")
        ? String(rhs.show.title.lowercased().dropFirst(4))
        : rhs.show.title.lowercased()
    return lhs < rhs
}
