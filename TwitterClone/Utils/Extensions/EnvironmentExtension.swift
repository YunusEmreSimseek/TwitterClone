//
//  EnvironmentExtension.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

extension EnvironmentValues {

  var navManager: NavigationManager {
    get { self[NavigationManagerKey.self] }
    set { self[NavigationManagerKey.self] = newValue }
  }

  var loadingManager: LoadingManager {
    get { self[LoadingManagerKey.self] }
    set { self[LoadingManagerKey.self] = newValue }
  }

  var keyboardManager: KeyboardManager {
    get { self[KeyboardManagerKey.self] }
    set { self[KeyboardManagerKey.self] = newValue }
  }

  var userManager: UserManager {
    get { self[UserManagerKey.self] }
    set { self[UserManagerKey.self] = newValue }
  }
}
