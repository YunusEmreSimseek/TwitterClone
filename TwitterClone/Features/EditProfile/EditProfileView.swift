//
//  EditProfileSheetView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 10.08.2024.
//

import PhotosUI
import SwiftUI

struct EditProfileView: View {
  @Environment(\.loadingManager) private var loadingManager
  let user: UserModel
  @Binding var showSheet: Bool
  @State var editProfileVM: EditProfileViewModel

  init(user: UserModel, showSheet: Binding<Bool>) {
    self.user = user
    _showSheet = showSheet
    editProfileVM = EditProfileViewModel(
      user: user,
      imageService: ImageService(),
      userService: UserService()
    )
  }

  var body: some View {
    VStack(alignment: .leading, spacing: .medium3) {
      HeaderTitleView(editProfileVM: editProfileVM, showSheet: $showSheet)

      HeaderImageView(editProfileVM: editProfileVM)

      Spacer().frame(height: .low)

      UserFieldsView(editProfileVM: editProfileVM)

      Spacer()
    }
    .allPadding()
    .onAppear {
      editProfileVM.setLoadingManager(loadingManager: loadingManager)
    }
  }
}

private struct HeaderTitleView: View {
  @State var editProfileVM: EditProfileViewModel
  @Binding var showSheet: Bool
  var body: some View {
    HStack {
      Button("Cancel", action: { showSheet = false })
        .foregroundStyle(.cBlack)

      Spacer()

      Text("Edit Profile")
        .font(.headline)

      Spacer()

      if editProfileVM.checkValueChanged() {
        Button(
          "Save",
          action: {
            Task { await editProfileVM.saveChanges() }
            showSheet = false
          }
        )
        .foregroundStyle(.cBlack)
      }
    }
  }
}

private struct HeaderImageView: View {
  @State var editProfileVM: EditProfileViewModel
  var body: some View {
    VStack {
      HStack { Spacer() }
      ZStack(alignment: .bottomLeading) {
        ZStack {
          RoundedRectangle(cornerRadius: 15)
            .frame(height: .dynamicHeight(height: 0.15))
            .foregroundStyle(.cBlue)

          Image(systemName: "photo.badge.plus")
            .foregroundStyle(.cWhite)
            .font(.title2)
        }

        PhotosPicker(selection: $editProfileVM.selectedItem) {
          ZStack {
            if editProfileVM.selectedImage != nil {
              LocalUserImage(
                image: editProfileVM.selectedImage!,
                size: .dynamicHeight(height: 0.07)
              )
            } else {
              NetworkUserImage(
                url: URL(string: editProfileVM.userImageUrl)!,
                size: .dynamicHeight(height: 0.07)
              )
              //                if editProfileVM.userImageUrl.isEmpty {
              //                    Image(systemName: "photo.badge.plus")
              //                      .foregroundStyle(.cWhite)
              //                      .font(.title2)
              //                      .scaleEffect(1.1)
              //                }
            }

          }
          //                    if editProfileVM.selectedImage == nil {
          //                        Image(systemName: "photo.badge.plus")
          //                            .foregroundStyle(.cWhite)
          //                            .font(.title2)
          //                            .scaleEffect(1.5)
          //                    }

        }
        .offset(x: .high3, y: .medium2)

      }
      .frame(
        height: .dynamicHeight(height: 0.15)
      )
    }
  }
}

private struct UserFieldsView: View {
  @State var editProfileVM: EditProfileViewModel
  var body: some View {
    VStack(alignment: .leading) {
      Divider()

      VStack {
        HStack(spacing: .medium2) {
          Text("Name")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.cBlack)
            .frame(width: .dynamicWidth(width: 0.15), alignment: .leading)
          TextField("Add a name to your profile", text: $editProfileVM.userName)
            .foregroundStyle(.cBlue)
            .font(.callout)
        }
        .vPadding(.low3)
        Divider()
      }

      VStack {
        HStack(alignment: .top, spacing: .medium2) {
          Text("Bio")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.cBlack)
            .frame(width: .dynamicWidth(width: 0.15), alignment: .leading)

          ZStack(alignment: .topLeading) {

            if editProfileVM.userBio.isEmpty {
              Text("Add a bio to your profile")
                .foregroundStyle(.placeholder)
                .font(.callout)
                .zIndex(1)
            }

            TextEditor(text: $editProfileVM.userBio)
              .font(.callout)
              .background(.clear)
              .foregroundStyle(.cBlue)
              .leadingPadding(-6)
              .topPadding(-8)

          }

        }
        .frame(height: .dynamicHeight(height: 0.1))

      }
      .vPadding(.low3)
      Divider()

      VStack {
        HStack(spacing: .medium2) {
          Text("Tag")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.cBlack)
            .frame(width: .dynamicWidth(width: 0.15), alignment: .leading)
          TextField("Add a tag to your profile", text: $editProfileVM.userTag)
            .foregroundStyle(.cBlue)
            .font(.callout)
        }
        .vPadding(.low3)
        Divider()
      }

    }
  }
}

#Preview {
  EditProfileView(
    user: UserModel.mock.copyWith(imageUrl: "nil", bio: ""),
    showSheet: Binding(projectedValue: .constant(false)))
}
