import XCTest
@testable import SwiftPGN

final class SANSquareTests: XCTestCase {
    
    /// Chess board with the moves logic
    ///
    /// **Cell indices**
    ///
    /// ```
    /// | Files
    /// ↓
    ///   + -----------------------
    /// 8 | 56 57 58 59 60 61 62 63
    /// 7 | 48 49 50 51 52 53 54 55
    /// 6 | 40 41 42 43 44 45 46 47
    /// 5 | 32 33 34 35 36 37 38 39
    /// 4 | 24 25 26 27 28 29 30 31
    /// 3 | 16 17 18 19 20 21 22 23
    /// 2 | 8  9  10 11 12 13 14 15
    /// 1 | 0  1  2  3  4  5  6  7
    ///   + -----------------------
    ///     a  b  c  d  e  f  g  h   ⟵ Ranks
    /// ```
    
    
    let indexOfSquareToTest = [
        "a1": 0,
        "a3": 16,
        "d1": 3,
        "d5": 35,
        "h8": 63,
        "h1": 7,
        "h5": 39,
        "h7": 55,
        "f6": 45
    ]
    
    
    func test_SAN_Square_forEachIndexOfSquareToTest_parsedCorrectly() {
        indexOfSquareToTest.forEach{ (str, expectedIndex) in
            let sut = SAN.Square(str)!.index
            XCTAssertEqual(sut, expectedIndex)
        }
    }
    
    let test = """
    1. e4=Q e5 2. Nf3 Nc6 3. Bb5 a6 {This opening is called the Ruy Lopez.}
    4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6 8. c3 O-O-O 9. h3 Nb8  10. d4 Nbd7
    11. c4 c6 12. cxb5 axb5 13. Nc3 Bb7 14. Bg5 b4 15. Nb1 h6 16. Bh4 c5 17. dxe5
    Nxe4 18. Bxe7 Qxe7 19. exd6 Qf6 20. Nbd2 Nxd6 21. Nc4 Nxc4 22. Bxc4 Nb6
    23. Ne5 Rae8 24. Bxf7+=N Rxf7 25. Nxf7 Rxe1+ 26. Qxe1 Kxf7 27. Qe3 Qg5 28. Qxg5
    hxg5 29. b3 Ke6 30. a3 Kd6 31. axb4=Q cxb4 32. Ra5 Nd5 33. f3 Bc8 34. Kf2 Bf5
    35. Ra7 g6 36. Ra6+ Kc5 37. Ke1 Nf4 38. g3 Nxh3 39. Kd2 Kb5 40. Rd6 Kc5 41. Ra6
    Nf2 42. g4 Bd3 43. Qh4xe1 1/2-1/2 44. =
    """
    
    func test_Matches() {
        
        // MARK: - Capture
        //        let Capture = #"(([BNRQK])?([a-h])?([1-8])?)x([a-h][1-8])"#
        //        test.groups(for: Capture).forEach { (group) in
        //            print("""
        //                *** Group: \(group[0])
        //                    - Figure: \(group[2])
        //                    - from rank: \(group[3])
        //                    - from file: \(group[4])
        //                TO:
        //                    - square: \(group[5])
        //
        //                """)
        
        //        let CaptureFromFileAtSquare = #"([1-8])x([a-h][1-8])"#
        //        let JustMove = #"([BNRQK]?[a-h]?)([a-h][1-8])([x+])?([a-h][1-8])?"#
        
        
    }
    

    //str.groups(for: Move).forEach { (group) in
    //    if group[0] == "O-O " {
    //        print("*** CASTLING SHORT \n")
    //    } else if group[0] == "O-O-O " {
    //        print("*** CASTLING LONG \n")
    //    } else {
    //        print("""
    //            *** Group: \(group)
    //            - Figure: \(group[2])
    //            FROM:
    //            - from rank: \(group[4])
    //            - from file: \(group[5])
    //            TO:
    //            - square: \(group[7])
    //            Check: \(group[8])
    //            Promotion: \(group[9])
    //            - figure: \(group[10])
    //
    //            """)
    //    }

    
    static var allTests = [
        (
            "test_SAN_Square_forEachIndexOfSquareToTest_parsedCorrectly",
            test_SAN_Square_forEachIndexOfSquareToTest_parsedCorrectly
        ),
    ]
}
