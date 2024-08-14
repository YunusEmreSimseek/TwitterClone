//
//  ToolbarTextModifier.swift
//  TwitterClone
//
//  Created by Emre Simsek on 13.08.2024.
//

import SwiftUI

struct ToolbarTextModifier: ViewModifier {
  let title: String
  func body(content: Content) -> some View {
    return
      content
      .toolbar {
        ToolbarItem(placement: .principal) {
          PageTitleText(title)
        }
      }
  }
}
