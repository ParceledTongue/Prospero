//
//  ActivityIndicator.swift
//  Prospero
//
//  Created by Zach Palumbo on 4/2/20.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(
        context: UIViewRepresentableContext<ActivityIndicator>
    ) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: UIViewRepresentableContext<ActivityIndicator>)
    {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }

}
