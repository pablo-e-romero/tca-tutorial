//
//  CounterReducer.swift
//  TCA-tutorial
//
//  Created by Pablo Romero on 24/3/24.
//

import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        enum Fact {
            case none
            case loading
            case loaded(String)
        }

        var count = 0
        var fact: Fact = .none
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementButtonTapped:
                state.count += 1
            case .decrementButtonTapped:
                state.count -= 1
            case .factButtonTapped:
                state.fact = .loading
                return .run { send in
                    // Some network call
                    try await Task.sleep(for: .seconds(3))
                    let result = "Nice"
                    await send(.factResponse(result))
                }
            case let .factResponse(result):
                state.fact = .loaded(result)
            }
            return .none
        }
    }
}
