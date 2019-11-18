//
//  SAN.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 06.10.19.
//

import Foundation

/// Portable Game Notation (PGN). 
///
/// [WIKI: Portable Game Notation (PGN)](https://en.wikipedia.org/wiki/Portable_Game_Notation)
///
/// The whole record is a sequence of `PGN.Counterpart`
///
public struct PGN: Hashable {
    public typealias TurnNumber = UInt

    public let counterparts: [Counterpart]

    /// All posible PGN file counterparts
    public enum Counterpart {
        case turn(TurnNumber, [Counterpart])
        case whiteMove(SAN.Move)
        case blackMove(SAN.Move)
        case moveResult(NAG)
        case annotation([Counterpart])
        case text(String)
        case arrow(from:SAN.Square, to: SAN.Square, color: HighlightColor)
        case squareHighlight(SAN.Square, HighlightColor)
        case tagPair(Tag, String)
    }

    /// Tags for tag pairs
    public enum Tag: String {
        case event = "Event"
        case site = "Site"
        case date = "Date"
        case round = "Round"
        case white = "White"
        case black = "Black"
        case result = "Result"
    }

    /// Highlight color
    public enum HighlightColor: String {
        case red = "R"
        case green = "G"
        case blue = "B"
        case yellow = "Y" // R + G
        case magenta = "M" // R + B
        case cyan = "C" // G + B
    }
}

public extension PGN {
    init?(_ string: String) {
        self.counterparts = []
        //return nil
        //guard let parts = parse(pgn: string) else { return nil }
        //self.counterparts = parts
    }

}

extension PGN.Counterpart: Hashable {
    
    public static func == (lhs: PGN.Counterpart, rhs: PGN.Counterpart) -> Bool {
        switch (lhs,rhs) {
        case let(.turn(lNum, lParts), .turn(rNum, rParts)):
            return (lNum == rNum) && (lParts == rParts)

        case let(.whiteMove(lSAN), .whiteMove(rSAN)):
            return lSAN == rSAN

        case let(.blackMove(lSAN), .blackMove(rSAN)):
            return lSAN == rSAN
            
        case let(.tagPair(lTag, lText), .tagPair(rTag, rText)):
            return (lTag == rTag) && (lText == rText)
            
        case let(.squareHighlight(lSquare, lColor), .squareHighlight(rSquare, rColor)):
            return (lSquare == rSquare) && (lColor == rColor)
            
        case let(.arrow(lFrom, lTo, lColor), .arrow(rFrom, rTo, rColor)):
            return (lFrom == rFrom) && (lTo == rTo) && (lColor == rColor)
            
        case let(.text(lText), .text(rText)):
            return lText == rText
            
        case let(.annotation(lAnnotations), .annotation(rAnnotations)):
            if lAnnotations.count == rAnnotations.count {
                for (index, lAnnotation) in lAnnotations.enumerated() {
                    let rAnnotation = rAnnotations[index]
                    if lAnnotation != rAnnotation {
                        return false
                    }
                }
            } else {
                return false
            }
            return true
            
        case let(.moveResult(lResult), .moveResult(rResult)):
            return lResult == rResult
            
        default:
            return false
        }
    }


}
