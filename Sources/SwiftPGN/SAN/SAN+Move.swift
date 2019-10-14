//
//  SAN+Move.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 10/13/19.
//

import Foundation

public extension SAN {
    
    enum Castling {
        case long
        case short
    }
    
    /// Move e.g. Nxe4, 0-0-0, 0-0,
    struct Move: Hashable {
        
        let color: Color
        let castling: Castling?
        let piece: PieceKind?
        let fromFile: File?
        let fromRank: Rank?
        let fromSquare: Square?
        let toSquare: Square?
        let check: Bool
        let promotionTo: Piece?
        
        init(color: Color,
             castling: Castling? = nil,
             piece: PieceKind? = nil,
             fromFile: File? = nil,
             fromRank: Rank? = nil,
             fromSquare: Square? = nil,
             toSquare: Square? = nil,
             check: Bool = false,
             promotionTo: Piece? = nil)
        {
            self.color = color
            self.castling = castling
            self.piece = piece
            self.fromFile = fromFile
            self.fromRank = fromRank
            self.fromSquare = fromSquare
            self.toSquare = square
            self.check = check
            self.promotionTo = promotionTo
        }
        
        public static func == (lhs: SAN.Move, rhs: SAN.Move) -> Bool {
            return lhs.color == rhs.color
                && lhs.castling == rhs.castling
                && lhs.piece == rhs.piece
                && lhs.file == rhs.file
                && lhs.rank == rhs.rank
                && lhs.square == rhs.square
                && lhs.check == rhs.check
                && lhs.promotionTo == rhs.promotionTo
        }

    }
    
    /// Move e.g. Nxe4, 0-0-0, 0-0,
    static func move(of str: String, color: Color) -> Move? {
        let pattern = #"(([BNRQKbnrqk])?(([a-h])?([1-8])?)(x)?([a-h][1-8])(\+)?(\=([BNRQKbnrqk]))?)|((O-O|O-O-O)\s)"#
        guard let moveParts = try? str.groups(for: pattern).first else { return nil }
        if moveParts[0].replacingOccurrences(of: " ", with: "") == "O-O" {
            return Move(color: color, castling: .short)
        } else if moveParts[0].replacingOccurrences(of: " ", with: "") == "O-O-O" {
            return Move(color: color, castling: .long)
        } else {
            let piece = Piece(moveParts[2])
            return Move(
                color: piece?.color ?? color,
                piece: piece?.kind ?? .pawn,
                file: SAN.File(Int(moveParts[5]) ?? -1),
                rank: SAN.Rank(moveParts[4]),
                square: SAN.Square(moveParts[7]),
                check: moveParts[8].count > 0,
                promotionTo: SAN.Piece(moveParts[10])
            )
        }
    }
}


