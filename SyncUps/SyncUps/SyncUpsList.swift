import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpsList {
    @ObservableState
    struct State: Equatable {
        @Presents var addSyncUp: SyncUpForm.State?
        @Shared(.syncUps) var syncUps: IdentifiedArrayOf<SyncUp> = []
    }

    enum Action {
        case addSyncUpButtonTapped
        case addSyncUp(PresentationAction<SyncUpForm.Action>)
        case confirmAddButtonTapped
        case discardButtonTapped
        case onDelete(IndexSet)
        case syncUpTapped(SyncUp.ID)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addSyncUpButtonTapped:
                state.addSyncUp = SyncUpForm.State(syncUp: SyncUp(id: SyncUp.ID(uuid())))
                return .none
            case .addSyncUp:
                return .none
            case .confirmAddButtonTapped:
                guard let newSyncUp = state.addSyncUp?.syncUp else { return .none }
                state.syncUps.append(newSyncUp)
                state.addSyncUp = nil
                return .none
            case .discardButtonTapped:
                state.addSyncUp = nil
                return .none
            case let .onDelete(indexSet):
                state.syncUps.remove(atOffsets: indexSet)
                return .none
            case .syncUpTapped:
                return .none
            }
        }
        .ifLet(\.$addSyncUp, action: \.addSyncUp) {
            SyncUpForm()
        }
    }
}

extension PersistenceReaderKey where Self == PersistenceKeyDefault<FileStorageKey<IdentifiedArrayOf<SyncUp>>> {
    static var syncUps: Self {
        PersistenceKeyDefault(
            .fileStorage(.documentsDirectory.appending(component: "sync-ups.json")),
            []
        )
    }
}

struct SyncUpsListView: View {
    @Bindable var store: StoreOf<SyncUpsList>

    var body: some View {
        List {
            ForEach(store.syncUps) { syncUp in
                Button {


                } label: {
                    CardView(syncUp: syncUp)
                }
                .listRowBackground(syncUp.theme.mainColor)
            }
            .onDelete { indexSet in
                store.send(.onDelete(indexSet))
            }
        }
        .sheet(item: $store.scope(state: \.addSyncUp, action: \.addSyncUp)) { addSyncUpStore in
            NavigationStack {
                SyncUpFormView(store: addSyncUpStore)
                    .navigationTitle("New sync-up")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Discard") {
                                store.send(.discardButtonTapped)
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                store.send(.confirmAddButtonTapped)
                            }
                        }
                    }
            }
        }
        .toolbar {
            Button {
                store.send(.addSyncUpButtonTapped)
            } label: {
                Image(systemName: "plus")
            }
        }
        .navigationTitle("Daily Sync-ups")
    }
}

struct CardView: View {
  let syncUp: SyncUp

  var body: some View {
    VStack(alignment: .leading) {
      Text(syncUp.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(syncUp.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(syncUp.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(syncUp.theme.accentColor)
  }
}

#Preview {
    NavigationStack {
        SyncUpsListView(
            store: .init(
                initialState: SyncUpsList.State(syncUps: [
                    .init(
                        id: SyncUp.ID(),
                        attendees: [
                            Attendee(id: Attendee.ID(), name: "Pablo"),
                            Attendee(id: Attendee.ID(), name: "Gaby"),
                            Attendee(id: Attendee.ID(), name: "Luati"),
                        ],
                        title: "Daily")
                ]),
                reducer: { SyncUpsList() }
            )
        )
    }
}
