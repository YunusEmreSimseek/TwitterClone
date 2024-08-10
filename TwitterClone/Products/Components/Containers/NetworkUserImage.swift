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
                        .frame(width: size, height: size)
                        .scaledToFit()
                        .clipShape(Circle())

                case .failure:
                    Image(.person2)
                        .resizable()
                        .frame(width: size, height: size)
                        .scaledToFit()
                        .background(.white)
                        .clipShape(Circle())
                @unknown default:
                    Image(systemName: "questionmark")
                        .resizable()
                        .frame(width: size, height: size)
            }
        }
    }
}
