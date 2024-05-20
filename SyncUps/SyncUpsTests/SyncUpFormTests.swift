import ComposableArchitecture
@testable import SyncUps
import XCTest

final class SyncUpFormTests: XCTestCase {
    var store: TestStoreOf<SyncUpForm>!

    @MainActor
    func testDeleteAttendee() async {
        let attendee1 = Attendee(id: Attendee.ID())
        let attendee2 = Attendee(id: Attendee.ID())
        let store = TestStore(
            initialState: SyncUpForm.State(
                focus: .attendee(attendee1.id),
                syncUp: SyncUp(
                    id: SyncUp.ID(),
                    attendees: [attendee1, attendee2]
                )
            )
        ) {
            SyncUpForm()
        }

        await store.send(.onDeleteAttendees([0])) {
            $0.focus = .attendee(attendee2.id)
            $0.syncUp.attendees = [attendee2]
        }
    }

    @MainActor
    func testAddAttendee() async {
        let store = TestStore(
            initialState: SyncUpForm.State(
                syncUp: SyncUp(id: SyncUp.ID())
            )
        ) {
            SyncUpForm()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addAttendeeButtonTapped) {
            let attendee = Attendee(id: Attendee.ID(UUID(0)))
            $0.focus = .attendee(attendee.id)
            $0.syncUp.attendees = [attendee]
        }
    }
}
