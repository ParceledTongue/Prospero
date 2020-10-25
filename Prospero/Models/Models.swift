//
//  Models.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation

struct Production: Identifiable, Codable {

    struct Member: Codable {
        let person: Person
        let email: String
    }

    let id: Int
    let show: Show
    let company: Company
    let members: [Member]
}

struct Show: Codable {
    let title: String
    let playwright: Person
}

struct Company: Codable {
    let name: String
}

struct Person: Codable {

    struct Name: Codable {
        let first: String
        let last: String
        let middle: String?

        init(
            first: String,
            last: String,
            middle: String? = nil
        ) {
            self.first = first
            self.last = last
            self.middle = middle
        }
    }

    let name: Name

}
