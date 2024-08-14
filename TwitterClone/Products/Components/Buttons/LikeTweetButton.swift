//
//  LikeTweetButton.swift
//  TwitterClone
//
//  Created by Emre Simsek on 7.08.2024.
//

import SwiftUI

struct LikeTweetButton: View {
    let uid: String?
  let onTap: () -> Void
  let tweet: TweetModel
  private func isLiked() -> Bool {
    guard let likedUserIds = tweet.likedUserIds else {
      return false
    }
    let response = likedUserIds.contains(uid ?? "")
    return response
  }
  var body: some View {
    Button(
      action: onTap,
      label: {
        HStack(spacing: 0) {
          if isLiked() {
            Image(systemName: "heart.fill")
              .foregroundStyle(.red)
          } else {
            Image(systemName: "heart")
              .foregroundStyle(.gray)
          }

          Text(tweet.likedUserIds?.count.description ?? "0")
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
      }
    )
  }
}
