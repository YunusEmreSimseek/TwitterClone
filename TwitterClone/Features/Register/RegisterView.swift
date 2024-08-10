//
//  RegisterView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

struct RegisterView: View {
    @State private var registerVM = RegisterViewModel(userService: UserService())
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .dynamicHeight(height: 0.07)) {
                HeaderView()

                VStack(spacing: .dynamicHeight(height: 0.025)) {
                    BodyView(registerVM: registerVM)

                    SignUpButtonView(registerVM: registerVM)

                    Spacer()

                    AlreadyHaveAccountView()

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
    @State var registerVM: RegisterViewModel
    var body: some View {
        VStack {
            UnderlinedImageTextField(
                iconName: .person,
                placeHolder: "Name",
                text: $registerVM.nameValue
            )
            EmailField(text: $registerVM.emailValue)
            PasswordField(text: $registerVM.passwordValue)
        }
    }
}

private struct SignUpButtonView: View {
    @State var registerVM: RegisterViewModel
    var body: some View {
        ElevatedButton(title: "Sign Up") { Task { await registerVM.register() } }
            .hPadding()
    }
}

private struct AlreadyHaveAccountView: View {
    var body: some View {
        HStack {
            Spacer()
            NormalText("Already have an account?")
                .foregroundStyle(.primary)
            Button(action: { NavigationManager.navigateToBack() }) {
                NormalButtonText("Sign In")
            }
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
        .environment(NavigationManager.instance)
}
