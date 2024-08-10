//
//  ExploreViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import Foundation

@Observable
final class ExploreViewModel {

    var users: [UserModel] = []
    private let userService: IUserService = UserService()
    var isFirstAppear: Bool = true

    func fetchUsers() async {
        GlobalItems.startLoading()
        guard let users = await userService.fetchUsers()
        else {
            GlobalItems.endLoading()
            users = []
            return
        }
        GlobalItems.endLoading()
        self.users = users
    }

    func checkFirstAppear() async {
        if isFirstAppear {
            GlobalItems.startLoading()
            await fetchUsers()
            isFirstAppear = false
            GlobalItems.endLoading()
        }
    }

}
