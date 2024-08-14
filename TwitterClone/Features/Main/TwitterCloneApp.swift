//
//  TwitterCloneApp.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import FirebaseCore
import SwiftUI

@main
struct TwitterCloneApp: App {

  @State private var userManager: UserManager
  @State private var navManager: NavigationManager
  @State private var loadingManager: LoadingManager
  @State private var keyboardManager: KeyboardManager

  init() {
    FirebaseApp.configure()
    let tweetService = TweetService()
    userManager = UserManager(tweetService: tweetService)
    navManager = NavigationManager()
    loadingManager = LoadingManager()
    keyboardManager = KeyboardManager()
  }

  var body: some Scene {
    WindowGroup {
      MainNavigationView()
        .environment(userManager)
        .environment(navManager)
        .environment(loadingManager)
        .environment(keyboardManager)
    }
  }
}
