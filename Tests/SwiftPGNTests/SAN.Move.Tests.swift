import XCTest
@testable import SwiftPGN

final class SANMoveTests: XCTestCase {


    
    func test_SAN_Move_fromStringE2_parsedCorrectly() {
        let sut = SAN.Move("e2")
        let expected = SAN.Move.pieceToSquare(piece: .whitePawn, square: SAN.Square("e2")!)
        XCTAssertEqual(sut, expected)
    }


    static var allTests = [
        ("test_SAN_Move_fromStringE2E4_parsedCorrectly", test_SAN_Move_fromStringE2_parsedCorrectly),
    ]
}
