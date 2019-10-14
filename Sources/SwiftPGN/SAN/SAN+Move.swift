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
    struct Move {
        let color: Color
        let castling: Castling?
        let piece: Piece?
        let file: File?
        let rank: Rank?
        let square: Square?
        let check: Bool
        let promotionTo: Piece?
        
        init(color: Color,
             castling: Castling? = nil,
             piece: Piece? = nil,
             file: File? = nil,
             rank: Rank? = nil,
             square: Square? = nil,
             check: Bool = nil,
             promotionTo: Piece? = nil)
        {
            self.color = color
            self.castling = castling
            self.piece = piece
            self.file = file
            self.rank = rank
            self.square = square
            self.check = check
            self.promotionTo = promotionTo
        }
    }
    
    /// Move e.g. Nxe4, 0-0-0, 0-0,
    func move(of str: String, color: Color) -> Move? {
        // MARK: - Move
        let pattern = #"(([BNRQKbnrqk])?(([a-h])?([1-8])?)(x)?([a-h][1-8])(\+)?(\=([BNRQKbnrqk]))?)|((O-O|O-O-O)\s)"#
        guard let moveParts = str.groups(for: pattern).first else { return nil }
        if moveParts[0].replacingOccurrences(of: " ", with: "") == "O-O" {
            return Move(color: color, castling: .short)
        } else if moveParts[0].replacingOccurrences(of: " ", with: "") == "O-O-O" {
            return Move(color: color, castling: .long)
        } else {
            return Move(
                color: color,
                piece: SAN.Piece(moveParts[2]),
                file: SAN.File(moveParts[2]), rank: <#T##SAN.Rank?#>, square: <#T##SAN.Square?#>, check: <#T##Bool#>, promotionTo: <#T##SAN.Piece?#>)
        }
        //    } else if group[0] == "O-O-O " {
        //        print("*** CASTLING LONG \n")
        //    } else
    }
        
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

