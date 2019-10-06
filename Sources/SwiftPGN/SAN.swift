//
//  SAN.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 06.10.19.
//

import Foundation

/// Standard Algebraic Notation (SAN).
///
/// [WIKI: Standard Algebraic Notation](https://en.wikipedia.org/wiki/Algebraic_notation_(chess))
///
public enum SAN {

    /// Move e.g. Nxe4, 0-0-0, 0-0,
    public enum Move {
        case pieceOnFileToSquare(piece: Piece, file: File, square: Square)
        case pieceToSquare(piece: Piece, square: Square)
        case castlingQueen(Piece.Color)
        case castlingKing(Piece.Color)

        public enum File: String {
            case a = "a"
        }
    }

    /// Shadow type for **Square location**, might be only in range 0...63
    ///
    /// Top left to right is
    ///
    /// ```56 57 58 59 60 61 62 63```
    ///
    /// Bottom left to right is
    ///
    /// ```0 1 2 3 4 5 6 7```
    ///
    public struct SquareLocation {
        public let index: Int

        public init?(_ value: Int) {
            guard (0...63).contains(value) else { return nil }
            index = value
        }

    }

    /// Square in Standard Algebraic Notation (SAN). e.g. e4 or a7
    public struct Square {
        let location: SquareLocation

        public init?(_ location: SquareLocation) {
            self.location = location
        }
    }

    public enum Piece: String {
        case whitePawn = "P"
        case whiteRook = "R"
        case whiteKnignt = "N"
        case whiteBishop = "B"
        case whiteQueen = "Q"
        case whiteKing = "K"
        case blackPawn = "p"
        case blackRook = "r"
        case blackKnignt = "n"
        case blackBishop = "b"
        case blackQueen = "q"
        case blackKing = "k"


        public enum Color {
            case white
            case black
        }

        public init?(_ string: String) {
            self.init(rawValue: string)
        }

    }
}

extension SAN.SquareLocation: Hashable {

}

extension SAN.Square: Hashable {
    public static func == (lhs: SAN.Square, rhs: SAN.Square) -> Bool {
        return lhs.location == rhs.location
    }


}

extension SAN.Move: Hashable {
    public static func == (lhs: SAN.Move, rhs: SAN.Move) -> Bool {
        switch (lhs, rhs) {

        case let (pieceOnFileToSquare(lPiece, lFile, lSquare),
                  pieceOnFileToSquare(rPiece, rFile, rSquare)):
            return lPiece == rPiece && lFile == rFile && lSquare == rSquare

        case let (pieceToSquare(lPiece, lSquare),
                  pieceToSquare(rPiece, rSquare)):
            return lPiece == rPiece && lSquare == rSquare

        case let (castlingQueen(lColor),
                  castlingQueen(rColor)):
            return lColor == rColor

        case let (castlingKing(lColor),
                  castlingKing(rColor)):
            return lColor == rColor

        default:
            return false
        }
    }


}


extension SAN.Move {

    public init?(_ string: String) {
        return nil
    }
}


// MARK: - Square Parsing

extension SAN.Square {

    private static let ranks = "abcdefgh"
    private static func rank(for letter: Character) -> Int? {
        guard let index = ranks.firstIndex(of: letter)?.utf16Offset(in: ranks)
            else { return nil }
        return index
    }

    public init?(_ string: String) {
        guard string.count == 2,
            let rank = SAN.Square.rank(for: string.first!),
            let file = Int(String(string[string.index(string.startIndex, offsetBy: 1)])),
            let location = SAN.SquareLocation( ((file - 1) * 8) + rank)
            else { return nil }
        self.location = location
    }
}
