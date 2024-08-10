//
//  MainNavigationView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 8.08.2024.
//

import SwiftUI

/// MainNavigationView is the main navigation view of the app.
/// It checks the user's login status and navigates to the appropriate view.
struct MainNavigationView: View {
    @State private var mainVM = MainViewModel(userService: UserService())
    @State private var navManager = NavigationManager.instance
    var body: some View {
        NavigationStack(path: $navManager.path) {
            ProgressView()
                .scaleEffect(2)
                .navigationDestination(for: NavigationManager.Destination.self) { destination in
                    switch destination {
                        case .login: LoginView().navigationBarBackButtonHidden()
                        case .register: RegisterView().navigationBarBackButtonHidden()
                        case .exploreDetail(let user):
                            ExploreDetailView(user: user).navigationBarBackButtonHidden()
                        case .mainTab: MainTabView().toolbar(.hidden, for: .navigationBar)
                    }
                }
                .onAppear {
                    Task { await mainVM.checkUser() }
                }
        }

    }
}
#Preview {
    MainNavigationView()
}
