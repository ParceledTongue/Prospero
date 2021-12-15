//
//  Models.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import Foundation
import PhoneNumberKit

struct Production: Equatable, Codable {

    struct Member: Equatable, Codable {
        let person: Person
        let email: String
        let phoneNumber: PhoneNumber
        var name: PersonNameComponents { person.name }
    }

    let show: Show
    let company: Company
    let members: [Member]
}

struct UserProduction: Equatable, Identifiable, Codable {

    let id: UUID
    let production: Production
    let member: Production.Member
    var show: Show { production.show }
    var company: Company { production.company }
    var members: [Production.Member] { production.members }
    var person: Person { member.person }

}

struct Show: Equatable, Codable {
    let title: String
    let playwright: Person
}

struct Company: Equatable, Codable {
    let name: String
}

struct Person: Equatable, Codable {
    let name: PersonNameComponents
}
