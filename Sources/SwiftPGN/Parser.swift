//
//  Parser.swift
//  SwiftPGN

import Foundation

extension PGN {
    public func parse(pgn text: String) -> [Counterpart]? {
        enum OperatingMode {
            case none
            case tagPair
            case turn
            case whiteMove
            case blackMove
            //case moveResult(NAG)
            case annotation
            case annotation2
            //case text(String)
            //case arrow(from:SAN.Square, to: SAN.Square, color: HighlightColor)
            //case squareHighlight(SAN.Square, HighlightColor)
        }
        let text = text.replacingOccurrences(of: "\n", with: " ")
        
        var counterparts: [Counterpart] = []
        
        var currentText: String = ""
        var operatingMode: OperatingMode = .none
        var operatingModeBefore: OperatingMode = .none
        
        var turn: TurnNumber?
        var turnCounterparts: [Counterpart] = []
         
        
        for symbol in text {
            switch String(symbol) {
            //TAG
            case "[":
                if operatingMode == .none {
                    operatingMode = .tagPair
                }
            case "]":
                if operatingMode == .tagPair {
                    guard let tagPair = tagPair(from: currentText) else { return counterparts }
                    currentText = ""
                    operatingMode = .none
                    counterparts.append(tagPair)
                }                
            //Comment
            case "{":
                if operatingMode != .annotation2 {
                    operatingModeBefore = operatingMode
                    operatingMode = .annotation
                } else {
                    currentText += String(symbol)
                }
            case "}":
                if operatingMode == .annotation {
                    operatingMode = operatingModeBefore
                    counterparts.append(.text(currentText))
                    currentText = ""
                } else {
                    currentText += String(symbol)
                }
            case "(":
                operatingModeBefore = operatingMode
                operatingMode = .annotation2
            case ")":
                operatingMode = operatingModeBefore
                counterparts.append(.text(currentText))
                currentText = ""
                
            //Move
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if operatingMode == .none {
                    currentText = ""
                    operatingMode = .turn
                }
                currentText += String(symbol)
            case ".":
                if operatingMode == .turn {
                    turn = TurnNumber(currentText)
                    print(currentText)
                    currentText = ""
                    operatingMode = .whiteMove
                } else {
                    currentText += String(symbol)
                }
            case " ":
                if operatingMode == .whiteMove {
                    guard let move = SAN.move(of: currentText, color: SAN.Color.white) else { return counterparts }
                    turnCounterparts.append(.whiteMove(move))
                    
                    currentText = ""
                    operatingMode = .blackMove
                } else if operatingMode == .blackMove, currentText.isEmpty == false {
                    guard let move = SAN.move(of: currentText, color: SAN.Color.black) else { return counterparts }
                    turnCounterparts.append(.blackMove(move))
                    
                    guard let turn = turn else { return counterparts }
                    counterparts.append(.turn(turn, turnCounterparts))
                    turnCounterparts.removeAll()
                    
                    currentText = ""
                    operatingMode = .none
                }
                
            default:
                currentText += String(symbol)
            }
        }
        
        return counterparts
    }
    
    private func tagPair(from text: String) -> Counterpart? {
        let tagTextPattern = "(\".*\")"
        
        guard let tagTextRegularExpression = try? NSRegularExpression(pattern: tagTextPattern, options: []) else { return nil }
        let str = text as NSString
        let tagTextRange = tagTextRegularExpression.matches(in: text, options: [], range: NSRange(location: 0, length: text.count)).compactMap { $0.range }.first
        
        guard let range = tagTextRange else { return nil }
        var tagText = str.substring(with: range)
        let tagStr = text.replacingOccurrences(of: tagText, with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        tagText = tagText.replacingOccurrences(of: "\"", with: "")
        
        guard let tag = PGN.Tag(rawValue: tagStr) else { return nil }
        
        return .tagPair(tag, tagText)
    }
    
    private func turn(from text: String) -> Counterpart? {
        return .text(text)
    }
}

private extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
