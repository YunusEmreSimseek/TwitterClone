//
//  ExploreDetailViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import Foundation

@Observable
final class ExploreDetailViewModel {
    let tweetService: ITweetService = TweetService()
    var tweets: [TweetModel]? = []
    var selectedTab: UserProfileTabs = .tweets

    init(userId: String) {
        Task {
            await fetchUserTweets(uid: userId)
        }
    }

    func fetchUserTweets(uid: String) async {
        guard let tweets = await tweetService.fetchUserTweets(uid: uid)
        else {
            return
        }
        self.tweets = tweets
    }

}
