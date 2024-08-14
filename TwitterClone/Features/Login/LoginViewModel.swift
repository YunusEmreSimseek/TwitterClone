//
//  LoginViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

@Observable
final class LoginViewModel {

  init(userService: IUserService) {
    self.userService = userService
  }

  var emailValue: String = ""
  var passwordValue: String = ""
  var errorMessage: String = ""

  var showErrorSheet = false
  var errorSheetMessage = ""

  @ObservationIgnored
  private let userService: IUserService

  private var loadingManager: LoadingManager = LoadingManager()

  private var userManager: UserManager?

  private var navManager: NavigationManager?

  func setManagers(
    loadingManager: LoadingManager, userManager: UserManager, navManager: NavigationManager
  ) {
    self.loadingManager = loadingManager
    self.userManager = userManager
    self.navManager = navManager
  }

  private func navigateToMainTabView(uid: String?) {
    guard !uid.isNullOrEmpty() else {
      print("Fetched user id is nil")
      return
    }
    navManager?.navigate(to_: .mainTab)
  }

  func login() async {
    let user = UserModel(
      email: emailValue,
      password: passwordValue
    )
    guard !user.email.isNullOrEmpty() && !user.password.isNullOrEmpty() else {
      showErrorMessage(title: "Email or password is empty.")
      errorMessage = "Email or password is empty."
      return
    }
    loadingManager.startLoading()
    guard let responseUserId = await userService.loginUser(user: user)?.id
    else {
      loadingManager.endLoading()
      showErrorMessage(title: "Email or password is incorrect.")
      errorMessage = "Email or password is incorrect."
      return
    }
    loadingManager.endLoading()
    errorMessage = ""
    userManager?.changeStateIn(uid: responseUserId)
    navigateToMainTabView(uid: responseUserId)

  }

  private func showErrorMessage(title: String) {
    withAnimation {
      self.errorSheetMessage = title
      self.showErrorSheet = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.showErrorSheet = false
        self.errorSheetMessage = ""
      }
    }
  }

  func navigateRegister() {
    navManager?.navigate(to_: .register)
  }

}
