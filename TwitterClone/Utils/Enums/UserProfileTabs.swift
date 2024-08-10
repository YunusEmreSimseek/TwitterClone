//
//  UserProfileTabs.swift
//  TwitterClone
//
//  Created by Emre Simsek on 8.08.2024.
//

import Foundation
 enum UserProfileTabs: Int, CaseIterable {
    case tweets
    case replies
    case like

    var title: String {
        switch self {
            case .tweets:
                return "Tweets"
            case .replies:
                return "Replies"
            case .like:
                return "Likes"
        }
    }

}
