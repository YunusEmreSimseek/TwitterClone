//
//  EmailField.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct EmailField: View {
    @Binding var text: String
    var body: some View {
        VStack {
            HStack(spacing: .dynamicWidth(width: 0.05)) {
                Image(.email)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .dynamicWidth(width: 0.06))

                TextField("Email", text: $text)
                    .font(.footnote)
                    .keyboardType(.emailAddress)
            }
            .vPadding()

            Divider()
                .background(.primary)
        }
    }
}
