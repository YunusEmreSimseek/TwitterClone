//
//  UnderlinedImageTextField.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct UnderlinedImageTextField: View {
  let iconName: String
  let placeHolder: String
  @Binding var text: String
  var body: some View {
    VStack {
      HStack(spacing: .dynamicWidth(width: 0.05)) {
        Image(systemName: iconName)
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .foregroundStyle(.cBlue)
          .background(.cWhite)
          .frame(width: .dynamicHeight(height: 0.025), height: .dynamicHeight(height: 0.025))

        TextField(placeHolder, text: $text)
          .font(.footnote)
      }
      .vPadding()

      Divider()
        .background(.primary)
    }
  }
}
