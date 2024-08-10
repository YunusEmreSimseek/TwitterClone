//
//  GlobalItems.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

@Observable
final class GlobalItems {
    @ObservationIgnored static var instance: GlobalItems = GlobalItems()
    private init() {}
    var isLoading: Bool = false
    //    var currentUser: UserModel? = UserModel(id: "hFtRE4PxaLXbwaD1gNY7fvWlYan1")
    var currentUser: UserModel? = nil
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0
    var keyboardWillShowPublisher = NotificationCenter.default.publisher(
        for: UIResponder.keyboardWillShowNotification
    )
    var keyboardWillHidePublisher = NotificationCenter.default.publisher(
        for: UIResponder.keyboardWillHideNotification
    )

    static func startLoading() {
        instance.isLoading = true
    }

    static func endLoading() {
        instance.isLoading = false
    }

    static func setCurrentUser(user: UserModel) {
        instance.currentUser = user
    }

    static func deleteCurrentUser() {
        instance.currentUser = nil
    }
}

struct GlobalItemsKey: EnvironmentKey {
    static var defaultValue = GlobalItems.instance
}
