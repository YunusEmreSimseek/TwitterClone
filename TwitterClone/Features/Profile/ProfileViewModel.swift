//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import FirebaseFirestore
import SwiftUI

@Observable
final class ProfileViewModel {

  @ObservationIgnored
  private var userService: IUserService = UserService()

  @ObservationIgnored
  private var imageService: ImageService = ImageService()

  @ObservationIgnored
  private var tweetService: ITweetService = TweetService()

  private var loadingManager: LoadingManager = LoadingManager()

  private(set) var userManager: UserManager?

  private var navManager: NavigationManager?

  func setManagers(
    loadingManager: LoadingManager, userManager: UserManager, navManager: NavigationManager
  ) {
    self.loadingManager = loadingManager
    self.userManager = userManager
    self.navManager = navManager
  }

  var selectedTab: UserProfileTabs = .tweets
  var selectedImage: UIImage?
  var userTweets: [TweetModel] = []
  var likedTweets: [TweetModel] = []
  var showSheet: Bool = false
  private var userTweetsListener: ListenerRegistration?
  private var userListener: ListenerRegistration?

  func configureUserListener(uid: String) {
    userTweetsListener = tweetService.addListenerToUserTweets(uid: uid) { tweets in
      guard tweets != nil else { return }
      self.userTweets = tweets!
    }
  }

  func actionTweet(tweet: TweetModel) async {
    guard let currentUserId = userManager?.userId
    else {
      return
    }
    guard let likedUserIds = tweet.likedUserIds
    else {
      guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
      else {
        return
      }
      updateUserTweets(tweet: updatedTweet)
      updateLikedTweets(tweet: updatedTweet)
      return
    }
    let isContain = likedUserIds.contains(currentUserId)
    if isContain {
      guard
        let updatedTweet = await tweetService.dislikeTweet(tweet: tweet, uid: currentUserId)
      else {
        return
      }
      updateUserTweets(tweet: updatedTweet)
      updateLikedTweets(tweet: updatedTweet)
      return
    } else {
      guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
      else {
        return
      }
      updateUserTweets(tweet: updatedTweet)
      updateLikedTweets(tweet: updatedTweet)
      return
    }

  }

  private func updateUserTweets(tweet: TweetModel) {
    if let index = userTweets.firstIndex(where: { inTweet in
      inTweet.id == tweet.id
    }) {
      userTweets[index] = tweet
    }
  }

  private func updateLikedTweets(tweet: TweetModel) {
    if let index = likedTweets.firstIndex(where: { inTweet in
      inTweet.id == tweet.id
    }) {
      likedTweets.remove(at: index)
    } else {
      likedTweets.append(tweet)
      return
    }
  }

  func getUserTweets(user: UserModel?) async {
    guard user != nil else { return }
    guard let response = await tweetService.fetchUserTweets(user: user!)
    else {
      return
    }
    userTweets = response
  }

  func getLikedTweets(uid: String?) async {
    guard uid != nil && !uid!.isEmpty else { return }
    guard let response = await tweetService.fetchLikedTweets(uid: uid!)
    else {
      return
    }
    likedTweets = response
  }

  func signOut() {
    userService.signOut()
    userManager?.changeStateOut()
    navigateToLoginView()
  }

  private func navigateToLoginView() {
    navManager?.navigate(to_: .login)
  }

}
