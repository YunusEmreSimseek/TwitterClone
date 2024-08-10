//
//  TweetModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import FirebaseFirestore

struct TweetModel: Identifiable {
    let id: String?
    let content: String?
    let ownerId: String?
    let owner: UserModel?
    let createdAt: Date?
    let likedUserIds: [String]?

    init(
        id: String? = nil,
        content: String? = nil,
        ownerId: String? = nil,
        owner: UserModel? = nil,
        createdAt: Date? = nil,
        likedUserIds: [String]? = nil
    ) {
        self.id = id
        self.content = content
        self.ownerId = ownerId
        self.owner = owner
        self.createdAt = createdAt
        self.likedUserIds = likedUserIds
    }

    func copyWith(
        id: String? = nil,
        content: String? = nil,
        ownerId: String? = nil,
        owner: UserModel? = nil,
        createdAt: Date? = nil,
        likedUserIds: [String]? = nil
    ) -> TweetModel {
        return TweetModel(
            id: id ?? self.id,
            content: content ?? self.content,
            ownerId: ownerId ?? self.ownerId,
            owner: owner ?? self.owner,
            createdAt: createdAt ?? self.createdAt,
            likedUserIds: likedUserIds ?? self.likedUserIds
        )
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

}
