//
//  ContentView.swift
//  TCA-tutorial
//
//  Created by Pablo Romero on 24/3/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: StoreOf<CounterFeature>

      var body: some View {
        VStack {
          Text("\(store.count)")
          HStack {
            Button("-") { store.send(.decrementButtonTapped) }
            Button("+") { store.send(.incrementButtonTapped) }
          }
          .font(.largeTitle)
        }
      }
}

#Preview {
    CounterView(
        store: Store(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() }
        )
    )
}
