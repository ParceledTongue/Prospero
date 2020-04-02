//
//  Theatre.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/1/20.
//

import Foundation
import CoreLocation

struct Theatre: Identifiable {
    let id: UUID
    let name: String
    let location: CLPlacemark?
}
