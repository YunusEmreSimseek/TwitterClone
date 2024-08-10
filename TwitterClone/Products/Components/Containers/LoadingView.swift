//
//  LoadingView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct LoadingView: View {
    @Environment(\.globalItems) var globalItems
    var body: some View {
        ProgressView()
            .scaleEffect(globalItems.isLoading ? 1.5 : 0)
    }
}
