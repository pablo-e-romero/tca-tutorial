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

}
