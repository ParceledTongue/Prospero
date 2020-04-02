//
//  TestData.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import Foundation
import PromiseKit

enum TestData {

    private static var showNames: [String] = {
        // swiftlint:disable:next force_try
        try! String(contentsOf: Bundle.main.url(forResource: "show-names", withExtension: "txt")!)
            .split(separator: "\n")
            .map(String.init)
    }()

    private static var theatres: [Theatre] = {
        // swiftlint:disable:next force_try
        try! String(contentsOf: Bundle.main.url(forResource: "theatre-names", withExtension: "txt")!)
            .split(separator: "\n")
            .map { Theatre(id: UUID(), name: String($0), location: nil) }
    }()

    static func generateRandomShow(id: Int? = nil) -> Show {

        let id = id ?? Int.random(in: 0...99999)
        let seed = generateSeed(from: id)

        return Show(
            id: id,
            name: showNames[seed % showNames.count],
            theatre: theatres[seed % theatres.count]
        )

    }

    static func simulateFetch(showCode: Int) -> Promise<Show> {

        after(.milliseconds(.random(in: 500...3000)))
            .map { _ in
                guard showCode % 3 != 0 else {
                    throw ShowFetchFailure.badCode
                }
                return TestData.generateRandomShow(id: showCode)
            }

    }

    private static func generateSeed(from id: Int) -> Int {
        // https://stackoverflow.com/questions/8509180/hashing-a-small-number-to-a-random-looking-64-bit-integer
        var seed = UInt64(id)
        seed += 1
        seed ^= seed >> 33
        seed &*= 0xff51afd7ed558ccd
        seed ^= seed >> 33
        seed &*= 0xc4ceb9fe1a85ec53
        seed ^= seed >> 33
        return Int(seed % UInt64(Int.max))
    }

}

enum ShowFetchFailure: LocalizedError {

    case badCode

    var errorDescription: String? {
        switch self {
        case .badCode: return "This code is not valid. It may have expired." // TODO localize
        }
    }

}
