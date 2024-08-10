//
//  UnderlinedImageTextField.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct UnderlinedImageTextField: View {
    let iconName: ImageResource
    let placeHolder: String
    @Binding var text: String
    var body: some View {
        VStack {
            HStack(spacing: .dynamicWidth(width: 0.05)) {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .dynamicWidth(width: 0.06))

                TextField(placeHolder, text: $text)
                    .font(.footnote)
            }
            .vPadding()

            Divider()
                .background(.primary)
        }
    }
}
