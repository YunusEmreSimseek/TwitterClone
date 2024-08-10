//
//  TitleButtonText.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

/// Text with Headline font size
struct TitleButtonText: View {
    let title: String
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
            .font(.headline)
    }
}
