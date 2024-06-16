import ComposableArchitecture
@testable import SyncUps
import XCTest

final class SyncUpsListTests: XCTestCase {

    @MainActor
    func testDelete() async {
        let store = TestStore(
            initialState: SyncUpsList.State(
                syncUps: [
                    .init(id: SyncUp.ID(), title: "Daily")
                ]
            ),
            reducer: { SyncUpsList() }
        )

        await store.send(.onDelete([0])) {
            $0.syncUps = []
        }
    }

    @MainActor
    func testAddSyncUp() async {
        let store = TestStore(initialState: SyncUpsList.State()) {
            SyncUpsList()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        store.exhaustivity = .off(showSkippedAssertions: false)

        await store.send(.addSyncUpButtonTapped)

        let editedSyncUp = SyncUp(
            id: SyncUp.ID(),
            attendees: [
                Attendee(id: Attendee.ID(), name: "Blob"),
                Attendee(id: Attendee.ID(), name: "Blob Jr."),
            ],
            title: "Point-Free morning sync"
        )

        await store.send(\.addSyncUp.binding.syncUp, editedSyncUp)

        await store.send(.confirmAddButtonTapped) {
            $0.addSyncUp = nil
            $0.syncUps.append(editedSyncUp)
        }
    }
}
