//
//  ExploreViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import SwiftUI

@Observable
final class ExploreViewModel {

  init(userService: IUserService) {
    self.userService = userService
    Task { await fetchUsers() }
  }

  var users: [UserModel] = []

  @ObservationIgnored
  private let userService: IUserService

  private var loadingManager: LoadingManager = LoadingManager()

  func setLoadingManager(loadingManager: LoadingManager) {
    self.loadingManager = loadingManager
  }


  func fetchUsers() async {
    loadingManager.startLoading()
    guard let users = await userService.fetchUsers()
    else {
      loadingManager.endLoading()
      users = []
      return
    }
    loadingManager.endLoading()
    self.users = []
    self.users = users
  }

}
