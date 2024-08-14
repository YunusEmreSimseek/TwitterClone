//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

@Observable
final class RegisterViewModel {

  init(userService: IUserService) {
    self.userService = userService
  }

  var emailValue: String = ""
  var passwordValue: String = ""
  var nameValue: String = ""
  var showSheet: Bool = false
  var registerUser: UserModel = UserModel()

  var showError = false
  var errorMessage = ""

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

  func register() async {
    let user = UserModel(
      name: nameValue,
      email: emailValue,
      password: passwordValue
    )
    guard
      !user.name.isNullOrEmpty() && !user.email.isNullOrEmpty()
        && !user.password.isNullOrEmpty()
    else {
      showErrorMessage(title: "Please fill in all fields.")
      return
    }
    loadingManager.startLoading()
    guard let responseUser = await userService.createUser(user: user)
    else {
      loadingManager.endLoading()
      showErrorMessage(
        title:
          "Wrong email or password. Please try again.")
      return
    }
    loadingManager.endLoading()
    registerUser = responseUser
    withAnimation(.easeInOut) {
      showSheet = true
    }

  }

  func navigateToMainTabView() {
    guard let uid = registerUser.id else { return }
    userManager?.changeStateIn(uid: uid)
    navManager?.navigate(to_: .mainTab)
  }

  private func showErrorMessage(title: String) {
    withAnimation {
      self.errorMessage = title
      self.showError = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.showError = false
        self.errorMessage = ""
      }
    }
  }

  func navigateLogin() {
    navManager?.navigateToBack()
  }

}
