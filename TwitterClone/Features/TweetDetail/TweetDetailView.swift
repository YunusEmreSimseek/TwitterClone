//
//  TweetDetailView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 13.08.2024.
//

import SwiftUI

struct TweetDetailView: View {
  @Environment(\.userManager) private var userManager
  @State var image: UIImage?
  let tweet: TweetModel
  let user: UserModel?
  @State private var tweetDetailVM: TweetDetailViewModel

  init(tweet: TweetModel) {
    self.tweet = tweet
    self.user = tweet.owner
    tweetDetailVM = TweetDetailViewModel(
      replyService: ReplyService(userService: UserService()), tweetService: TweetService(),
      userService: UserService(),
      tweet: tweet, user: tweet.owner)
  }

  var body: some View {
    VStack {
      ScrollView {
        VStack(alignment: .leading, spacing: .medium2) {
          HeaderUserView(image: $image, tweetDetailVM: tweetDetailVM, user: user)

          Text(tweet.content ?? "")
            .font(.subheadline)

          TweetStatsView(tweetDetailVM: tweetDetailVM)

          TweetButtonsView(tweetDetailVM: tweetDetailVM, tweet: tweet)

          VStack(alignment: .leading) {
            if tweetDetailVM.showReplies {
              ForEach(tweetDetailVM.replies ?? []) { reply in
                HStack(alignment: .top, spacing: .low) {
                  VStack {
                    NetworkUserImage(
                      url: URL(string: reply.owner?.imageUrl ?? "nil")!,
                      size: .dynamicHeight(height: 0.05))
                    if reply.content?.count ?? 0 > 50 {
                      HStack { Divider().clipShape(.rect(cornerRadius: 15).stroke(lineWidth: 0.5)) }
                    }

                  }
                  VStack(alignment: .leading) {
                    HStack(spacing: .low3) {
                      Text(reply.owner?.name ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                      Image(systemName: "checkmark.seal.fill")
                        .font(.footnote)
                        .foregroundStyle(.cBlue)
                      Text("@\(reply.owner?.tag ?? "")")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    }
                    Text(reply.content ?? "")
                      .font(.footnote)
                  }
                  .vPadding(.low3)
                }
                if reply.content?.count ?? 0 < 50 {
                  Divider()
                    .clipShape(.rect(cornerRadius: 15).stroke(lineWidth: 0.5))
                }
                //                .vPadding(.low3)
                //

              }
            }
          }

          HStack { Spacer() }
          Spacer()
        }
      }
      BottomReplyField(tweetDetailVM: tweetDetailVM)
    }
    .hPadding()
    .topPadding(.dynamicHeight(height: 0.12))
    .modifier(
      ErrorSheetModifier(
        isPresented: $tweetDetailVM.showResponseSheet,
        errorMessage: $tweetDetailVM.responseSheetMessage)
    )
    .modifier(ToolbarBackButtonModifier())
    .modifier(ToolbarTextModifier(title: "Post"))
    .ignoresSafeArea(.container, edges: .top)
    .onAppear {
      tweetDetailVM.setUserManager(userManager: userManager)
      Task {
        image = await tweet.loadImage()
      }
        tweetDetailVM.addTweetListener(tweetId: tweet.id)
    }
  }
}

#Preview {
  NavigationStack {
    TabView {
      TweetDetailView(
        tweet: TweetModel.mock
      )
      .tabItem {
        Label("Tweet", systemImage: "text.bubble")
      }
    }
  }
}

private struct HeaderUserView: View {
  @Binding var image: UIImage?
  @State var tweetDetailVM: TweetDetailViewModel
  let user: UserModel?
  var body: some View {
    HStack(spacing: .low) {
      if image != nil {
        Image(uiImage: image!)
          .resizable()
          .frame(width: .dynamicWidth(width: 0.13), height: .dynamicHeight(height: 0.075))
          .clipShape(.circle)
      }
      VStack(alignment: .leading) {

        HStack(spacing: .low3) {
          Text(user?.name ?? "")
            .font(.subheadline)
            .fontWeight(.semibold)
          Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(.cBlue)
        }
        Text("@\(user?.tag ?? "")")
          .font(.footnote)
          .foregroundStyle(.gray)

      }.bottomPadding(.low3)
      Spacer()

      if !tweetDetailVM.checkFollowing() {
        Button(action: { Task { await tweetDetailVM.follow() } }) {
          Text("Follow")
            .foregroundStyle(.cWhite)
            .font(.footnote)
            .fontWeight(.semibold)
            .hPadding(.low)
            .vPadding(.low3)
            .background(.cBlack)
            .clipShape(.rect(cornerRadius: 15))
        }.bottomPadding(.medium)
      }

    }
  }
}

private struct BottomReplyField: View {
  @State var tweetDetailVM: TweetDetailViewModel
  var body: some View {
    if tweetDetailVM.showReplyField {
      VStack(alignment: .trailing) {
        TextField("Post your reply", text: $tweetDetailVM.text)
          .allPadding(.low)
          .background(.placeholder.opacity(0.5))
          .clipShape(.rect(cornerRadius: 15))
          .bottomPadding(.low3)
        HStack(spacing: .normal) {
          Image(systemName: "photo")
            .foregroundStyle(.cBlue)
            .font(.title3)
          Image(systemName: "list.bullet")
            .foregroundStyle(.cBlue)
            .font(.title3)
          Image(systemName: "location.circle")
            .foregroundStyle(.cBlue)
            .font(.title3)

          Spacer()
          Button(
            action: {
              Task { await tweetDetailVM.submitReply() }
            },
            label: {
              Text("Reply")
                .foregroundStyle(.cBlack)
                .allPadding(.low3)
                .background(.cBlue)
                .clipShape(.rect(cornerRadius: 15))

            })
        }
      }
    } else {
      TextField("Post your reply", text: $tweetDetailVM.text)
        .allPadding(.low)
        .background(.placeholder.opacity(0.5))
        .clipShape(.rect(cornerRadius: 15))
        .bottomPadding(.low3)
        .onTapGesture {
          tweetDetailVM.showReplyField = true
        }
    }
  }
}

private struct TweetStatsView: View {
  @State var tweetDetailVM: TweetDetailViewModel
  var body: some View {
    VStack(alignment: .leading, spacing: .low) {
      Text("Last edited \(tweetDetailVM.tweet.createdAt?.formatted() ?? "")")
        .font(.subheadline)
        .foregroundStyle(.gray)

      Divider()
        .clipShape(.rect(cornerRadius: 15).stroke(lineWidth: 1))

      HStack(spacing: .low3) {
        Text("\(tweetDetailVM.replies?.count ?? 0)")
          .font(.subheadline)
        Text("Replies")
          .font(.subheadline)
          .foregroundStyle(.gray)

        Text("\(tweetDetailVM.tweet.likedUserIds?.count ?? 0)")
          .font(.subheadline)
        Text("Likes")
          .font(.subheadline)
          .foregroundStyle(.gray)
      }
    }
  }
}

private struct TweetButtonsView: View {
  @State var tweetDetailVM: TweetDetailViewModel
  let tweet: TweetModel
  var body: some View {
    HStack {
      Spacer()
      Button(
        action: { tweetDetailVM.showReplies.toggle() },
        label: {
          HStack(spacing: .zero) {
            Image(systemName: "message")
              .foregroundStyle(.gray)
              .padding(0)
            Text(tweetDetailVM.replies?.count.description ?? "0")
              .font(.subheadline)
              .foregroundStyle(.gray)
          }

        }
      )
      Spacer()
      Button(
        action: {},
        label: {
          Image(systemName: "arrow.2.squarepath")
            .foregroundStyle(.gray)
        }
      )
      Spacer()
      LikeTweetButton(
        uid: tweetDetailVM.userManager?.userId,
        onTap: {},
        tweet: tweet
      )
      Spacer()
      Button(
        action: {},
        label: {
          Image(systemName: "bookmark")
            .foregroundStyle(.gray)
        }
      )
      Spacer()
    }
  }
}
