//
//  ErrorSheetModifier.swift
//  TwitterClone
//
//  Created by Emre Simsek on 12.08.2024.
//

import SwiftUI

struct ErrorSheetModifier: ViewModifier {
  @Binding var isPresented: Bool
  @Binding var errorMessage: String

  init(isPresented: Binding<Bool>, errorMessage: Binding<String>) {
    self._isPresented = isPresented
    self._errorMessage = errorMessage
    close()
  }

  func body(content: Content) -> some View {
    return
      content
      .sheet(
        isPresented: $isPresented,
        content: {
          Text(errorMessage)
            .allPadding()
            //            .topPadding()
            .presentationDetents([.height(.dynamicHeight(height: 0.1))])
        })
  }

  func close() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.isPresented = false
      self.errorMessage = ""
    }
  }
}
