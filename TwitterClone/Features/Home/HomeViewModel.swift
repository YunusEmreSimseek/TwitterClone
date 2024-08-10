//
//  HomeViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import Foundation

@Observable
final class HomeViewModel {
    private var tweetService: ITweetService
    var tweets: [TweetModel] = []
    
    init(tweetService: ITweetService) {
        self.tweetService = tweetService
    }

    func getTweets() async {
        GlobalItems.startLoading()
        guard let response = await tweetService.fetchTweets()
        else {
            tweets = []
            GlobalItems.endLoading()
            return
        }
        tweets = response
        GlobalItems.endLoading()
        return
    }

    func likeTweet(tweet: TweetModel) async {
        guard let currentUserId = GlobalItems.instance.currentUser?.id
        else {
            return
        }
        guard let likedUserIds = tweet.likedUserIds
        else {
            guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
            else {
                return
            }
            if let index = tweets.firstIndex(where: { inTweet in
                inTweet.id == tweet.id
            }) {
                tweets[index] = updatedTweet
            }
            return
        }
        let isContain = likedUserIds.contains(currentUserId)
        if isContain {
            guard
                let updatedTweet = await tweetService.dislikeTweet(tweet: tweet, uid: currentUserId)
            else {
                return
            }
            if let index = tweets.firstIndex(where: { inTweet in
                inTweet.id == tweet.id
            }) {
                tweets[index] = updatedTweet
            }
            return
        }
        else {
            guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
            else {
                return
            }
            if let index = tweets.firstIndex(where: { inTweet in
                inTweet.id == tweet.id
            }) {
                tweets[index] = updatedTweet
            }
            return
        }

    }

}
