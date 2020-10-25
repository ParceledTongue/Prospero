//
//  NotBindingPrefix.swift
//  Prospero
//
//  Created by Zach Palumbo on 10/24/20.
//

import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
