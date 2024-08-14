//
//  ReplyModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 13.08.2024.
//

import SwiftUI

struct ReplyModel: Identifiable, Codable, Hashable {

  static func == (lhs: ReplyModel, rhs: ReplyModel) -> Bool {
    return lhs.id == rhs.id && lhs.content == rhs.content && lhs.tweetId == rhs.tweetId
      && lhs.ownerId == rhs.ownerId && lhs.owner == rhs.owner && lhs.createdAt == rhs.createdAt
  }

  let id: String?
  let content: String?
  let tweetId: String?
  let ownerId: String?
  let owner: UserModel?
  let createdAt: Date?

  init(
    id: String? = nil,
    content: String? = nil,
    tweetId: String? = nil,
    ownerId: String? = nil,
    owner: UserModel? = nil,
    createdAt: Date? = nil
  ) {
    self.id = id
    self.content = content
    self.tweetId = tweetId
    self.ownerId = ownerId
    self.owner = owner
    self.createdAt = createdAt
  }

  func copyWith(
    id: String? = nil,
    content: String? = nil,
    tweetId: String? = nil,
    ownerId: String? = nil,
    owner: UserModel? = nil,
    createdAt: Date? = nil
  ) -> ReplyModel {
    return ReplyModel(
      id: id ?? self.id,
      content: content ?? self.content,
      tweetId: tweetId ?? self.tweetId,
      ownerId: ownerId ?? self.ownerId,
      owner: owner ?? self.owner,
      createdAt: createdAt ?? self.createdAt
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

struct FirebaseReplyModel: Identifiable, Codable {
  let id: String?
  let content: String?
  let tweetId: String?
  let ownerId: String?
  let createdAt: Date?

  init(
    id: String? = nil,
    content: String? = nil,
    tweetId: String? = nil,
    ownerId: String? = nil,
    createdAt: Date? = nil
  ) {
    self.id = id
    self.content = content
    self.tweetId = tweetId
    self.ownerId = ownerId
    self.createdAt = createdAt
  }

  func toReplyModel(owner: UserModel) -> ReplyModel {
    return ReplyModel(
      id: self.id,
      content: self.content,
      tweetId: self.tweetId,
      ownerId: self.ownerId,
      owner: owner,
      createdAt: self.createdAt
    )
  }

}

extension ReplyModel {
  static let mock = ReplyModel(
    id: "2004BB99-746E-4C4B-A584-BCB8F63CAF8B",
    content: "Selam canimmm",
    tweetId: "Cx1bHwmuI0HTwThUymuv",
    ownerId: "hFtRE4PxaLXbwaD1gNY7fvWlYan1",
    owner: UserModel.mock,
    createdAt: Date()
  )

  static let mock2 = ReplyModel(
    id: "3CD044DB-E5D8-4156-B96D-222CFA0F8672",
    content:
      "Uygulamaların test sürümündeki özellikleri keşfetmesiyle tanınan Jane Munchun Wong, paylaştığı bir tweet ile 280 karakteri aşan Tweetlerin otomatik olarak thread'e dönüştürülmesini sağlayan bir özellik üzerinde çalıştığını açıkladı. ",
    tweetId: "Cx1bHwmuI0HTwThUymuv",
    ownerId: "hFtRE4PxaLXbwaD1gNY7fvWlYan1",
    owner: UserModel.mock,
    createdAt: Date()
  )

  static let mock3 = ReplyModel(
    id: "F9B89E68-4414-4FE5-9D0E-A22A0AFA24E2",
    content:
      "Wong, Twitter'ın tweet yaratım sürecini kolaylaştırmak için bu yeni özellik üzerinde çalıştığını öne sürdü. Elon Musk'ın attığı yeni tweetler ise Jane Munchun Wong'un iddialarını destekledi. ",
    tweetId: "Cx1bHwmuI0HTwThUymuv",
    ownerId: "hFtRE4PxaLXbwaD1gNY7fvWlYan1",
    owner: UserModel.mock,
    createdAt: Date()
  )

}
