//
//  PageTitleText.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct PageTitleText: View {
    let title: String
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
    }
}
