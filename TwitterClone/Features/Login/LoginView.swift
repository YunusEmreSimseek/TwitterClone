//
//  LoginView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct LoginView: View {
  @Environment(\.loadingManager) private var loadingManager
  @Environment(\.userManager) private var userManager
  @Environment(\.navManager) private var navManager
  @State private var loginVM: LoginViewModel = LoginViewModel(userService: UserService())

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.07)) {
        HeaderView()

        VStack(spacing: .dynamicHeight(height: 0.05)) {
          BodyView()
          SignInButton()
          Spacer()
          DontHaveAccountView()
          Spacer()
        }
        .hPadding(.medium2)
      }
    }
    .environment(loginVM)
    .ignoresSafeArea(.container)
    .modifier(
      ErrorSheetModifier(
        isPresented: $loginVM.showErrorSheet, errorMessage: $loginVM.errorSheetMessage)
    )
    .modifier(LoadingModifier())
    .onAppear {
      loginVM.setManagers(
        loadingManager: loadingManager, userManager: userManager, navManager: navManager)
    }
  }
}

private struct HeaderView: View {
  var body: some View {
    VStack(alignment: .leading) {
      HStack { Spacer() }
      PageTitleText("Hello")
      PageTitleText("Welcome Back")
    }
    .hPadding()
    .frame(height: .dynamicHeight(height: 0.275))
    .foregroundStyle(.cWhite)
    .background(.cBlue)
    .clipShape(RoundedShape(corners: .bottomRight))

  }
}

private struct BodyView: View {
  var body: some View {
    VStack(spacing: .dynamicHeight(height: 0.025)) {
      FieldsView()
      ForgotPasswordButton()
    }
  }
}

private struct ForgotPasswordButton: View {
  var body: some View {
    HStack {
      Spacer()
      Button(action: {}) {
        NormalButtonText("Forgot password?")
          .foregroundStyle(.cBlue)
      }
    }
  }
}

private struct SignInButton: View {
  @Environment(LoginViewModel.self) private var loginVM
  var body: some View {
    ElevatedButton(
      title: "Sign In",
      onTap: {
        Task { await loginVM.login() }
      }
    )
    .hPadding()
  }
}

private struct DontHaveAccountView: View {
  @Environment(LoginViewModel.self) private var loginVM
  var body: some View {
    HStack {
      Spacer()
      NormalText("Don't have an account?")
        .foregroundStyle(.primary)
      Button(action: { loginVM.navigateRegister() }) {
        NormalButtonText("Sign Up")
          .foregroundStyle(.cBlue)
      }
      Spacer()
    }
  }
}

private struct FieldsView: View {
  @Environment(LoginViewModel.self) private var loginVM
  var body: some View {
    @Bindable var loginVM = loginVM
    VStack {
      EmailField(text: $loginVM.emailValue)
      PasswordField(text: $loginVM.passwordValue)
    }
  }
}

private struct ErrorMessageView: View {
  @Environment(LoginViewModel.self) private var loginVM
  var body: some View {
    if !loginVM.errorMessage.isEmpty {
      HStack {
        NormalText(loginVM.errorMessage)
          .foregroundStyle(.red)
        Spacer()
      }
    }
  }
}

#Preview {
  LoginView()
}
