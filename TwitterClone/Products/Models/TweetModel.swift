//
//  TweetModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import FirebaseFirestore

struct TweetModel: Identifiable, Codable, Hashable {

  static func == (lhs: TweetModel, rhs: TweetModel) -> Bool {
    return lhs.id == rhs.id && lhs.content == rhs.content && lhs.ownerId == rhs.ownerId
      && lhs.owner == rhs.owner && lhs.createdAt == rhs.createdAt
      && lhs.likedUserIds == rhs.likedUserIds && lhs.replies == rhs.replies
  }

  let id: String?
  let content: String?
  let ownerId: String?
  let owner: UserModel?
  let createdAt: Date?
  let likedUserIds: [String]?
  let replies: [ReplyModel]?

  init(
    id: String? = nil,
    content: String? = nil,
    ownerId: String? = nil,
    owner: UserModel? = nil,
    createdAt: Date? = nil,
    likedUserIds: [String]? = nil,
    replies: [ReplyModel]? = nil
  ) {
    self.id = id
    self.content = content
    self.ownerId = ownerId
    self.owner = owner
    self.createdAt = createdAt
    self.likedUserIds = likedUserIds
    self.replies = replies

  }

  func copyWith(
    id: String? = nil,
    content: String? = nil,
    ownerId: String? = nil,
    owner: UserModel? = nil,
    createdAt: Date? = nil,
    likedUserIds: [String]? = nil,
    replies: [ReplyModel]? = nil
  ) -> TweetModel {
    return TweetModel(
      id: id ?? self.id,
      content: content ?? self.content,
      ownerId: ownerId ?? self.ownerId,
      owner: owner ?? self.owner,
      createdAt: createdAt ?? self.createdAt,
      likedUserIds: likedUserIds ?? self.likedUserIds,
      replies: replies ?? self.replies
    )
  }

  func loadImage() async -> UIImage? {
    guard let url = URL(string: self.owner?.imageUrl ?? "") else { return nil }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      return UIImage(data: data)
    } catch {
      print("Error loading image: \(error)")
      return nil
    }
  }

}

struct FirebaseTweetModel: Identifiable, Codable {
  let id: String?
  let content: String?
  let ownerId: String?
  let createdAt: Date?
  let likedUserIds: [String]?

  init(
    id: String? = nil,
    content: String? = nil,
    ownerId: String? = nil,
    createdAt: Date? = nil,
    likedUserIds: [String]? = nil
  ) {
    self.id = id
    self.content = content
    self.ownerId = ownerId
    self.createdAt = createdAt
    self.likedUserIds = likedUserIds
  }

  func toTweetModel(owner: UserModel, replies: [ReplyModel]?) -> TweetModel {
    return TweetModel(
      id: self.id,
      content: self.content,
      ownerId: self.ownerId,
      owner: owner,
      createdAt: self.createdAt,
      likedUserIds: self.likedUserIds,
      replies: replies
    )
  }

}

extension TweetModel {
  static let mock = TweetModel(
    id: "Cx1bHwmuI0HTwThUymuv",
    content:
      "Güneşin doğuşunu izlemek, bana her zaman yeni başlangıçların ve sonsuz olasılıkların var olduğunu hatırlatır. Hayat, keşfedilmeyi bekleyen bir macera gibi. Her gün, yeni bir fırsat. Şükretmek ve hayattan zevk almak için sebeplerimizi hatırlayalım.",
    ownerId: UserModel.mock.id,
    owner: UserModel.mock,
    createdAt: Date(),
    likedUserIds: ["1", "2", "3", "4"],
    replies: [ReplyModel.mock, ReplyModel.mock2, ReplyModel.mock3]
  )
}
