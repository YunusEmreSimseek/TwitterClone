//
//  MainTabViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 8.08.2024.
//

import Foundation

@Observable
final class MainViewModel {
  @ObservationIgnored private var userService: IUserService

  private var userManager: UserManager?

  private var navManager: NavigationManager?

  func setManagers(userManager: UserManager, navManager: NavigationManager) {
    self.userManager = userManager
    self.navManager = navManager
  }

  init(userService: IUserService) {
    self.userService = userService
  }

  func checkUser() async {
    let response = checkCurrentUser()
    if !response {
      guard let uid = await checkAuthUser() else {
        if userManager?.state == .signedIn {
          userManager?.changeStateOut()
        }
        navigateToLogin()
        return
      }
      userManager?.changeStateIn(uid: uid)
      navigateToMainTab()
      return
    }
    navigateToMainTab()
  }

  private func checkCurrentUser() -> Bool {
    if userManager?.state == .signedIn {
      return true
    } else {
      return false
    }
  }

  private func checkAuthUser() async -> String? {
    return await userService.checkCurrentUser()
  }

  private func navigateToLogin() {
    navManager?.navigate(to_: .login)
  }

  private func navigateToMainTab() {
    navManager?.navigate(to_: .mainTab)
  }
}
