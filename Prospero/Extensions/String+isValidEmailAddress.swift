//
//  String+isValidEmailAddress.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/25/20.
//

import Foundation

extension String {

    /**
     Whether this string is a valid email address.
     */
    var isValidEmailAddress: Bool {
        // via emailregex.com
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

}
