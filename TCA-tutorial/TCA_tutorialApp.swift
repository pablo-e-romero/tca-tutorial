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
        initialState: CounterFeature.State(),
        reducer: { CounterFeature()._printChanges() }
    )

    var body: some Scene {
        WindowGroup {
            CounterView(store: TCA_tutorialApp.store)
        }
    }
}
