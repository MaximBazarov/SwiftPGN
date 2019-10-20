//
//  NAG.swift
//  SwiftPGN
//
//  Created by Maxim Bazarov on 06.10.19.
//

import Foundation

/// Numeric Annotation Glyphs (NAG)
///
/// [WIKI: Numeric Annotation Glyphs](https://en.wikipedia.org/wiki/Numeric_Annotation_Glyphs)
///
public enum NAG: String {
    case veryGoodMove = "!!"
    case goodMove = "!"
    case interestingMove = "!?"
    case questionableMove = "?!"
    case badMove = "?"
    case veryBadMove = "??"
    case whiteDecisiveAdvantage = "+\\-" // looks: +\-
    case whiteModerateAdvantage = "±"
    case whiteSlightAdvantage = "⩲"
    case equalPosition = "="
    case blackSlightAdvantage = "⩱"
    case blackModerateAdvantage = "∓"
    case blackDecisiveAdvantage = "-+"
    case onlyMove = "□"
    case unclearPosition = "∞"
    case zugzwang = "⨀"
    case developmentAdvantage = "⟳"
    case initiative = "↑"
    case attack = "→"
    case counterplay = "⇆"
    case zeitnot = "⊕"
    case withIdea = "∆"
    case betterIs = "⌓"
    case whiteWon = "1-0"
    case blackWon = "0-1"
    case draft = "1/2-1/2"
    case gameOngoing = "*"
}
