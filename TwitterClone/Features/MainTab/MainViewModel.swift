//
//  MainTabViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 8.08.2024.
//

import Foundation

@Observable
final class MainViewModel {
    var currentUser = GlobalItems.instance.currentUser
    @ObservationIgnored private var userService: IUserService

    init(userService: IUserService) {
        self.userService = userService
    }

    func checkUser() async {
        let response = checkCurrentUser()
        if !response {
            guard let user = await checkAuthUser() else {
                navigateToLogin()
                return
            }
            GlobalItems.setCurrentUser(user: user)
            navigateToMainTab()
            return
        }
        else {
            navigateToMainTab()
            return
        }
    }

    private func checkCurrentUser() -> Bool {
        guard currentUser != nil else { return false }
        return true
    }

    private func checkAuthUser() async -> UserModel? {
        return await userService.checkCurrentUser()
    }

    private func navigateToLogin() {
        NavigationManager.navigate(to_: .login)
    }

    func navigateToMainTab() {
        NavigationManager.navigate(to_: .mainTab)
    }
}
