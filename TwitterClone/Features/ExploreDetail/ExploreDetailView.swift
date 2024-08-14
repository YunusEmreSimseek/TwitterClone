//
//  ExploreDetailView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import SwiftUI

struct ExploreDetailView: View {
  @Environment(\.loadingManager) private var loadingManager
  let user: UserModel
  let uid: String?
  @State private var exploreDetailVM: ExploreDetailViewModel
  init(user: UserModel, uid: String?) {
    self.user = user
    self.uid = uid
    exploreDetailVM = ExploreDetailViewModel(user: user, tweetService: TweetService(), uid: uid)
  }
  var body: some View {
    VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.08)) {
      HeaderView()

      VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.02)) {

        UserDetailsView()
        ProfileTabsView()
        UserTweetsView()
      }
      .padding(.horizontal)
      .padding(.bottom)

    }
    .onAppear {
      exploreDetailVM.setLoadingManager(loadingManager: loadingManager)
    }
    .bottomPadding()
    .ignoresSafeArea(.container, edges: .vertical)
    .modifier(ToolbarBackButtonModifier())
    .environment(exploreDetailVM)

  }
}

private struct HeaderView: View {
  @Environment(ExploreDetailViewModel.self) private var exploreDetailVM
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      Color.cBlue
      let url = URL(string: exploreDetailVM.user.imageUrl ?? "nil")
      NetworkUserImage(url: url!, size: .dynamicHeight(height: 0.13))
        .offset(
          x: .dynamicWidth(width: 0.04),
          y: .dynamicHeight(height: 0.06)
        )
    }
    .frame(height: .dynamicHeight(height: 0.2))
  }
}

private struct UserDetailsView: View {
  @Environment(ExploreDetailViewModel.self) private var exploreDetailVM
  var body: some View {
    let user = exploreDetailVM.user
    VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.015)) {
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          PageTitleText(user.name ?? "user name cant found")
          Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(.cBlue)
        }
        NormalText("@\(user.tag ?? "user tag cant found")")
          .foregroundStyle(.gray)
      }
      NormalText(user.bio ?? "user about cant found")
      HStack {
        NormalText(user.followingUsers?.count.description ?? "0")
        NormalText("Following")
          .foregroundStyle(.gray)
        NormalText(user.followerUsers?.count.description ?? "0")
        NormalText("Followers")
          .foregroundStyle(.gray)
      }

    }
  }
}

private struct ProfileTabsView: View {
  @Environment(ExploreDetailViewModel.self) private var exploreDetailVM
  var body: some View {
    var selectedTab = exploreDetailVM.selectedTab
    HStack {
      ForEach(UserProfileTabs.allCases, id: \.hashValue) { tab in
        VStack {
          Text(tab.title)
            .font(.subheadline)
            .fontWeight(selectedTab == tab ? .semibold : .regular)
            .foregroundStyle(selectedTab == tab ? .primary : .secondary)

          if selectedTab == tab {
            Capsule()
              .foregroundStyle(.cBlue)
              .frame(height: 1.5)
          } else {
            Capsule()
              .foregroundStyle(.cBlue)
              .frame(height: 0)
          }
        }
        .onTapGesture {
          withAnimation(.easeInOut) {
            selectedTab = tab
          }
        }
      }
    }
  }
}

private struct ProfileTweetView: View {
  let tweet: TweetModel
  @Environment(ExploreDetailViewModel.self) private var exploreDetailVM
  var body: some View {
    TweetView(
      tweet: tweet, imageSize: .dynamicHeight(height: 0.07), uid: exploreDetailVM.uid
    ) {
      Task { await exploreDetailVM.likeTweet(tweet: tweet) }
    }
  }
}

private struct UserTweetsView: View {
  @Environment(ExploreDetailViewModel.self) private var exploreDetailVM
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: .normal) {
        ForEach(exploreDetailVM.tweets) { tweet in
          ProfileTweetView(tweet: tweet)
        }
      }
    }
    .bottomPadding()
  }
}

#Preview {
  ExploreDetailView(user: UserModel.mock, uid: UserModel.mock.id)
    .environment(LoadingManager())
}
