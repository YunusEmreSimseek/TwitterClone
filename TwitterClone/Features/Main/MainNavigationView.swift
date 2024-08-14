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
  @Environment(\.navManager) private var navManager
  @Environment(\.loadingManager) private var loadingManager
  @Environment(\.userManager) private var userManager

  var body: some View {

    @Bindable var navManager = navManager

    NavigationStack(path: $navManager.path) {

      ProgressView()
        .scaleEffect(2)
        .navigationDestination(for: NavigationManager.Destination.self) { destination in
          switch destination {

            case .login: LoginView().navigationBarBackButtonHidden()
            case .register: RegisterView().navigationBarBackButtonHidden()
            case .exploreDetail(let user, let uid):
              ExploreDetailView(user: user, uid: uid).navigationBarBackButtonHidden()
            case .mainTab:
              MainTabView().toolbar(.hidden, for: .navigationBar)
            case .tweetDetail(let tweet):
              TweetDetailView(tweet: tweet).navigationBarBackButtonHidden()

          }
        }
        .onAppear {
          mainVM.setManagers(userManager: userManager, navManager: navManager)
          Task { await mainVM.checkUser() }
        }
    }

  }
}
#Preview {
  MainNavigationView()
    .environment(LoadingManager())
    .environment(UserManager(tweetService: TweetService()))
    .environment(NavigationManager())
}
