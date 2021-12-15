//
//  String+nonBreaking.swift
//  Prospero
//
//  Created by Zach Palumbo on 6/28/21.
//

import Foundation

extension String {

    static let nbsp = "\u{00A0}"

    var nonBreaking: String { replacingOccurrences(of: " ", with: String.nbsp) }

}
