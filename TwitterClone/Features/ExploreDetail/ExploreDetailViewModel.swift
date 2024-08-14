//
//  ExploreDetailViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import Foundation

@Observable
final class ExploreDetailViewModel {

  private let tweetService = TweetService()
  var tweets: [TweetModel] = []
  var selectedTab: UserProfileTabs = .tweets
  let uid: String?
  private(set) var user: UserModel
  private var loadingManager: LoadingManager?
  func setLoadingManager(loadingManager: LoadingManager) {
    self.loadingManager = loadingManager
  }

  init(user: UserModel, tweetService: ITweetService, uid: String?) {
    self.uid = uid
    self.user = user
    Task {
      await fetchUserTweets(user: user)
    }
  }

  func fetchUserTweets(user: UserModel) async {
    guard let tweets = await tweetService.fetchUserTweets(user: user)
    else {
      return
    }
    self.tweets = tweets
  }

  func likeTweet(tweet: TweetModel) async {
    guard let currentUserId = uid
    else {
      return
    }
    loadingManager?.startLoading()
    guard let likedUserIds = tweet.likedUserIds
    else {
      guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
      else {
        loadingManager?.endLoading()
        return
      }
      if let index = tweets.firstIndex(where: { inTweet in
        inTweet.id == tweet.id
      }) {
        tweets[index] = updatedTweet
      }
      loadingManager?.endLoading()
      return
    }
    let isContain = likedUserIds.contains(currentUserId)
    if isContain {
      guard
        let updatedTweet = await tweetService.dislikeTweet(tweet: tweet, uid: currentUserId)
      else {
        loadingManager?.endLoading()
        return
      }
      if let index = tweets.firstIndex(where: { inTweet in
        inTweet.id == tweet.id
      }) {
        tweets[index] = updatedTweet
      }
      loadingManager?.endLoading()
      return
    } else {
      guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
      else {
        loadingManager?.endLoading()
        return
      }
      if let index = tweets.firstIndex(where: { inTweet in
        inTweet.id == tweet.id
      }) {
        tweets[index] = updatedTweet
      }
      loadingManager?.endLoading()
      return
    }
  }

}
