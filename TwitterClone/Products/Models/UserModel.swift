//
//  UserModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct UserModel: Identifiable, Codable, Hashable {
  let id: String?
  let name: String?
  let email: String?
  let password: String?
  let imageUrl: String?
  let tag: String?
  let bio: String?
  let followingUsers: [String]?
  let followerUsers: [String]?

  init(
    id: String? = nil,
    name: String? = nil,
    email: String? = nil,
    password: String? = nil,
    imageUrl: String? = nil,
    tag: String? = nil,
    bio: String? = nil,
    followingUsers: [String]? = nil,
    followerUsers: [String]? = nil
  ) {
    self.id = id
    self.name = name
    self.email = email
    self.password = password
    self.imageUrl = imageUrl
    self.tag = tag
    self.bio = bio
    self.followingUsers = followingUsers
    self.followerUsers = followerUsers
  }

  func copyWith(
    id: String? = nil,
    name: String? = nil,
    email: String? = nil,
    password: String? = nil,
    imageUrl: String? = nil,
    tag: String? = nil,
    bio: String? = nil,
    followingUsers: [String]? = nil,
    followerUsers: [String]? = nil
  ) -> UserModel {
    return UserModel(
      id: id ?? self.id,
      name: name ?? self.name,
      email: email ?? self.email,
      password: password ?? self.password,
      imageUrl: imageUrl ?? self.imageUrl,
      tag: tag ?? self.tag,
      bio: bio ?? self.bio,
      followingUsers: followingUsers ?? self.followingUsers,
      followerUsers: followerUsers ?? self.followerUsers

    )
  }
}

extension UserModel {
  static let mock = UserModel(
    id: "hFtRE4PxaLXbwaD1gNY7fvWlYan1",
    name: "Emre Şimşek",
    email: "Emre@test.com",
    password: "123456",
    imageUrl:
      "https://firebasestorage.googleapis.com/v0/b/twitterclone-de759.appspot.com/o/profile_image%2Femre.jpg?alt=media&token=f590f7ae-f311-42a2-91ae-82cec63e5a6e",
    tag: "e.simsek",
    bio: "Ben yunus emre şimşek aslen sivaslıyım sakaryada yaşıyorum.",
    followingUsers: [],
    followerUsers: []
  )
}
