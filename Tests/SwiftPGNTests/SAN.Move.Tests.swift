import XCTest
@testable import SwiftPGN

final class SANMoveTests: XCTestCase {
    //
    //    1. e4=Q e5 2. Nf3 Nc6 3. Bb5 a6 {This opening is called the Ruy Lopez.}
    //    4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6 8. c3 O-O-O 9. h3 Nb8  10. d4 Nbd7
    //    11. c4 c6 12. cxb5 axb5 13. Nc3 Bb7 14. Bg5 b4 15. Nb1 h6 16. Bh4 c5 17. dxe5
    //    Nxe4 18. Bxe7 Qxe7 19. exd6 Qf6 20. Nbd2 Nxd6 21. Nc4 Nxc4 22. Bxc4 Nb6
    //    23. Ne5 Rae8 24. Bxf7+=N Rxf7 25. Nxf7 Rxe1+ 26. Qxe1 Kxf7 27. Qe3 Qg5 28. Qxg5
    //    hxg5 29. b3 Ke6 30. a3 Kd6 31. axb4=Q cxb4 32. Ra5 Nd5 33. f3 Bc8 34. Kf2 Bf5
    //    35. Ra7 g6 36. Ra6+ Kc5 37. Ke1 Nf4 38. g3 Nxh3 39. Kd2 Kb5 40. Rd6 Kc5 41. Ra6
    //    Nf2 42. g4 Bd3 43. Qh4xe1 1/2-1/2 44. =
    //
    
    func test_E2_parsedCorrectly() {
        let expected = SAN.Move(
            color: .white,
            piece: .pawn,
            toSquare: SAN.Square("e2"),
            check: false
        )
        let sut = SAN.move(of: "e2", color: .white)
        XCTAssertEqual(sut, expected)
    }
    
    func test_Qh4xe1_parsedCorrectly() {
        let san = "Qh4xe1"
        let expected = SAN.Move(
            color: .white,
            piece: .queen,
            fromFile: SAN.File(4),
            fromRank: SAN.Rank("h"),
            fromSquare: SAN.Square("h4"),
            toSquare: SAN.Square("e1"),
            check: false,
            capture: true
        )
        let sut = SAN.move(of: san, color: .white)
        XCTAssertEqual(sut, expected)
    }

    func test_Bxf7ЗPlusEqualN_parsedCorrectly() {
        let san = "Bxf7+=N"
        let expected = SAN.Move(
            color: .white,
            piece: .bishop,
            toSquare: SAN.Square("f7"),
            check: true,
            capture: true,
            promotionTo: .knignt
        )
        let sut = SAN.move(of: san, color: .white)
        XCTAssertEqual(sut, expected)
    }

    func test_axb4EqualQ_parsedCorrectly() {
        let san = "axb4=Q"
        let expected = SAN.Move(
            color: .black,
            piece: .pawn,
            fromFile: SAN.File("a"),
            toSquare: SAN.Square("b4"),
            capture: true,
            promotionTo: .queen
        )
        let sut = SAN.move(of: san, color: .white)
        XCTAssertEqual(sut, expected)
    }
    
    
}
