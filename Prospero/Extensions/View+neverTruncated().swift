//
//  View+neverTruncated().swift
//  Prospero
//
//  Created by Zach Palumbo on 6/28/21.
//

import Foundation
import SwiftUI

extension View {

    func neverTruncated() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }

}
