//
//  KeyboardModifier.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct KeyboardModifier: ViewModifier {
    @Environment(\.globalItems) private var globalItems
    func body(content: Content) -> some View {
        return
            content
            .onReceive(globalItems.keyboardWillShowPublisher) { notification in
                globalItems.isKeyboardVisible = true
                if let keyboardFrame = notification.userInfo?[
                    UIResponder.keyboardFrameEndUserInfoKey
                ] as? CGRect {
                    globalItems.keyboardHeight = keyboardFrame.height
                }
            }
            .onReceive(globalItems.keyboardWillHidePublisher) { _ in
                globalItems.isKeyboardVisible = false
                globalItems.keyboardHeight = 0
            }
    }
}
