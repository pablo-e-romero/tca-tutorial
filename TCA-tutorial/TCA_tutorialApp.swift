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
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(
                    initialState: CounterFeature.State(),
                    reducer: { CounterFeature() }
                )
            )
        }
    }
}
