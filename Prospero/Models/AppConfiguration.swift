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

    @Published private(set) var productions: [UserProduction] {
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
            .flatMap { try? JSONDecoder().decode([UserProduction].self, from: $0) }
            ?? []
        isOnboarded = UserDefaults.standard.bool(forKey: isOnboardedKey)
    }

    func addProduction(_ production: UserProduction) {
        productions.insert(production, at: 0)
    }

    func removeProductions(atOffsets offsets: IndexSet) {
        productions.remove(atOffsets: offsets)
    }

    func moveProductions(fromOffsets source: IndexSet, toOffset destination: Int) {
        productions.move(fromOffsets: source, toOffset: destination)
    }
}
