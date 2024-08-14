//
//  LocalUserImage.swift
//  TwitterClone
//
//  Created by Emre Simsek on 10.08.2024.
//

import SwiftUI

struct LocalUserImage: View {
    let image: UIImage
    let size: CGFloat
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: size, height: size)
            .scaledToFit()
            .clipShape(Circle())
    }
}
