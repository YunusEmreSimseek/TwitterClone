//
//  EnvironmentExtension.swift
//  TwitterClone
//
//  Created by Emre Simsek on 4.08.2024.
//

import SwiftUI

extension EnvironmentValues {
    var globalItems: GlobalItems {
        get { self[GlobalItemsKey.self] }
        set { self[GlobalItemsKey.self] = newValue }
    }

    var navManager: NavigationManager {
        get { self[NavigationManagerKey.self] }
        set { self[NavigationManagerKey.self] = newValue }
    }
}
