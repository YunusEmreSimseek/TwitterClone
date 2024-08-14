//
//  LoadingModifier.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
    func body(content: Content) -> some View {
        return
            content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LoadingView()
                }
            }
    }
}
