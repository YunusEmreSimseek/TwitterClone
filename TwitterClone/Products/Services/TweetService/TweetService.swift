//
//  TweetService.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import FirebaseFirestore

protocol ITweetService {
  func fetchTweets() async -> [TweetModel]?
  func fetchUserTweets(user: UserModel) async -> [TweetModel]?
  func createTweet(tweet: FirebaseTweetModel) async -> Bool
  func likeTweet(tweet: TweetModel, uid: String) async -> TweetModel?
  func dislikeTweet(tweet: TweetModel, uid: String) async -> TweetModel?
  func fetchLikedTweets(uid: String) async -> [TweetModel]?
  func addListenerToUserTweets(uid: String, updateState: @escaping ([TweetModel]?) -> Void)
    -> ListenerRegistration
}

final class TweetService: ITweetService {
  private let userService: IUserService = UserService()
  private let tweetCollection = Firestore.firestore()
    .collection(FirebaseCollections.tweet.rawValue)
  private var fetchedUserTweets: [TweetModel] = []
  private let replyService: IReplyService = ReplyService(userService: UserService())

  func addListenerToUserTweets(uid: String, updateState: @escaping ([TweetModel]?) -> Void)
    -> ListenerRegistration
  {

    return tweetCollection.whereField("ownerId", isEqualTo: uid)
      .addSnapshotListener({ snapshot, error in
        print("TWEETSERVICE: User tweets snapshot listener")
        guard let documents = snapshot?.documents else { return }
        for document in documents {
          guard
            let data = try? Firestore.Decoder()
              .decode(FirebaseTweetModel.self, from: document.data())
          else {
            print("TWEETSERVICE: Error decoding document")
            return
          }
          Task {
            guard
              let user = await self.userService.fetchUser(userId: data.ownerId ?? "")
            else {
              print("TWEETSERVICE: User not found")
              return
            }
            let tweet = TweetModel(
              id: data.id,
              content: data.content,
              ownerId: data.ownerId,
              owner: user,
              createdAt: data.createdAt,
              likedUserIds: data.likedUserIds
            )
            self.fetchedUserTweets.append(tweet)
          }
        }
        updateState(self.fetchedUserTweets)

      })
  }

  func fetchUserTweets(user: UserModel) async -> [TweetModel]? {
    guard let uid = user.id else { return nil }
    guard
      let documents =
        try? await tweetCollection
        .whereField("ownerId", isEqualTo: uid)
        .getDocuments()
        .documents
    else {
      print("TWEETSERVICE: Documents not found")
      return nil
    }
    var fetchedTweets: [TweetModel] = []
    for document in documents {
      guard
        let data = try? Firestore.Decoder()
          .decode(FirebaseTweetModel.self, from: document.data())
      else {
        print("TWEETSERVICE: Error decoding document")
        return nil
      }
      let replies = await replyService.fetchTweetReplies(tweetId: data.id ?? "")
      let tweet = data.toTweetModel(owner: user, replies: replies)
      fetchedTweets.append(tweet)
    }
    return fetchedTweets
  }

  func fetchLikedTweets(uid: String) async -> [TweetModel]? {
    guard
      let documents =
        try? await tweetCollection
        .whereField("likedUserIds", arrayContains: uid)
        .getDocuments()
        .documents
    else {
      print("TWEETSERVICE: Documents not found")
      return nil
    }
    var fetchedTweets: [TweetModel] = []
    for document in documents {
      guard
        let data = try? Firestore.Decoder()
          .decode(FirebaseTweetModel.self, from: document.data())
      else {
        print("TWEETSERVICE: Error decoding document")
        return nil
      }
      guard let user = await userService.fetchUser(userId: data.ownerId ?? "") else {
        print("TWEETSERVICE: User not found")
        return nil
      }
      let replies = await replyService.fetchTweetReplies(tweetId: data.id ?? "")
      let tweet = data.toTweetModel(owner: user, replies: replies)
      fetchedTweets.append(tweet)
    }
    return fetchedTweets
  }

  func fetchTweetById(tweetId: String) async -> TweetModel? {
    do {
      guard
        let responseTweet = try await tweetCollection.document(tweetId).getDocument().data()
      else {
        print("TWEETSERVICE: Document not found")
        return nil
      }
      guard
        let data = try? Firestore.Decoder()
          .decode(FirebaseTweetModel.self, from: responseTweet)
      else {
        print("TWEETSERVICE: Error decoding document")
        return nil
      }
      guard let user = await userService.fetchUser(userId: data.ownerId ?? "") else {
        print("TWEETSERVICE: User not found")
        return nil
      }
      let replies = await replyService.fetchTweetReplies(tweetId: data.id ?? "")
      let tweet = data.toTweetModel(owner: user, replies: replies)
      return tweet
    }

    catch {
      print("TWEETSERVICE: Error fetching tweet by id")
      return nil

    }
  }

  func likeTweet(tweet: TweetModel, uid: String) async -> TweetModel? {
    if let likedUserIds = tweet.likedUserIds {
      var newLikedUserIds = likedUserIds
      newLikedUserIds.append(uid)
      do {
        try await tweetCollection.document(tweet.id ?? "")
          .updateData(["likedUserIds": newLikedUserIds])
        return tweet.copyWith(likedUserIds: newLikedUserIds)
      } catch {
        print("TWEETSERVICE: Error liking tweet")
        return nil
      }
    } else {
      let likedUserIds = [uid]
      do {
        try await tweetCollection.document(tweet.id ?? "")
          .updateData(["likedUserIds": likedUserIds])
        return tweet.copyWith(likedUserIds: likedUserIds)
      } catch {
        print("TWEETSERVICE: Error liking tweet")
        return nil
      }
    }

  }

  func dislikeTweet(tweet: TweetModel, uid: String) async -> TweetModel? {
    guard var likedUserIds = tweet.likedUserIds else {
      print("TWEETSERVICE: Error disliking tweet")
      return nil
    }
    likedUserIds.removeAll { id in
      id == uid
    }
    do {
      try await tweetCollection.document(tweet.id ?? "")
        .updateData(["likedUserIds": likedUserIds])
      return tweet.copyWith(likedUserIds: likedUserIds)
    } catch {
      print("TWEETSERVICE: Error disliking tweet")
      return nil
    }
  }

  func createTweet(tweet: FirebaseTweetModel) async -> Bool {

    do {
      try await tweetCollection.document(tweet.id ?? "")
        .setData(Firestore.Encoder().encode(tweet))
      return true
    } catch {
      print("TWEETSERVICE: Error creating tweet")
      return false
    }

  }

  func fetchTweets() async -> [TweetModel]? {
    guard
      let response = try? await tweetCollection.order(by: "createdAt", descending: false)
        .getDocuments()
    else {
      print("TWEETSERVICE: Documents not found")
      return nil
    }
    let documents = response.documents
    var fetchedTweets: [TweetModel] = []
    for document in documents {
      guard
        let data = try? Firestore.Decoder()
          .decode(FirebaseTweetModel.self, from: document.data())
      else {
        print("TWEETSERVICE: Error decoding document")
        return nil
      }
      guard let user = await userService.fetchUser(userId: data.ownerId ?? "") else {
        print("TWEETSERVICE: User not found")
        return nil
      }
      let replies = await replyService.fetchTweetReplies(tweetId: data.id ?? "")
      let tweet = data.toTweetModel(owner: user, replies: replies)
      fetchedTweets.append(tweet)
    }
    return fetchedTweets
  }

}
