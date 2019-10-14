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
    
    /// Square is a structure containing only the `index` property
    /// which is an integer value representing a sqare index on a chess board
    ///
    ///
    /// Values from 0 to 63
    /// ```
    /// | Files
    /// ↓
    ///   + -----------------------
    /// 8 | 56 57 58 59 60 61 62 63 |
    /// 7 | 48 49 50 51 52 53 54 55 |
    /// 6 | 40 41 42 43 44 45 46 47 |
    /// 5 | 32 33 34 35 36 37 38 39 |
    /// 4 | 24 25 26 27 28 29 30 31 |> Squares
    /// 3 | 16 17 18 19 20 21 22 23 |
    /// 2 | 8  9  10 11 12 13 14 15 |
    /// 1 | 0  1  2  3  4  5  6  7  |
    ///   + -----------------------
    ///     a  b  c  d  e  f  g  h   ⟵ Ranks
    /// ```
    public struct Square{
        
        public let index: Int
        
        
        /// Init with integer value representing a square index from 0 to 63
        /// otherwise returns `nil`
        /// - Parameter value: square index
        public init?(_ value: Int) {
            guard (0...63).contains(value) else { return nil }
            index = value
        }
        
        /// Init with a rank and a file
        public init?(rank: Rank, file: File) {
            let squareIndex = ((file.index - 1) * 8) + rank.index
            self.init(squareIndex)
        }
        
        
        /// Init with a string representation e.g "a2"
        public init?(_ string: String) {
            guard string.count == 2,
                let rank = SAN.Rank(string.first!),
                let file = SAN.File(Int(String(string[string.index(string.startIndex, offsetBy: 1)])) ?? -1)
                else { return nil }
            self.init(rank: rank, file: file)
        }
        
    }
    
    
    /// Files from `1` to `8`
    ///
    /// ```
    /// | Files
    /// ↓
    ///
    /// 8
    /// 7
    /// 6
    /// 5
    /// 4
    /// 3
    /// 2
    /// 1
    /// ```
    public struct File {
        let index: Int

        /// Init with an integer value representing a file from 1 to 8
        /// otherwise returns `nil`
        public init?(_ value: Int) {
            guard (1...8).contains(value) else { return nil }
            index = value
        }
        
        /// Init with a `String` value representing a file from 1 to 8
        /// otherwise returns `nil`
        public init?(_ str: String?) {
            guard let value = Int(str ?? "") else { return nil }
            self.init(value)
        }

    }

    /// Ranks from `a` to `h`
    ///
    ///    ```
    ///    a  b  c  d  e  f  g  h   ⟵ Ranks
    ///    ```
    public struct Rank {
        private static let ranksLetters = "abcdefgh"
        
        
        /// Integer index of the rank on the board
        let index: Int
        
        /// Init with a `String` value representing a rank from "a" to "h"
        /// otherwise returns `nil`
        public init?(_ str: String) {
            guard str.count == 1, let char = str.first else { return nil }
            self.init(char)
        }
        
        /// Init with a `Character` value representing a frank from "a" to "h"
        /// otherwise returns `nil`
        public init?(_ char: Character) {
            let ranks = Rank.ranksLetters
            guard let rankIndex = ranks.firstIndex(of: char)?.utf16Offset(in: ranks)
            else { return nil }
            index = rankIndex
        }
    }
    

    
    /// Piece or Player color
    public enum Color {
        case white
        case black
    }

}
