//
//  ElevatedButton.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct ElevatedButton: View {
    let title: String
    let onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Spacer()
                TitleButtonText(title)
                    .foregroundStyle(.cWhite)
                Spacer()
            }
            .frame(height: .dynamicHeight(height: 0.07))
            .background(.cBlue)
            .clipShape(.rect(cornerRadius: 15))

        }
    }
}

#Preview {
    ElevatedButton(title: "Sign in") {

    }
}
