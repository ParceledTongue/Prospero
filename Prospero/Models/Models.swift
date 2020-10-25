//
//  Models.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation

struct Production: Identifiable {

    struct Member {
        let person: Person
        let email: String
    }

    let id: Int
    let show: Show
    let company: Company
    let members: [Member]
}

struct Show {
    let title: String
    let playwright: Person
}

struct Company {
    let name: String
}

struct Person {

    struct Name {
        let first: String
        let last: String
        let middle: String = ""
    }

    let name: Name

}
