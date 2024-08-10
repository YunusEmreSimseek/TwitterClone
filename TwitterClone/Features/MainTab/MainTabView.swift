//
//  MainTabView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct MainTabView: View {
    @State private var mainTabVM = MainViewModel(userService: UserService())
    var body: some View {
        TabView {
            ForEach(TabItems.items) { item in
                NavigationView {
                    item.model.page

                }
                .tabItem {
                    Image(systemName: item.model.iconName)
                    Text(item.model.title)
                }
            }
        }
        .modifier(KeyboardModifier())
    }
}

private enum TabItems: Identifiable {
    case home
    case explore
    case profile

    var id: Int {
        hashValue
    }
    var model: TabItemModel {
        switch self {
            case .home:
                TabItemModel(iconName: "house", title: "Home", page: AnyView(HomeView()))
            case .explore:
                TabItemModel(
                    iconName: "magnifyingglass",
                    title: "Explore",
                    page: AnyView(ExploreView())
                )
            case .profile:
                TabItemModel(iconName: "person", title: "Profile", page: AnyView(ProfileView()))
        }
    }
    static var items: [TabItems] = [.home, .explore, .profile]
}

private struct TabItemModel {
    let iconName: String
    let title: String
    let page: AnyView
}

#Preview {
    MainTabView()
}
