//
//  NormalText.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI
/// Text with Footnote font size
struct NormalText: View {
    let title: String
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
            .font(.footnote)
    }
}
