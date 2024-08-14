//
//  ToolbarBackButtonModifiger.swift
//  TwitterClone
//
//  Created by Emre Simsek on 13.08.2024.
//

import SwiftUI

struct ToolbarBackButtonModifier: ViewModifier {
  @Environment(\.navManager) private var navManager
  func body(content: Content) -> some View {
    return
      content
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(
            action: {
              navManager.navigateToBack()
            },
            label: {
              Image(systemName: "arrow.left")
                .foregroundStyle(.cBlack)
            }
          )
        }
      }
  }
}
