//
//  KeyboardModifier.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct KeyboardModifier: ViewModifier {
  @State var keyboardManager: KeyboardManager
  func body(content: Content) -> some View {
    return
      content
      .onReceive(keyboardManager.keyboardWillShowPublisher) { notification in
        keyboardManager.showKeyboard()
        if let keyboardFrame = notification.userInfo?[
          UIResponder.keyboardFrameEndUserInfoKey
        ] as? CGRect {
          keyboardManager.keyboardHeight = keyboardFrame.height
        }
      }
      .onReceive(keyboardManager.keyboardWillHidePublisher) { _ in
        keyboardManager.dismissKeyboard()
        keyboardManager.keyboardHeight = 0
      }
  }
}
