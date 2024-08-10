//
//  ExploreDetailView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import SwiftUI

struct ExploreDetailView: View {
    let user: UserModel
    @State var exploreDetailVM: ExploreDetailViewModel
    init(user: UserModel) {
        self.user = user
        exploreDetailVM = ExploreDetailViewModel(userId: user.id ?? "")
    }
    var body: some View {
        VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.08)) {
            HeaderView(user: user)

            VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.02)) {

                UserDetailsView(user: user)
                ProfileTabsView(selectedTab: $exploreDetailVM.selectedTab)
                UserTweetsView(exploreDetailViewModel: exploreDetailVM)
            }
            .padding(.horizontal)
            .padding(.bottom)

        }
        .bottomPadding()
        .ignoresSafeArea(.container, edges: .vertical)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(
                    action: { NavigationManager.navigateToBack() },
                    label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.cBlack)
                    }
                )
            }
        }

    }
}

private struct HeaderView: View {
    let user: UserModel
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.cBlue
            let url = URL(string: user.imageUrl ?? "nil")
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
    let user: UserModel
    var body: some View {
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
            NormalText(user.about ?? "user about cant found")
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

private struct ProfileTweetView: View {
    let tweet: TweetModel
    var body: some View {
        TweetView(tweet: tweet, imageSize: .dynamicHeight(height: 0.07)) {}
    }
}

private struct UserTweetsView: View {
    @State var exploreDetailViewModel: ExploreDetailViewModel
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .normal) {
                ForEach(exploreDetailViewModel.tweets ?? []) { tweet in
                    ProfileTweetView(tweet: tweet)
                }
            }
        }
        .bottomPadding()
    }
}

#Preview {
    NavigationStack {
        ExploreDetailView(user: UserModel())
    }

}
