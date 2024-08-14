//
//  ReplyService.swift
//  TwitterClone
//
//  Created by Emre Simsek on 13.08.2024.
//

import FirebaseFirestore
import SwiftUI

protocol IReplyService {
  func fetchReply(id: String) async -> ReplyModel?
  func createReply(reply: FirebaseReplyModel) async -> Bool
  func fetchTweetReplies(tweetId: String) async -> [ReplyModel]?
  func addListenerTweetReplies(
    tweetId: String, onActive: @escaping ([DocumentChange]) async -> Void
  )
}

final class ReplyService: IReplyService {

  init(userService: IUserService) {
    self.userService = userService
  }

  private var replyCollection = Firestore.firestore().collection(FirebaseCollections.reply.rawValue)
  private let userService: IUserService

  func addListenerTweetReplies(
    tweetId: String, onActive: @escaping ([DocumentChange]) async -> Void
  ) {
    replyCollection.whereField("tweetId", isEqualTo: tweetId)
      .addSnapshotListener { snapshot, error in
        guard let changes = snapshot?.documentChanges else { return }
        guard !changes.isEmpty else { return }
        Task { await onActive(changes) }
      }
  }

  func fetchTweetReplies(tweetId: String) async -> [ReplyModel]? {
    do {
      let documents =
        try await replyCollection
        //            .order(by: "createdAt", descending: true)
        .whereField("tweetId", isEqualTo: tweetId)
        .getDocuments().documents
      var fetchedReplies: [ReplyModel] = []
      for document in documents {
        guard
          let reply = try? Firestore.Decoder().decode(
            FirebaseReplyModel.self, from: document.data())
        else {
          print("REPLYSERVICE: Error decoding reply")
          return nil
        }
        guard let user = await fetchReplyUser(uid: reply.ownerId ?? "")
        else {
          print("REPLYSERVICE: Error fetching reply user")
          return nil
        }
        let replyModel = reply.toReplyModel(owner: user)
        fetchedReplies.append(replyModel)
      }
      return fetchedReplies

    } catch {
      print("REPLYSERVICE: Error fetching tweet replies \(error)")
      return nil
    }
  }

  func fetchReply(id: String) async -> ReplyModel? {
    do {
      let response = try await replyCollection.document(id).getDocument()
      guard
        let reply = try? Firestore.Decoder().decode(
          FirebaseReplyModel.self, from: response.data() ?? Data())
      else {
        print("REPLYSERVICE: Error decoding reply")
        return nil
      }
      guard let user = await fetchReplyUser(uid: reply.ownerId ?? "")
      else {
        print("REPLYSERVICE: Error fetching reply user")
        return nil
      }
      let replyModel = reply.toReplyModel(owner: user)
      return replyModel
    } catch {
      print("REPLYSERVICE: Error fetching reply \(error)")
      return nil
    }
  }

  func createReply(reply: FirebaseReplyModel) async -> Bool {
    guard let data = try? Firestore.Encoder().encode(reply)
    else {
      print("REPLYSERVICE: Error encoding reply")
      return false

    }
    guard let id = reply.id else {
      print("REPLYSERVICE: Error getting id")
      return false
    }
    do {
      try await replyCollection.document(id).setData(data)
      return true
    } catch {
      print("REPLYSERVICE: Error adding reply to collection \(error)")
      return false
    }
  }

  private func fetchReplyUser(uid: String) async -> UserModel? {
    return await userService.fetchUser(userId: uid)
  }
}
