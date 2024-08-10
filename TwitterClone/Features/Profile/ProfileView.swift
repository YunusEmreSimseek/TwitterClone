//
//  ProfileView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import PhotosUI
import SwiftUI

struct ProfileView: View {
    @State private var profileVM = ProfileViewModel()
    var body: some View {
        VStack(alignment: .leading,spacing: .dynamicHeight(height: 0.02)) {
            HeaderView(profileVM: profileVM)

            VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.02)) {
                VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.01)) {
                    HeaderButtonsView()
                    UserProfileDetails()
                }
                ProfileTabsView(selectedTab: $profileVM.selectedTab)
                if profileVM.selectedTab == .tweets {
                    ProfileTweetsView(profileVM: profileVM)
                }
                else if profileVM.selectedTab == .like {
                    ProfileLikedTweetsView(profileVM: profileVM)
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
            Task {
                await profileVM.getUserTweets()
                await profileVM.getLikedTweets()
            }
        }

    }
}

#Preview {
    ProfileView()

}

private struct HeaderView: View {
    @State var profileVM: ProfileViewModel
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.cBlue
            PhotosPicker(selection: $profileVM.selectedItem) {
                let url = URL(string: GlobalItems.instance.currentUser?.imageUrl ?? "nil")
                NetworkUserImage(url: url!, size: .dynamicHeight(height: 0.13))
                    .offset(
                        x: .dynamicWidth(width: 0.04),
                        y: .dynamicHeight(height: 0.06)
                    )
            }
        }
        .frame(height: .dynamicHeight(height: 0.2))
    }
}

private struct HeaderButtonsView: View {
    var body: some View {
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
                action: {},
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
    @State private var currentUser = GlobalItems.instance.currentUser
    var body: some View {
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
            NormalText(currentUser?.about ?? "user about cant found")
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
    @Binding var selectedTab: UserProfileTabs
    var body: some View {
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
                    }
                    else {
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

private struct SignOutButtonView: View {
    @State var profileVM: ProfileViewModel
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
    @State var profileVM: ProfileViewModel
    let tweet: TweetModel
    var body: some View {
        TweetView(tweet: tweet, imageSize: .dynamicHeight(height: 0.07)) {
            Task { await profileVM.actionTweet(tweet: tweet) }
        }
    }
}

private struct ProfileTweetsView: View {
    @State var profileVM: ProfileViewModel
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .normal) {
                ForEach(profileVM.userTweets) { tweet in
                    ProfileTweetView(profileVM: profileVM, tweet: tweet)
                }
            }
        }
    }
}

private struct ProfileLikedTweetsView: View {
    @State var profileVM: ProfileViewModel
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .normal) {
                ForEach(profileVM.likedTweets) { tweet in
                    ProfileTweetView(profileVM: profileVM, tweet: tweet)
                }
            }
        }
    }
}
