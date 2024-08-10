//
//  PasswordField.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct PasswordField: View {
    @Binding var text: String
    var body: some View {
        VStack {
            HStack(spacing: .dynamicWidth(width: 0.05)) {
                Image(.password)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .dynamicWidth(width: 0.06))

                SecureField("Password", text: $text)
                    .font(.footnote)
            }
            .vPadding()

            Divider()
                .background(.primary)
        }
    }
}
