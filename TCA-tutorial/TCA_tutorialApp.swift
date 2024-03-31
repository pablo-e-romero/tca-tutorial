//
//  TCA_tutorialApp.swift
//  TCA-tutorial
//
//  Created by Pablo Romero on 24/3/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCA_tutorialApp: App {
    static let store = Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature()._printChanges() }
    )

    var body: some Scene {
        WindowGroup {
            AppView(store: TCA_tutorialApp.store)
        }
    }
}
