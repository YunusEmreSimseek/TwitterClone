//
//  UserModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import Foundation

struct UserModel: Identifiable, Codable, Equatable, Hashable {
    let id: String?
    let name: String?
    let email: String?
    let password: String?
    let imageUrl: String?
    let tag: String?
    let about: String?
    let followingUsers: [String]?
    let followerUsers: [String]?

    init(
        id: String? = nil,
        name: String? = nil,
        email: String? = nil,
        password: String? = nil,
        imageUrl: String? = nil,
        tag: String? = nil,
        about: String? = nil,
        followingUsers: [String]? = nil,
        followerUsers: [String]? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.imageUrl = imageUrl
        self.tag = tag
        self.about = about
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
        about: String? = nil,
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
            about: about ?? self.about,
            followingUsers: followingUsers ?? self.followingUsers,
            followerUsers: followerUsers ?? self.followerUsers

        )
    }
}
