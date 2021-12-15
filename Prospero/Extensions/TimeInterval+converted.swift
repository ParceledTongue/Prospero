//
//  TimeInterval+converted.swift
//  Prospero
//
//  Created by Zach Palumbo on 12/15/21.
//

import Foundation

extension TimeInterval {

    func converted(to units: UnitDuration) -> Double {
        Measurement(value: self, unit: .seconds).converted(to: units).value
    }

}
