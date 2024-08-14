//
//  ProfileView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import PhotosUI
import SwiftUI

struct ProfileView: View {
  @Environment(\.loadingManager) private var loadingManager
  @Environment(\.navManager) private var navManager
  @State private var profileVM: ProfileViewModel = ProfileViewModel()
  @Environment(\.userManager) private var userManager
  var body: some View {
    VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.02)) {
      HeaderView()

      VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.02)) {
        VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.01)) {
          HeaderButtonsView()
          UserProfileDetails()
        }
        ProfileTabsView()
        if profileVM.selectedTab == .tweets {
          ProfileTweetsView()
        } else if profileVM.selectedTab == .like {
          ProfileLikedTweetsView()
        }

      }
      .padding(.horizontal)

      Spacer()
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(
          action: { profileVM.signOut() },
          label: {
            HStack {
              Image(systemName: "power.circle.fill")
                .foregroundStyle(.cBlack)
              NormalButtonText("Sign Out")
                .foregroundStyle(.cBlack)
            }
          }
        )
      }
    }
    .ignoresSafeArea(.container, edges: .top)
    .onAppear {
      profileVM.setManagers(
        loadingManager: loadingManager, userManager: userManager, navManager: navManager)
      Task {
        await profileVM.getUserTweets(user: userManager.user)
        await profileVM.getLikedTweets(uid: userManager.userId)
      }
    }
    .sheet(
      isPresented: $profileVM.showSheet,
      onDismiss: {
        Task {
          await profileVM.getUserTweets(user: userManager.user)
          await profileVM.getLikedTweets(uid: userManager.userId)
        }
      },
      content: {
        EditProfileView(
          user: userManager.user ?? UserModel(),
          showSheet: $profileVM.showSheet
        )
      }
    )
    .modifier(LoadingModifier())
    .environment(profileVM)
  }
}

#Preview {
  ProfileView()
    .environment(UserManager(tweetService: TweetService()))

}

private struct HeaderView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    ZStack(alignment: .bottomLeading) {
      Color.cBlue
      let url = URL(string: profileVM.userManager?.userImageUrl ?? "nil")
      NetworkUserImage(url: url!, size: .dynamicHeight(height: 0.13))
        .offset(
          x: .dynamicWidth(width: 0.04),
          y: .dynamicHeight(height: 0.06)
        )
    }
    .frame(height: .dynamicHeight(height: 0.2))
  }
}

private struct HeaderButtonsView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    @Bindable var profileVM = profileVM
    HStack {
      Spacer()
      Button(
        action: {},
        label: {
          Image(systemName: "bell.badge")
            .font(.title3)
            .foregroundStyle(.cBlack)
            .hPadding()
            .vPadding(.low3)
            .overlay {
              Circle().stroke(.gray, lineWidth: 0.75)
            }
        }
      )

      Button(
        action: { profileVM.showSheet = true },
        label: {
          NormalButtonText("Edit Profile")
            .foregroundStyle(.cBlack)
            .vPadding(.low2)
            .hPadding()
            .overlay {
              RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 0.75)
            }
        }
      )

    }
  }
}

private struct UserProfileDetails: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    let currentUser = profileVM.userManager?.user
    VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.015)) {
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          PageTitleText(currentUser?.name ?? "user name cant found")
          Image(systemName: "checkmark.seal.fill")
            .foregroundStyle(.cBlue)
        }
        NormalText("@\(currentUser?.tag ?? "user tag cant found")")
          .foregroundStyle(.gray)
      }
      NormalText(currentUser?.bio ?? "user about cant found")
      HStack {
        NormalText(currentUser?.followingUsers?.count.description ?? "0")
        NormalText("Following")
          .foregroundStyle(.gray)
        NormalText(currentUser?.followerUsers?.count.description ?? "0")
        NormalText("Followers")
          .foregroundStyle(.gray)
      }

    }
  }
}

private struct ProfileTabsView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    HStack {
      ForEach(UserProfileTabs.allCases, id: \.hashValue) { tab in
        VStack {
          Text(tab.title)
            .font(.subheadline)
            .fontWeight(profileVM.selectedTab == tab ? .semibold : .regular)
            .foregroundStyle(profileVM.selectedTab == tab ? .primary : .secondary)

          if profileVM.selectedTab == tab {
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
            profileVM.selectedTab = tab
          }
        }
      }
    }
  }
}

private struct SignOutButtonView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    HStack {
      Spacer()
      Button("Sign Out") {
        profileVM.signOut()
      }
      Spacer()
    }
    .padding(.bottom, .dynamicHeight(height: 0.05))
  }
}

private struct ProfileTweetView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  let tweet: TweetModel
  var body: some View {
    TweetView(
      tweet: tweet, imageSize: .dynamicHeight(height: 0.07), uid: profileVM.userManager?.userId
    ) {
      Task { await profileVM.actionTweet(tweet: tweet) }
    }
  }
}

private struct ProfileTweetsView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: .normal) {
        ForEach(profileVM.userTweets) { tweet in
          ProfileTweetView(tweet: tweet)
        }
      }
    }
  }
}

private struct ProfileLikedTweetsView: View {
  @Environment(ProfileViewModel.self) private var profileVM
  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: .normal) {
        ForEach(profileVM.likedTweets) { tweet in
          ProfileTweetView(tweet: tweet)
        }
      }
    }
  }
}
