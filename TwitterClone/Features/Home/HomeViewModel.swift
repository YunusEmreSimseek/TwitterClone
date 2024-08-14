//
//  HomeViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import FirebaseFirestore
import SwiftUI

@Observable
final class HomeViewModel {

  @ObservationIgnored
  private var tweetService: ITweetService

  @ObservationIgnored
  private var userService: IUserService

  @ObservationIgnored
  private var replyService: IReplyService

  var tweets: [TweetModel] = []

  private var loadingManager: LoadingManager?

  private(set) var userManager: UserManager?

  private var navManager: NavigationManager?

  private var cacheManager = CacheManager()

  private var tweetListener: ListenerRegistration?

  init(tweetService: ITweetService, userService: IUserService, replyService: IReplyService) {
    self.tweetService = tweetService
    self.userService = userService
    self.replyService = replyService
    addListener()
  }

  func addListener()  {
    let tweetCollection = Firestore.firestore().collection(FirebaseCollections.tweet.rawValue)
    tweetListener = tweetCollection.addSnapshotListener { snapshot, error in
      print("changes: \(snapshot?.documentChanges.description ?? "nil")")
      guard let changedDocuments = snapshot?.documentChanges else { return }
      Task { await self.getTweetsById(documents: changedDocuments) }
      print("Tweet listener activated")
    }
  }

  func getTweetsById(documents: [DocumentChange]) async {
    for document in documents {
      guard
        let data = try? Firestore.Decoder().decode(
          FirebaseTweetModel.self, from: document.document.data())
      else { return }
      guard let user = await userService.fetchUser(userId: data.ownerId ?? "")
      else { return }
      let replies = await replyService.fetchTweetReplies(tweetId: data.id ?? "")
      let tweet = data.toTweetModel(owner: user, replies: replies)
      if let index = tweets.firstIndex(where: { inTweet in
        inTweet.id == tweet.id
      }) {
        tweets[index] = tweet
      } else {
        tweets.append(tweet)
      }
    }
  }

  func setManagers(
    loadingManager: LoadingManager, userManager: UserManager, navManager: NavigationManager
  ) {
    self.loadingManager = loadingManager
    self.userManager = userManager
    self.navManager = navManager
  }

  func getTweets() async {

    loadingManager?.startLoading()
    guard let response = await tweetService.fetchTweets()
    else {
      tweets = []
      loadingManager?.endLoading()
      return
    }
    tweets = response
    cacheManager.saveTweets(tweets: response)
    loadingManager?.endLoading()
    return
  }

  func likeTweet(tweet: TweetModel) async {
    guard let currentUserId = userManager?.userId
    else {
      return
    }
    loadingManager?.startLoading()
    guard let likedUserIds = tweet.likedUserIds
    else {
      let _ = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
      loadingManager?.endLoading()
      return
    }
    let isContain = likedUserIds.contains(currentUserId)
    if isContain {
      let _ = await tweetService.dislikeTweet(tweet: tweet, uid: currentUserId)
      loadingManager?.endLoading()
      return
    } else {
      let _ = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
      loadingManager?.endLoading()
      return
    }

  }

  func navigateTweetDetail(tweet: TweetModel) {
    navManager?.navigate(to_: .tweetDetail(tweet: tweet))
  }

}
