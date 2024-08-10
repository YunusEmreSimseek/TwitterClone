//
//  ExploreView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct ExploreView: View {
    @State var exploreVM = ExploreViewModel()
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                PageTitleText("Explore")
                ScrollView {
                    LazyVStack {
                        ForEach(exploreVM.users) { user in
                            HStack(alignment: .top, spacing: .dynamicWidth(width: 0.05)) {
                                NetworkUserImage(
                                    url: URL(string: user.imageUrl ?? "nil")!,
                                    size: .dynamicHeight(height: 0.08)
                                )
                                VStack(alignment: .leading) {
                                    Text(user.tag ?? "")
                                        .font(.headline)
                                    Text(user.name ?? "")
                                        .foregroundStyle(.gray)
                                }
                                .topPadding(.low3)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                NavigationManager.navigate(to_: .exploreDetail(user: user))
                            }
                        }
                    }
                }
                Spacer()
            }
            LoadingView()
                .padding()

        }
        .hPadding()
        .vPadding(.low2)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            Task {
                await exploreVM.checkFirstAppear()
            }
        }
        .refreshable {
            Task {
                await exploreVM.fetchUsers()
            }
        }

    }
}

#Preview {
    NavigationStack {
        TabView {
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
        }
    }
}
