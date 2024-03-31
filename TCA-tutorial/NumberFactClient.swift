//
//  NumberFactClient.swift
//  TCA-tutorial
//
//  Created by Pablo Romero on 31/3/24.
//

import ComposableArchitecture
import Foundation

struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fetch: { number in
            try await Task.sleep(for: .seconds(2))
            return "\(number) is awesome!"
        }
    )
}

extension DependencyValues {
    var numberFactClient: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
