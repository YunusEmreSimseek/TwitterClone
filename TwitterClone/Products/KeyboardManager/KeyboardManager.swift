//
//  KeyboardManager.swift
//  TwitterClone
//
//  Created by Emre Simsek on 12.08.2024.
//

import SwiftUI

@Observable
final class KeyboardManager {

  var isKeyboardVisible: Bool = false

  var keyboardHeight: CGFloat = 0

  var keyboardWillShowPublisher = NotificationCenter.default.publisher(
    for: UIResponder.keyboardWillShowNotification
  )

  var keyboardWillHidePublisher = NotificationCenter.default.publisher(
    for: UIResponder.keyboardWillHideNotification
  )

  func showKeyboard() {
    isKeyboardVisible = true
  }

  func dismissKeyboard() {
    isKeyboardVisible = false
  }

}

struct KeyboardManagerKey: EnvironmentKey {
  static var defaultValue = KeyboardManager()
}
