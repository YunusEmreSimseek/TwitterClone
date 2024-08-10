//
//  LoginView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct LoginView: View {
    @State private var loginVM: LoginViewModel = LoginViewModel(userService: UserService())

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.07)) {
                HeaderView()

                VStack(spacing: .dynamicHeight(height: 0.05)) {
                    BodyView(loginVM: loginVM)
                    SignInButton(loginVM: loginVM)
                    Spacer()
                    DontHaveAccountView()
                    Spacer()
                }
                .hPadding(.medium2)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.container)
        .modifier(LoadingModifier())
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
    @State var loginVM: LoginViewModel
    var body: some View {
        VStack(spacing: .dynamicHeight(height: 0.025)) {
            FieldsView(loginVM: loginVM)
            ForgotPasswordButton(loginVM: loginVM)
        }
    }
}

private struct ForgotPasswordButton: View {
    @State var loginVM: LoginViewModel
    var body: some View {
        HStack {
            ErrorMessageView(loginVM: loginVM)
            Spacer()
            Button(action: {}) {
                NormalButtonText("Forgot password?")
                    .foregroundStyle(.cBlue)
            }
        }
    }
}

private struct SignInButton: View {
    @State var loginVM: LoginViewModel
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
    var body: some View {
        HStack {
            Spacer()
            NormalText("Don't have an account?")
                .foregroundStyle(.primary)
            Button(action: { NavigationManager.navigate(to_: .register) }) {
                NormalButtonText("Sign Up")
                    .foregroundStyle(.cBlue)
            }
            Spacer()
        }
    }
}

#Preview {
    LoginView()
        .environment(NavigationManager.instance)
}

private struct FieldsView: View {
    @State var loginVM: LoginViewModel
    var body: some View {
        VStack {
            EmailField(text: $loginVM.emailValue)
            PasswordField(text: $loginVM.passwordValue)
        }
    }
}

private struct ErrorMessageView: View {
    @State var loginVM: LoginViewModel
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
