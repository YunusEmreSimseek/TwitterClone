//
//  LoadingManager.swift
//  TwitterClone
//
//  Created by Emre Simsek on 11.08.2024.
//

import SwiftUI

@Observable
final class LoadingManager {
  var isLoading: Bool = false

  func startLoading() {
    isLoading = true
  }

  func endLoading() {
    isLoading = false
  }

  func changeLoading(_ value: Bool) {
    isLoading = value
  }
}

struct LoadingManagerKey: EnvironmentKey {
  static var defaultValue = LoadingManager()
}
