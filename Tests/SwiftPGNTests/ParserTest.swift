//
//  ParserTest.swift
//  SwiftPGN

import XCTest
@testable import SwiftPGN

class ParserTest: XCTestCase {
    let pgnTags = """
    [Event "F/S Return Match"]
    [Site "Belgrade, Serbia JUG"]
    [Date "1992.11.04"]
    [Round "29"]
    [White "Fischer, Robert J."]
    [Black "Spassky, Boris V."]
    [Result "1/2-1/2"]
    """
    let pgnMoves = """
    1.e4 e5 2.Nf3 Nc6 3.Nc3 Nf6 4.Bb5 Bc5 5.Nxe5 Re8 6.Nxe5 Re8 7.Nxc6 dxc6 8.Bc4 b5
    9.Be2 Nxe4 10.Nxe4 Rxe4 11.Bf3 Re6 12.c3 Qd3 13.b4 Bb6 14.a4 bxa4 15.Qxa4 Bd7
    16.Ra2 Rae8
    17.Qa6
    {[#][%csl Yf3][%cal Rd3f3,Re6g6,Gg6g1] Morphy took twelve minutes
    over his next move, probably to assure himself that the combination was sound
    and that he had a forced win in every variation.}
    17...Qxf3 #
    !! 18.gxf3 Rg6+ 19.Kh1 Bh3 20.Rd1 ({Not} 20.Rg1 Rxg1+ 21.Kxg1 Re1+ -+)
    20...Bg2+ 21.Kg1 Bxf3+ 22.Kf1 Bg2+
    (22...Rg2 ! {would have won more quickly. For instance:} 23.Qd3 Rxf2+
    24.Kg1 Rg2+ 25.Kh1 Rg1#)
    23.Kg1 Bh3+ 24.Kh1 Bxf2 25.Qf1 {Absolutely forced.} 25...Bxf1 26.Rxf1 Re2
    27.Ra1 Rh6 28.d4 Be3 1/2-1/2
    """
    
    func test_ThatParserCorrectlyParseTags() {
        let counterparts = PGN.initByParse(pgn: pgnTags + pgnMoves)!.counterparts
        
        let tags = ["Event", "Site", "Date", "Round", "White", "Black", "Result"]
        let texts = ["F/S Return Match", "Belgrade, Serbia JUG", "1992.11.04", "29", "Fischer, Robert J.", "Spassky, Boris V.", "1/2-1/2"]
        
        for (index, part) in counterparts.enumerated() {
            if index == tags.count {
                return
            }
            switch part {
            case .tagPair(let tag, let text):
                XCTAssert(text == texts[index])
                XCTAssert(tag == PGN.Tag(rawValue: tags[index]))

            default:
                XCTFail()
            }
        }
    }
    
    func test_ThatParserCorrectlyParseMovesPartOfPgn() {
        let counterparts = PGN.initByParse(pgn: pgnTags + pgnMoves)!.counterparts
        
        let result: [PGN.Counterpart] = [
            //tags
            .tagPair(PGN.Tag(rawValue: "Event")!, "F/S Return Match"),
            .tagPair(PGN.Tag(rawValue: "Site")!, "Belgrade, Serbia JUG"),
            .tagPair(PGN.Tag(rawValue: "Date")!, "1992.11.04"),
            .tagPair(PGN.Tag(rawValue: "Round")!, "29"),
            .tagPair(PGN.Tag(rawValue: "White")!, "Fischer, Robert J."),
            .tagPair(PGN.Tag(rawValue: "Black")!, "Spassky, Boris V."),
            .tagPair(PGN.Tag(rawValue: "Result")!, "1/2-1/2"),
            //moves
            .turn(PGN.TurnNumber(1), []),
            .whiteMove(SAN.move(of: "e4", color: .white)!),
            .blackMove(SAN.move(of: "e5", color: .black)!),
            
            .turn(PGN.TurnNumber(2), []),
            .whiteMove(SAN.move(of: "Nf3", color: .white)!),
            .blackMove(SAN.move(of: "Nc6", color: .black)!),
            
            .turn(PGN.TurnNumber(3), []),
            .whiteMove(SAN.move(of: "Nc3", color: .white)!),
            .blackMove(SAN.move(of: "Nf6", color: .black)!),
            
            .turn(PGN.TurnNumber(4), []),
            .whiteMove(SAN.move(of: "Bb5", color: .white)!),
            .blackMove(SAN.move(of: "Bc5", color: .black)!),
            
            .turn(PGN.TurnNumber(5), []),
            .whiteMove(SAN.move(of: "Nxe5", color: .white)!),
            .blackMove(SAN.move(of: "Re8", color: .black)!),
            
            .turn(PGN.TurnNumber(6), []),
            .whiteMove(SAN.move(of: "Nxe5", color: .white)!),
            .blackMove(SAN.move(of: "Re8", color: .black)!),
            
            .turn(PGN.TurnNumber(7), []),
            .whiteMove(SAN.move(of: "Nxc6", color: .white)!),
            .blackMove(SAN.move(of: "dxc6", color: .black)!),
            
            .turn(PGN.TurnNumber(8), []),
            .whiteMove(SAN.move(of: "Bc4", color: .white)!),
            .blackMove(SAN.move(of: "b5", color: .black)!),
            
            .turn(PGN.TurnNumber(9), []),
            .whiteMove(SAN.move(of: "Be2", color: .white)!),
            .blackMove(SAN.move(of: "Nxe4", color: .black)!),
            
            .turn(PGN.TurnNumber(10), []),
            .whiteMove(SAN.move(of: "Nxe4", color: .white)!),
            .blackMove(SAN.move(of: "Rxe4", color: .black)!),
            
            .turn(PGN.TurnNumber(11), []),
            .whiteMove(SAN.move(of: "Bf3", color: .white)!),
            .blackMove(SAN.move(of: "Re6", color: .black)!),
            
            .turn(PGN.TurnNumber(12), []),
            .whiteMove(SAN.move(of: "c3", color: .white)!),
            .blackMove(SAN.move(of: "Qd3", color: .black)!),
            
            .turn(PGN.TurnNumber(13), []),
            .whiteMove(SAN.move(of: "b4", color: .white)!),
            .blackMove(SAN.move(of: "Bb6", color: .black)!),
            
            .turn(PGN.TurnNumber(14), []),
            .whiteMove(SAN.move(of: "a4", color: .white)!),
            .blackMove(SAN.move(of: "bxa4", color: .black)!),
            
            .turn(PGN.TurnNumber(15), []),
            .whiteMove(SAN.move(of: "Qxa4", color: .white)!),
            .blackMove(SAN.move(of: "Bd7", color: .black)!),
            
            .turn(PGN.TurnNumber(16), []),
            .whiteMove(SAN.move(of: "Ra2", color: .white)!),
            .blackMove(SAN.move(of: "Rae8", color: .black)!),
        
            .turn(PGN.TurnNumber(17), []),
            .whiteMove(SAN.move(of: "Qa6", color: .white)!),
            
            .squareHighlight(SAN.Square("f3")!, PGN.HighlightColor(rawValue: "Y")!),
            .arrow(from: SAN.Square("d3")!, to: SAN.Square("f3")!, color: PGN.HighlightColor(rawValue: "R")!),
            .arrow(from: SAN.Square("e6")!, to: SAN.Square("g6")!, color: PGN.HighlightColor(rawValue: "R")!),
            .arrow(from: SAN.Square("g6")!, to: SAN.Square("g1")!, color: PGN.HighlightColor(rawValue: "G")!),
            .text(" Morphy took twelve minutes over his next move, probably to assure himself that the combination was sound and that he had a forced win in every variation."),
            .turn(PGN.TurnNumber(17), []),
            .blackMove(SAN.move(of: "Qxf3", color: .black)!),
            
            .turn(PGN.TurnNumber(18), []),
            .whiteMove(SAN.move(of: "gxf3", color: .white)!),
            .blackMove(SAN.move(of: "Rg6+", color: .black)!),
            
            .turn(PGN.TurnNumber(19), []),
            .whiteMove(SAN.move(of: "Kh1", color: .white)!),
            .blackMove(SAN.move(of: "Bh3", color: .black)!),
            
            .turn(PGN.TurnNumber(20), []),
            .whiteMove(SAN.move(of: "Rd1", color: .white)!),
            .annotation([
                .text("Not"),
                
                .turn(PGN.TurnNumber(20), []),
                .whiteMove(SAN.move(of: "Rg1", color: .white)!),
                .blackMove(SAN.move(of: "Rxg1+", color: .black)!),
                
                .turn(PGN.TurnNumber(21), []),
                .whiteMove(SAN.move(of: "Kxg1", color: .white)!),
                .blackMove(SAN.move(of: "Re1+", color: .black)!),
            ]),
            
            .turn(PGN.TurnNumber(20), []),
            .blackMove(SAN.move(of: "Bg2+", color: .black)!),
            
            .turn(PGN.TurnNumber(21), []),
            .whiteMove(SAN.move(of: "Kg1", color: .white)!),
            .blackMove(SAN.move(of: "Bxf3+", color: .black)!),
            
            .turn(PGN.TurnNumber(22), []),
            .whiteMove(SAN.move(of: "Kf1", color: .white)!),
            .blackMove(SAN.move(of: "Bg2+", color: .black)!),
            .annotation([
                .turn(PGN.TurnNumber(22), []),
                .blackMove(SAN.move(of: "Rg2", color: .black)!),
                .text("would have won more quickly. For instance:"),
                .turn(PGN.TurnNumber(23), []),
                .whiteMove(SAN.move(of: "Qd3", color: .white)!),
                .blackMove(SAN.move(of: "Rxf2+", color: .black)!),
                
                .turn(PGN.TurnNumber(24), []),
                .whiteMove(SAN.move(of: "Kg1", color: .white)!),
                .blackMove(SAN.move(of: "Rg2+", color: .black)!),
                
                .turn(PGN.TurnNumber(25), []),
                .whiteMove(SAN.move(of: "Kh1", color: .white)!),
                .blackMove(SAN.move(of: "Rg1#", color: .black)!),
            ]),

            .turn(PGN.TurnNumber(23), []),
            .whiteMove(SAN.move(of: "Kg1", color: .white)!),
            .blackMove(SAN.move(of: "Bh3+", color: .black)!),
            
            .turn(PGN.TurnNumber(24), []),
            .whiteMove(SAN.move(of: "Kh1", color: .white)!),
            .blackMove(SAN.move(of: "Bxf2", color: .black)!),
            
            .turn(PGN.TurnNumber(25), []),
            .whiteMove(SAN.move(of: "Qf1", color: .white)!),
            .text("Absolutely forced."),
            .turn(PGN.TurnNumber(25), []),
            .blackMove(SAN.move(of: "Bxf1", color: .black)!),
            
            .turn(PGN.TurnNumber(26), []),
            .whiteMove(SAN.move(of: "Rxf1", color: .white)!),
            .blackMove(SAN.move(of: "Re2", color: .black)!),
            
            .turn(PGN.TurnNumber(27), []),
            .whiteMove(SAN.move(of: "Ra1", color: .white)!),
            .blackMove(SAN.move(of: "Rh6", color: .black)!),
            
            .turn(PGN.TurnNumber(28), []),
            .whiteMove(SAN.move(of: "d4", color: .white)!),
            .blackMove(SAN.move(of: "Be3", color: .black)!),
            
            .moveResult(NAG(rawValue: "1/2-1/2")!)
        ]
                
        for (index, part) in counterparts.enumerated() {
            let resultItem = result[index]            
            XCTAssert(part == resultItem)
        }
    }
}
