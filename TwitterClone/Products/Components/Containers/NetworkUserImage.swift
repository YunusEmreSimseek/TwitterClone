//
//  NetworkImage.swift
//  TwitterClone
//
//  Created by Emre Simsek on 6.08.2024.
//

import SwiftUI

struct NetworkUserImage: View {
  let url: URL
  let size: CGFloat
  var body: some View {

    AsyncImage(url: url) { phase in
      switch phase {
      case .empty:

        ProgressView()
          .scaleEffect(2)
          .frame(width: size, height: size)

      case .success(let image):

        image
          .resizable()
          .scaledToFill()
          .frame(width: size, height: size)
          .clipShape(Circle())

      case .failure:
        ZStack {

          Circle()
            .foregroundStyle(.cBlack)
            .frame(width: size, height: size)

          Image(systemName: "person")
            .resizable()
            .foregroundStyle(.cWhite)
            .frame(width: size / 2.5, height: size / 2.5)

        }

      @unknown default:

        Image(systemName: "questionmark")
          .resizable()
          .frame(width: size, height: size)
      }
    }
  }
}
