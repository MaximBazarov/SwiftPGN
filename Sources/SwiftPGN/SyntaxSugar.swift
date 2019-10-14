//
//  SyntaxSugar.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 06.10.19.
//

import Foundation


func Turn(_ num: PGN.TurnNumber, _ counterparts: [PGN.Counterpart]) -> PGN.Counterpart {
    return  PGN.Counterpart.turn(num, counterparts)
}

func WhiteMove(_ string: String) -> PGN.Counterpart? {
    guard let san = SAN.Move(string, color: .white) else { return nil }
    return PGN.Counterpart.whiteMove(san)
}

func BlackMove(_ string: String) -> PGN.Counterpart? {
    guard let san = SAN.Move(string, color: .white) else { return nil }
    return PGN.Counterpart.blackMove(san)
}

func Annotation(_ counterparts: [PGN.Counterpart]) -> PGN.Counterpart {
    return PGN.Counterpart.annotation(counterparts)
}

func Text(_ text: String) -> PGN.Counterpart {
    return PGN.Counterpart.text(text)
}

func MoveResult(_ string: String) -> PGN.Counterpart? {
    guard let nag = NAG(rawValue: string) else { return nil }
    return PGN.Counterpart.moveResult(nag)
}

func ArrowHL(_ from: String, _ to: String, _ color: PGN.HighlightColor) -> PGN.Counterpart {
    return PGN.Counterpart.arrow(from: SAN.Square(from)!, to: SAN.Square(to)!, color: color)
}

func SquareHL(_ at: String, _ color: PGN.HighlightColor) -> PGN.Counterpart {
    return PGN.Counterpart.squareHighlight(SAN.Square(at)!, color)
}
