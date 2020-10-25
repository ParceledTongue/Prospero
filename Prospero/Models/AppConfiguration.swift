//
//  AppConfiguration.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation

class AppConfiguration: ObservableObject {

    private let productionsKey = "productions"

    private let isOnboardedKey = "isOnboarded"

    @Published private(set) var productions: [Production] {
        didSet {
            do {
                let data = try JSONEncoder().encode(productions)
                UserDefaults.standard.set(data, forKey: productionsKey)
            } catch {
                print("Failed to encode productions to defaults: \(error)")
            }
        }
    }

    @Published var isOnboarded: Bool {
        didSet {
            UserDefaults.standard.set(isOnboarded, forKey: isOnboardedKey)
        }
    }

    init() {
        productions = UserDefaults.standard.data(forKey: productionsKey)
            .flatMap { try? JSONDecoder().decode([Production].self, from: $0) }
            ?? []
        isOnboarded = UserDefaults.standard.bool(forKey: isOnboardedKey)
    }

    func addProduction(_ production: Production) {
        if !productions.contains(where: { $0.id == production.id }) {
            let insertionIndex = productions.firstIndex(where: { productionAtIdx in
                alphabeticalCollator(production, productionAtIdx)
            }) ?? productions.endIndex
            productions.insert(production, at: insertionIndex)
        }
    }

    func removeProductions(atOffsets offsets: IndexSet) {
        productions.remove(atOffsets: offsets)
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
