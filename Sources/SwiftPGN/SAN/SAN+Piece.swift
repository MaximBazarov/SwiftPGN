//
//  SAN+Piece.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 10/13/19.
//

import Foundation

public extension SAN {
    
    enum PieceKind: Hashable {
        case pawn
        case rook
        case knignt
        case bishop
        case queen
        case king
    }
    
    struct Piece: Hashable {
        
        public let kind: PieceKind
        public let color: Color
        
        public init( _ color: Color, _ kind: PieceKind) {
            self.color = color
            self.kind = kind
        }
        
        public init?(_ string: String) {
            switch string {
            case "p": self.kind = .pawn; self.color = .black
            case "r": self.kind = .rook; self.color = .black
            case "n": self.kind = .knignt; self.color = .black
            case "q": self.kind = .queen; self.color = .black
            case "k": self.kind = .king; self.color = .black
                
            case "P": self.kind = .pawn; self.color = .white
            case "R": self.kind = .rook; self.color = .white
            case "N": self.kind = .knignt; self.color = .white
            case "Q": self.kind = .queen; self.color = .white
            case "K": self.kind = .king; self.color = .white
                
            default: return nil
            }
        }
        
    }
}
