//
//  HomeView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import FirebaseFirestore
import SwiftUI

struct HomeView: View {
    @State private var homeVM: HomeViewModel = HomeViewModel(tweetService: TweetService())
    @State private var showSheet: Bool = false
    @State private var isFirstAppear: Bool = true
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                PageTitleText("Home View")
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: .normal) {
                        ForEach(homeVM.tweets) { tweet in
                            HomeTweetView(tweet: tweet, homeVM: homeVM)
                        }
                    }
                }
            }
            TweetButton(showSheet: $showSheet)
            VStack {
                LoadingView()
                Spacer()
            }

        }
        .sheet(
            isPresented: $showSheet,
            content: {
                TweetSheetView(
                    showSheet: $showSheet,
                    user: GlobalItems.instance.currentUser ?? UserModel()
                )
            }
        )
        .toolbar(.hidden, for: .navigationBar)
        .hPadding()
        .vPadding(.low2)
        .onAppear {
            if isFirstAppear {
                Task {
                    await homeVM.getTweets()
                }
                isFirstAppear = false
            }
        }
        .refreshable {
            Task {
                await homeVM.getTweets()
            }
        }
    }
}

private struct HomeTweetView: View {
    let tweet: TweetModel
    @State var homeVM: HomeViewModel
    var body: some View {
        TweetView(tweet: tweet, imageSize: .dynamicHeight(height: 0.07)) {
            Task { await homeVM.likeTweet(tweet: tweet) }
        }
    }
}

#Preview {
    HomeView()
}

private struct TweetButton: View {
    @Binding var showSheet: Bool
    var body: some View {
        Button(
            action: {
                showSheet = true
            },
            label: {
                Image(.tweet3)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .scaledToFill()
                    .frame(
                        width: .dynamicWidth(width: 0.06),
                        height: .dynamicHeight(height: 0.03)
                    )
                    .padding()
            }
        )
        .background(.cBlue)
        .foregroundStyle(.cWhite)
        .clipShape(Circle())
        .padding()
        .padding(.bottom)
    }
}

private struct TweetSheetView: View {
    @Binding var showSheet: Bool
    @State var text: String = ""
    var tweetService: ITweetService = TweetService()
    let user: UserModel
    var body: some View {
        VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.05)) {
            HStack {
                Button(
                    action: { showSheet = false },
                    label: {
                        Text("Cancel")
                    }
                )
                Spacer()
                Button(
                    action: {
                        let tweet = FirebaseTweetModel(
                            id: UUID().uuidString,
                            content: text,
                            ownerId: user.id,
                            createdAt: Date()
                        )

                        Task {
                            let _ = await tweetService.createTweet(tweet: tweet)
                            showSheet = false
                        }
                    },
                    label: {
                        Text("Tweet")
                            .foregroundStyle(.cWhite)
                            .hPadding()
                            .vPadding(.low2)
                    }
                )
                .background(.cBlue)
                .clipShape(.rect(cornerRadius: 15))
            }
            HStack(spacing: .dynamicWidth(width: 0.05)) {
                VStack {
                    NetworkUserImage(
                        url: URL(string: user.imageUrl ?? "nil")!,
                        size: .dynamicHeight(height: 0.07)
                    )
                    Spacer()
                }
                VStack {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .padding(.top, .dynamicHeight(height: 0.015))
                        if text.isEmpty {
                            Text("tweetinizi giriniz.")
                                .foregroundStyle(.gray)
                                .padding(.top, .dynamicHeight(height: 0.023))
                                .padding(.leading, .dynamicWidth(width: 0.025))
                        }
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .allPadding()
    }
}
