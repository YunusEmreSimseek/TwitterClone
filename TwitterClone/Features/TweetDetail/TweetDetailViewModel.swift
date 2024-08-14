//
//  TweetDetailViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 13.08.2024.
//

import FirebaseFirestore
import SwiftUI

@Observable
final class TweetDetailViewModel {

  var text = ""

  var showReplyField = false

  var showResponseSheet = false

  var showReplies = false

  var responseSheetMessage = ""

  private(set) var userManager: UserManager?

  @ObservationIgnored
  private let replyService: IReplyService

  @ObservationIgnored
  private let tweetService: ITweetService

  @ObservationIgnored
  private let userService: IUserService

  var tweet: TweetModel

  var replies: [ReplyModel]?

  //  @ObservationIgnored
  var tweetOwner: UserModel?

  init(
    replyService: IReplyService,
    tweetService: ITweetService,
    userService: IUserService,
    tweet: TweetModel,
    user: UserModel?
  ) {
    self.replyService = replyService
    self.tweetService = tweetService
    self.userService = userService
    self.tweet = tweet
    self.tweetOwner = user
    self.replies = tweet.replies
    //    self.addTweetListener(tweetId: tweet.id)
  }

  func setUserManager(userManager: UserManager) {
    self.userManager = userManager
  }

  func submitReply() async {
    guard !text.isEmpty else {
      responseSheetMessage = "Reply cannot be empty"
      showResponseSheet = true
      return
    }
    guard userManager != nil else { return }
    let reply = FirebaseReplyModel(
      id: UUID().uuidString,
      content: text,
      tweetId: tweet.id,
      ownerId: userManager?.userId,
      createdAt: Date()
    )
    let response = await replyService.createReply(reply: reply)
    if response {
      responseSheetMessage = "Reply sent successfully"
      showResponseSheet = true
      text = ""
      showReplyField = false
    } else {
      responseSheetMessage = "Error sending reply"
      showResponseSheet = true
    }
  }

  func addTweetListener(tweetId: String?) {
    guard tweetId != nil else { return }

    replyService.addListenerTweetReplies(tweetId: tweetId!) { changes in
      Task { await self.updateReplies(changes: changes) }
      print("reply listener activated")
      print("changes document: \(changes)")
    }

    guard let tweetOwnerId = tweetOwner?.id else { return }
    userService.addListenerUser(uid: tweetOwnerId) { tweetOwnerUser in
      self.tweetOwner = tweetOwnerUser
      print("tweet owner listener activated")
    }
  }

  func fetchCurrentTweet() {

  }

  func updateReplies(changes: [DocumentChange]) async {
    for change in changes {
      guard
        let reply = try? Firestore.Decoder().decode(
          FirebaseReplyModel.self,
          from: change.document.data()
        )
      else { return }
      if let index = replies?.firstIndex(where: { inReply in
        inReply.id == reply.id
      }) {
        replies?[index] = reply.toReplyModel(owner: replies?[index].owner ?? UserModel())
      } else {
        guard let user = await userService.fetchUser(userId: reply.ownerId ?? "")
        else {
          return
        }
        let newReply = reply.toReplyModel(owner: user)
        replies?.append(newReply)
      }
    }
  }

  func follow() async {
    guard let user = userManager?.user else { return }
    guard let targetUser = tweetOwner else { return }
    let _ = await userService.followUser(user: user, targetUser: targetUser)
  }

  func checkFollowing() -> Bool {
    guard let tweetOwner = tweetOwner else { return false }
    guard let userManager = userManager else { return false }
    return tweetOwner.followerUsers?.contains(userManager.userId ?? "") ?? false
      && userManager.userFollowingUsers?.contains(tweetOwner.id ?? "") ?? false

  }
}
