//
//  LoadingView.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

struct LoadingView: View {
  @Environment(\.loadingManager) private var loadingManager
  var body: some View {
    ProgressView()
      .scaleEffect(loadingManager.isLoading ? 1.5 : 0)
  }
}
