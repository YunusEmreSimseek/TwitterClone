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
        Image(.password2)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .foregroundStyle(.cBlue)
          .background(.cWhite)
          .frame(width: .dynamicHeight(height: 0.025),height: .dynamicHeight(height: 0.025))

        SecureField("Password", text: $text)
          .font(.footnote)
      }
      .vPadding()

      Divider()
        .background(.primary)
    }
  }
}
