//
//  UserManager.swift
//  TwitterClone
//
//  Created by Emre Simsek on 10.08.2024.
//

import FirebaseFirestore
import SwiftUI

enum UserState {
  case signedIn
  case signedOut
}

@Observable
final class UserManager {

  private(set) var state: UserState = .signedOut

  var user: UserModel?

  var userTweets: [TweetModel] = []

  var likedTweets: [TweetModel] = []

  var userId: String? {
    return user?.id
  }
  var userName: String? {
    return user?.name
  }
  var userEmail: String? {
    return user?.email
  }
  var userPassword: String? {
    return user?.password
  }

  var userImageUrl: String? {
    return user?.imageUrl
  }
  var userTag: String? {
    return user?.tag
  }
  var userBio: String? {
    return user?.bio
  }
  var userFollowingUsers: [String]? {
    return user?.followingUsers
  }
  var userFollowerUsers: [String]? {
    return user?.followerUsers
  }

  private func setIdAndStartListening(uid: String) {
    print("listener activated uid: \(uid)")
    configureUserListener(id: uid)
  }

  private func removeListener() {
    userStateListener?.remove()
    print("listener removed")
  }

  func changeStateIn(uid: String) {
    setIdAndStartListening(uid: uid)
    self.state = .signedIn
  }

  func changeStateOut() {
    removeListener()
    deleteUser()
    self.state = .signedOut
  }

  private var userCollection = Firestore.firestore().collection(FirebaseCollections.user.rawValue)
  private var userStateListener: ListenerRegistration?
  private var tweetService: ITweetService

  init(tweetService: ITweetService) {
    self.tweetService = tweetService
  }

  private func configureUserListener(id: String) {
    userStateListener = userCollection.document(id)
      .addSnapshotListener({ snapshot, error in
        guard let data = snapshot?.data() else { return }
        guard
          let data = try? Firestore.Decoder()
            .decode(UserModel.self, from: data)
        else { return }
        Task {
          await self.getUserTweets(user: data)
        }
        self.updateState(user: data)
      })
  }

  private func updateState(user: UserModel) {
    self.user = user
    print("UserManager: User updated")
  }

  private func getUserTweets(user: UserModel) async {
    guard let response = await tweetService.fetchUserTweets(user: user)
    else { return }
    self.userTweets = response
  }

  func hasUser() -> Bool {
    return user != nil
  }

  private func deleteUser() {
    self.user = nil
    self.userTweets = []
    self.likedTweets = []
  }
}

struct UserManagerKey: EnvironmentKey {
  static var defaultValue = UserManager(tweetService: TweetService())
}
