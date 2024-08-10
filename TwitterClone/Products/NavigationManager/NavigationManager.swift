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
    static var instance: NavigationManager = NavigationManager()
    private init() {}
    var path: NavigationPath = NavigationPath()

    static func navigate(to_ destination: Destination) {
        instance.path.append(destination)
    }

    static func navigateToBack() {
        instance.path.removeLast()
    }

    static func navigateToRoot() {
        instance.path.removeLast(instance.path.count)
    }

    public enum Destination: Codable, Hashable {
        case login
        case register
        case exploreDetail(user: UserModel)
        case mainTab

    }
}

struct NavigationManagerKey: EnvironmentKey {
    static var defaultValue = NavigationManager.instance
}
