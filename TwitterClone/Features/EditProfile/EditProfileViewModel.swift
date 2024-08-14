//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Emre Simsek on 10.08.2024.
//

import PhotosUI
import SwiftUI

@Observable
final class EditProfileViewModel {
  let user: UserModel
  var userName: String
  var userBio: String
  var userTag: String
  var userImageUrl: String
  var selectedItem: PhotosPickerItem? {
    didSet {
      Task {
        try await selectImage()
      }
    }
  }
  var selectedImage: UIImage?

  @ObservationIgnored
  private let imageService: IImageService

  @ObservationIgnored
  private let userService: IUserService

  private var loadingManager: LoadingManager = LoadingManager()

 

  func setLoadingManager(loadingManager: LoadingManager) {
    self.loadingManager = loadingManager
  }

  init(user: UserModel, imageService: IImageService, userService: IUserService) {
    self.user = user
    self.userName = user.name ?? ""
    self.userBio = user.bio ?? ""
    self.userTag = user.tag ?? ""
    self.userImageUrl = user.imageUrl ?? "nil"
    self.imageService = imageService
    self.userService = userService
  }

  func saveChanges() async {
    loadingManager.startLoading()
    guard let responseImageUrl = await uploadImage()
    else {
      let newUser = user.copyWith(
        name: userName,
        tag: userTag,
        bio: userBio
      )
      let _ = await userService.updateUser(user: newUser)
      loadingManager.endLoading()
      return
    }
    let newUser = user.copyWith(
      name: userName,
      imageUrl: responseImageUrl,
      tag: userTag,
      bio: userBio
    )
    let responseUser = await userService.updateUser(user: newUser)
    guard responseUser else { return }
    if user.imageUrl != nil {
      let result = await imageService.deleteImageFromFirebaseStorage(
        url: user.imageUrl!
      )
      guard result else { return }
      loadingManager.endLoading()
      return
    }
    loadingManager.endLoading()
  }

  func uploadImage() async -> String? {
    guard let userImage = selectedImage else { return nil }
    guard let imageUrl = await imageService.uploadImageToFirebaseStorage(image: userImage)
    else { return nil }
    return imageUrl

  }

  //  func updateUserImage() async {
  //    guard let userImage = selectedImage else { return }
  //    guard let imageUrl = await imageService.uploadImageToFirebaseStorage(image: userImage)
  //    else { return }
  //    let updateUser = user.copyWith(imageUrl: imageUrl)
  //    let response = await userService.updateUser(user: updateUser)
  //    guard response else { return }
  //    if user.imageUrl != nil {
  //      let result = await imageService.deleteImageFromFirebaseStorage(
  //        url: user.imageUrl!
  //      )
  //      guard result else { return }
  //      return
  //    }
  //
  //  }

  func selectImage() async throws {
    // check if the selected item is nil
    guard let selectedItem = selectedItem else { return }

    if let data = try await selectedItem.loadTransferable(type: Data.self) {
      if let uiImage = UIImage(data: data) {
        self.selectedImage = uiImage
      }
    }
  }

  func checkValueChanged() -> Bool {
    guard
      user.name ?? "" != userName || user.bio ?? "" != userBio
        || user.tag ?? "" != userTag || selectedImage != nil
    else { return false }
    return true
  }
}
