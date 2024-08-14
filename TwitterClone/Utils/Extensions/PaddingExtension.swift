//
//  PaddingExtension.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import SwiftUI

extension View {

    func topPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.top, value)
    }

    func bottomPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.bottom, value)
    }

    func leadingPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.leading, value)
    }

    func trailingPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.trailing, value)
    }

    func hPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.horizontal, value)
    }

    func vPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.vertical, value)
    }

    func allPadding(_ value: CGFloat = .normal) -> some View {
        return self.padding(.all, value)
    }

}
