//
//  CounterFeatureTests.swift
//  TCA-tutorialTests
//
//  Created by Pablo Romero on 31/3/24.
//

import ComposableArchitecture
@testable import TCA_tutorial
import XCTest

final class CounterFeatureTests: XCTestCase {
    @MainActor
    func test_incrementDecrementCount() async {
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() }
        )

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 2
        }

        await store.send(.decrementButtonTapped) {
            $0.count = 1
        }
    }

    @MainActor
    func test_timerTick() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() },
            withDependencies: {
                $0.continuousClock = clock
            }
        )

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
            $0.count = 0
        }

        await clock.advance(by: .seconds(1))

        await store.receive(\.timerTick) {
            $0.count = 1
        }

        await clock.advance(by: .seconds(1))

        await store.receive(\.timerTick) {
            $0.count = 2
        }

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }

    @MainActor
    func test_numberFactFetch() async {
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() },
            withDependencies: {
                $0.numberFactClient.fetch = { "\($0)" }
            }
        )

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }

        await store.send(.factButtonTapped) {
            $0.fact = .loading
        }

        await store.receive(\.factResponse) {
            $0.fact = .loaded("1")
        }
    }

}
