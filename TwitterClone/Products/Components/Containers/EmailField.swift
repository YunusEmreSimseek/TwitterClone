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
                Image(.newemail)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(.cBlue)
                    .background(.cWhite)
//                    .frame(width: .dynamicWidth(width: 0.05))
                    .frame(width: .dynamicHeight(height: 0.025),height: .dynamicHeight(height: 0.025))

                    
                    

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
