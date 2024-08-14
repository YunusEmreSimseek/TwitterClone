//
//  TweetView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 8.08.2024.
//

import SwiftUI

struct TweetView: View {
  let tweet: TweetModel
  let imageSize: CGFloat
  let uid: String?
  let likeTap: () -> Void
  var body: some View {
    VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.0)) {
      HStack(alignment: .top, spacing: .dynamicWidth(width: 0.03)) {
        NetworkUserImage(
          url: URL(string: tweet.owner?.imageUrl ?? "nil")!,
          size: imageSize
        )

        VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.0075)) {
          TweetTitleView(tweet: tweet)

          NormalText(
            tweet.content ?? ""
          )
          HStack { Spacer() }
        }
      }
      TweetButtonsView(uid: uid, tweet: tweet, likeTap: likeTap)

    }
  }

}

private struct TweetTitleView: View {
  let tweet: TweetModel
  var body: some View {
    HStack {
      Text(tweet.owner?.name ?? "")
        .fontWeight(.semibold)
      NormalText(
        "@\(tweet.owner?.tag ?? "")"
      )
      .foregroundStyle(.gray)
      Spacer()
      Text(
        "\(tweet.createdAt?.formatted(date: .numeric, time: .omitted).description ?? "")"
      )
      .font(.caption2)
      .foregroundStyle(.gray)
    }
    .topPadding(.low3)
  }
}

private struct TweetButtonsView: View {
  let uid: String?
  let tweet: TweetModel
  let likeTap: () -> Void
  var body: some View {
    HStack(spacing: .dynamicWidth(width: 0.1)) {
      Spacer()
      Button(
        action: {},
        label: {
          HStack(spacing: .zero) {
            Image(systemName: "message")
              .foregroundStyle(.gray)
              .padding(0)
            Text(tweet.replies?.count.description ?? "0")
              .font(.subheadline)
              .foregroundStyle(.gray)
          }
        }
      )
      Button(
        action: {},
        label: {
          Image(systemName: "arrow.2.squarepath")
            .foregroundStyle(.gray)
        }
      )
      LikeTweetButton(
        uid: uid,
        onTap: likeTap,
        tweet: tweet
      )
      Button(
        action: {},
        label: {
          Image(systemName: "bookmark")
            .foregroundStyle(.gray)
        }
      )
      Spacer()
    }
    .trailingPadding(.low3)
  }
}
