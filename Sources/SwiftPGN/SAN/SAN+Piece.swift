//
//  SAN+Piece.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 10/13/19.
//

import Foundation

public extension SAN {
    
    /// Full Piece
    struct Piece: Hashable {
        let kind: PieceKind
        let color: Color
        
        
        init( _ color: Color, _ kind: PieceKind) {
            self.color = color
            self.kind = kind
        }
        
        init?(_ string: String) {
            switch string {
            case "p": self.kind = .pawn; self.color = .black
            case "r": self.kind = .rook; self.color = .black
            case "n": self.kind = .knignt; self.color = .black
            case "b": self.kind = .bishop; self.color = .black
            case "q": self.kind = .queen; self.color = .black
            case "k": self.kind = .king; self.color = .black
                
            case "P": self.kind = .pawn; self.color = .white
            case "R": self.kind = .rook; self.color = .white
            case "N": self.kind = .knignt; self.color = .white
            case "B": self.kind = .bishop; self.color = .white
            case "Q": self.kind = .queen; self.color = .white
            case "K": self.kind = .king; self.color = .white
                
            default: return nil
            }
        }
    }
}
