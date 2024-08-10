//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import PhotosUI
import SwiftUI

@Observable
final class ProfileViewModel {

    var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await selectImage()
                await updateUserImage()
            }
        }
    }

    private var userService: IUserService = UserService()
    private var imageService: ImageService = ImageService()
    private var tweetService: ITweetService = TweetService()
    private var globalItems = GlobalItems.instance
    private var navManager = NavigationManager.instance
    var selectedTab: UserProfileTabs = .tweets
    var selectedImage: UIImage?
    var userTweets: [TweetModel] = []
    var likedTweets: [TweetModel] = []

    func actionTweet(tweet: TweetModel) async {
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
            updateUserTweets(tweet: updatedTweet)
            updateLikedTweets(tweet: updatedTweet)
            return
        }
        let isContain = likedUserIds.contains(currentUserId)
        if isContain {
            guard
                let updatedTweet = await tweetService.dislikeTweet(tweet: tweet, uid: currentUserId)
            else {
                return
            }
            updateUserTweets(tweet: updatedTweet)
            updateLikedTweets(tweet: updatedTweet)
            return
        }
        else {
            guard let updatedTweet = await tweetService.likeTweet(tweet: tweet, uid: currentUserId)
            else {
                return
            }
            updateUserTweets(tweet: updatedTweet)
            updateLikedTweets(tweet: updatedTweet)
            return
        }

    }

    private func updateUserTweets(tweet: TweetModel) {
        if let index = userTweets.firstIndex(where: { inTweet in
            inTweet.id == tweet.id
        }) {
            userTweets[index] = tweet
        }
    }

    private func updateLikedTweets(tweet: TweetModel) {
        if let index = likedTweets.firstIndex(where: { inTweet in
            inTweet.id == tweet.id
        }) {
            likedTweets.remove(at: index)
        }
        else {
            likedTweets.append(tweet)
            return
        }
    }

    func getUserTweets() async {
        guard let userId = globalItems.currentUser?.id else {
            return
        }
        guard let response = await tweetService.fetchUserTweets(uid: userId)
        else {
            return
        }
        userTweets = response
    }

    func getLikedTweets() async {
        guard let userId = globalItems.currentUser?.id else {
            return
        }
        guard let response = await tweetService.fetchLikedTweets(uid: userId)
        else {
            return
        }
        likedTweets = response
    }

    func signOut() {
        userService.signOut()
        GlobalItems.deleteCurrentUser()
        navigateToLoginView()
    }

    private func navigateToLoginView() {
        NavigationManager.navigate(to_: .login)
    }

    func selectImage() async throws {
        // check if the selected item is nil
        guard let selectedItem = selectedItem else { return }

        if let data = try await selectedItem.loadTransferable(type: Data.self) {
            if let uiImage = UIImage(data: data) {
                self.selectedImage = uiImage
            }
        }
    }

    func updateUserImage() async {
        guard let userImage = selectedImage else { return }
        guard let imageUrl = await imageService.uploadImageToFirebaseStorage(image: userImage)
        else { return }
        guard let updateUser = globalItems.currentUser?.copyWith(imageUrl: imageUrl)
        else { return }
        let response = await userService.updateUser(user: updateUser)
        guard response else { return }
        if globalItems.currentUser?.imageUrl != nil {
            let result = await imageService.deleteImageFromFirebaseStorage(
                url: globalItems.currentUser!.imageUrl!
            )
            guard result else { return }
            GlobalItems.setCurrentUser(user: updateUser)
            return
        }
        GlobalItems.setCurrentUser(user: updateUser)

    }
}
