//
//  RegisterView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct RegisterView: View {

  @Environment(\.loadingManager) private var loadingManager
  @Environment(\.userManager) private var userManager
  @Environment(\.navManager) private var navManager
  @State private var registerVM = RegisterViewModel(userService: UserService())
  var body: some View {
    ZStack {
      ScrollView {
        VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.07)) {
          HeaderView()

          VStack(spacing: .dynamicHeight(height: 0.025)) {
            BodyView()

            SignUpButtonView()

            Spacer()

            AlreadyHaveAccountView()

            Spacer()
          }
          .hPadding(.medium2)

        }
      }
      .ignoresSafeArea(.container)
      .modifier(LoadingModifier())
      .sheet(
        isPresented: $registerVM.showSheet,
        content: {
          EditProfileView(
            user: registerVM.registerUser,
            showSheet: $registerVM.showSheet
          )
          .onDisappear {
            registerVM.navigateToMainTabView()
          }
        }
      )
      .onAppear {
        registerVM.setManagers(
          loadingManager: loadingManager, userManager: userManager, navManager: navManager)
      }
      .modifier(
        ErrorSheetModifier(
          isPresented: $registerVM.showError, errorMessage: $registerVM.errorMessage))
    }
    .environment(registerVM)
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack { Spacer() }
      PageTitleText("Get started")
      PageTitleText("Create your account")
    }
    .hPadding()
    .frame(height: .dynamicHeight(height: 0.275))
    .foregroundStyle(.cWhite)
    .background(.cBlue)
    .clipShape(RoundedShape(corners: .bottomRight))

  }
}

private struct BodyView: View {
  @Environment(RegisterViewModel.self) private var registerVM
  var body: some View {
    @Bindable var registerVM = registerVM
    VStack {
      UnderlinedImageTextField(
        iconName: "person.fill",
        placeHolder: "Name",
        text: $registerVM.nameValue
      )
      EmailField(text: $registerVM.emailValue)
      PasswordField(text: $registerVM.passwordValue)
    }
  }
}

private struct SignUpButtonView: View {
  @Environment(RegisterViewModel.self) private var registerVM
  var body: some View {
    ElevatedButton(title: "Sign Up") { Task { await registerVM.register() } }
      .hPadding()
  }
}

private struct AlreadyHaveAccountView: View {
  @Environment(RegisterViewModel.self) private var registerVM
  var body: some View {
    HStack {
      Spacer()
      NormalText("Already have an account?")
        .foregroundStyle(.primary)
      Button(action: { registerVM.navigateLogin() }) {
        NormalButtonText("Sign In")
      }
      Spacer()
    }
  }
}

#Preview {
  RegisterView()
}
