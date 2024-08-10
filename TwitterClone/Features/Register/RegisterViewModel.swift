//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

@Observable
final class RegisterViewModel {
    var emailValue: String = ""
    var passwordValue: String = ""
    var nameValue: String = ""
    @ObservationIgnored
    private let userService: IUserService
    
    init(userService: IUserService){
        self.userService = userService
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
        else { return }
        GlobalItems.startLoading()
        guard let responseUser = await userService.createUser(user: user)
        else {
            GlobalItems.endLoading()
            return
        }
        GlobalItems.endLoading()
        GlobalItems.setCurrentUser(user: responseUser)
        navigateToMainTabView()

    }

    private func navigateToMainTabView() {
        NavigationManager.navigate(to_: .mainTab)
    }
}
