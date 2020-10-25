//
//  MockServer.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation
import PromiseKit

struct MockServer {

    var latency = DispatchTimeInterval.milliseconds(100)

    func getProduction(for code: String) -> Promise<Production?> {
        after(latency).map { _ in codeMap[code] }
    }

    private let codeMap = [
        "11111" : DemoProductions.constellations,
        "22222" : DemoProductions.stupidFuckingBird,
        "33333" : DemoProductions.worldBuilders
    ]
}

enum DemoProductions {

    static let constellations = Production(
        id: 0,
        show: .init(
            title: "Constellations",
            playwright: .init(
                name: .init(
                    first: "Nick",
                    last: "Payne"
                )
            )
        ),
        company: .init(
            name: "Players' Theatre Group"
        ),
        members: []
    )

    static let stupidFuckingBird = Production(
        id: 1,
        show: .init(
            title: "Stupid Fucking Bird",
            playwright: .init(
                name: .init(
                    first: "Aaron",
                    last: "Posner"
                )
            )
        ),
        company: .init(
            name: "Players' Theatre Group"
        ),
        members: [
            .init(
                person: .init(
                    name: .init(
                        first: "Zach",
                        last: "Palumbo"
                    )
                ),
                email: "zach@palumbo.io"
            )
        ]
    )

    static let worldBuilders = Production(
        id: 2,
        show: .init(
            title: "World Builders",
            playwright: .init(
                name: .init(
                    first: "Johnna",
                    last: "Adams"
                )
            )
        ),
        company: .init(
            name: "convergence-continuum"
        ),
        members: [
            .init(
                person: .init(
                    name: .init(
                        first: "Jonah",
                        last: "Roth"
                    )
                ),
                email: "jonah.r.roth@gmail.com"
            )
        ]
    )

}
