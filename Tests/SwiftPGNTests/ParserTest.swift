//
//  ParserTest.swift
//  SwiftPGN

import XCTest
@testable import SwiftPGN

class ParserTest: XCTestCase {
    let pgn = """
    [Event "F/S Return Match"]
    [Site "Belgrade, Serbia JUG"]
    [Date "1992.11.04"]
    [Round "29"]
    [White "Fischer, Robert J."]
    [Black "Spassky, Boris V."]
    [Result "1/2-1/2"]

    1.e4 e5 2.Nf3 Nc6 3.Nc3 Nf6 4.Bb5 Bc5 5.Nxe5 Re8 6.Nxe5 Re8 7.Nxc6 dxc6 8.Bc4 b5
    9.Be2 Nxe4 10.Nxe4 Rxe4 11.Bf3 Re6 12.c3 Qd3 13.b4 Bb6 14.a4 bxa4 15.Qxa4 Bd7
    16.Ra2 Rae8 17.Qa6
    {[#][%csl Yf3][%cal Rd3f3,Re6g6,Gg6g1] Morphy took twelve minutes
    over his next move, probably to assure himself that the combination was sound
    and that he had a forced win in every variation.}
    17...Qxf3 !! 18.gxf3 Rg6+ 19.Kh1 Bh3 20.Rd1 ({Not} 20.Rg1 Rxg1+ 21.Kxg1 Re1+ -+)
    20...Bg2+ 21.Kg1 Bxf3+ 22.Kf1 Bg2+
    (22...Rg2 ! {would have won more quickly. For instance:} 23.Qd3 Rxf2+
    24.Kg1 Rg2+ 25.Kh1 Rg1#)
    23.Kg1 Bh3+ 24.Kh1 Bxf2 25.Qf1 {Absolutely forced.} 25...Bxf1 26.Rxf1 Re2
    27.Ra1 Rh6 28.d4 Be3 0-1
    """
    
    
    func test_ThatParserCorrectlyParseTags() {
        let tagPgn = """
        [Event "F/S Return Match"]
        [Site "Belgrade, Serbia JUG"]
        [Date "1992.11.04"]
        [Round "29"]
        [White "Fischer, Robert J."]
        [Black "Spassky, Boris V."]
        [Result "1/2-1/2"]
        """
        
        let pgn2 = """
        1.e4 e5 2.Nf3 Nc6 3.Nc3 Nf6 4.Bb5 Bc5 5.Nxe5 Re8 6.Nxe5 Re8 7.Nxc6 dxc6 8.Bc4 b5
        9.Be2 Nxe4 10.Nxe4 Rxe4 11.Bf3 Re6 12.c3 Qd3 13.b4 Bb6 14.a4 bxa4 15.Qxa4 Bd7
        16.Ra2 Rae8 17.Qa6
        {[#][%csl Yf3][%cal Rd3f3,Re6g6,Gg6g1] Morphy took twelve minutes
        over his next move, probably to assure himself that the combination was sound
        and that he had a forced win in every variation.}
        17...Qxf3 !! 18.gxf3 Rg6+ 19.Kh1 Bh3 20.Rd1 ({Not} 20.Rg1 Rxg1+ 21.Kxg1 Re1+ -+)
        20...Bg2+ 21.Kg1 Bxf3+ 22.Kf1 Bg2+
        (22...Rg2 ! {would have won more quickly. For instance:} 23.Qd3 Rxf2+
        24.Kg1 Rg2+ 25.Kh1 Rg1#)
        23.Kg1 Bh3+ 24.Kh1 Bxf2 25.Qf1 {Absolutely forced.} 25...Bxf1 26.Rxf1 Re2
        27.Ra1 Rh6 28.d4 Be3 0-1
        """
        
        let counterparts = PGN("")?.parse2(pgn: pgn)
        
        XCTAssertNotNil(counterparts)
        
        //let tags = ["Event", "Site", "Date", "Round", "White", "Black", "Result"]
        //let texts = ["F/S Return Match", "Belgrade, Serbia JUG", "1992.11.04", "29", "Fischer, Robert J.", "Spassky, Boris V.", "1/2-1/2"]
        

//        for (index, part) in counterparts!.enumerated() {
//            switch part {
//            case .tagPair(let tag, let text):
//                print("\(tag.rawValue) -> \(text)")
//                XCTAssert(text == texts[index])
//                XCTAssert(tag == PGN.Tag(rawValue: tags[index]))
//
//            default: break //XCTFail()
//            }
//        }
        
        for part in counterparts! {
            switch part {
            case .turn(let turn, let parts):
                print(turn)
                for item in parts {
                    switch item {
                    case .whiteMove(let move):
                        print(move.hashValue)
                    case .blackMove(let move):
                        print(move.hashValue)
                    default: break
                    }
                }
            default: break
            }
            
            print(part)
        }
    }
}
