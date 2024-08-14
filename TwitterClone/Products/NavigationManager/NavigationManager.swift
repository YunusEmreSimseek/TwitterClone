//
//  NavigationManager.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import Foundation
import SwiftUI

@Observable
final class NavigationManager {

  var path: NavigationPath = NavigationPath()

  func navigate(to_ destination: Destination) {
    path.append(destination)
  }

  func navigateToBack() {
    path.removeLast()
  }

  func navigateToRoot() {
    path.removeLast(path.count)
  }

  public enum Destination: Codable, Hashable {
    case login
    case register
    case exploreDetail(user: UserModel, uid: String?)
    case mainTab
    case tweetDetail(tweet: TweetModel)
  }
}

struct NavigationManagerKey: EnvironmentKey {
  static var defaultValue = NavigationManager()
}
