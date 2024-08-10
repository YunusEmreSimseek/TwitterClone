//
//  LoginViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

@Observable
final class LoginViewModel {
    var emailValue: String = ""
    var passwordValue: String = ""
    var errorMessage: String = ""
    @ObservationIgnored
    private let userService: IUserService

    init(userService: IUserService) {
        self.userService = userService
    }

    private func navigateToMainTabView() {
        NavigationManager.navigate(to_: .mainTab)
    }

    func login() async {
        let user = UserModel(
            email: emailValue,
            password: passwordValue
        )
        guard !user.email.isNullOrEmpty() && !user.password.isNullOrEmpty() else {
            errorMessage = "Email or password is empty."
            return
        }
        GlobalItems.startLoading()
        guard let responseUser = await userService.loginUser(user: user)
        else {
            GlobalItems.endLoading()
            errorMessage = "Email or password is incorrect."
            return
        }
        GlobalItems.endLoading()
        GlobalItems.setCurrentUser(user: responseUser)
        errorMessage = ""
        navigateToMainTabView()

    }
}
