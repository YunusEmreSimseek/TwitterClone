//
//  StringExtension.swift
//  TwitterClone
//
//  Created by Emre Simsek on 3.08.2024.
//

import Foundation

extension String? {
    func isNullOrEmpty() -> Bool {
        guard self != nil else { return true }
        guard !self!.isEmpty else { return true }
        return false
    }
}
