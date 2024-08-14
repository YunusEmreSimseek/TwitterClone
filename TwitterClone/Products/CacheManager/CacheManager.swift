//
//  CacheManager.swift
//  TwitterClone
//
//  Created by Emre Simsek on 12.08.2024.
//

import SwiftUI

final class CacheManager {

  func saveTweets(tweets: [TweetModel]) {
    if let encoded = try? JSONEncoder().encode(tweets) {
      UserDefaults.standard.set(encoded, forKey: CacheItemKeys.tweets.rawValue)
        print("CACHEMANAGER: tweetler kaydedildi")
        return
    }
      print("CACHEMANAGER: tweetler kaydedilemedi")
  }

  func getTweets() -> [TweetModel]? {
    if let tweets = UserDefaults.standard.data(forKey: CacheItemKeys.tweets.rawValue),
      let decodedTweets = try? JSONDecoder().decode([TweetModel].self, from: tweets)
    {
        print("CACHEMANAGER: tweetler yuklendi")
      return decodedTweets
    }
      print("CACHEMANAGER: tweet bulunamadi")
    return nil

  }
}

private enum CacheItemKeys: String {
  case tweets = "tweets"
}
