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
            case moveResult
            case annotation
            case text
            case arrow
            case squareHighlight
        }
        let text = text.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "...", with: ".")
        
        var counterparts: [Counterpart] = []
        var currentText: String = ""
        
        var stackOfOperatingMode: [OperatingMode] = [.none]
        var currentOperatingMode: OperatingMode {
            assert(stackOfOperatingMode.count >= 1)
            return stackOfOperatingMode.last ?? .none
        }
                
        var turn: TurnNumber?
        var turnCounterparts: [Counterpart] = []
         
        
        for symbol in text {
            switch String(symbol) {
            //TAG
            case "[":
                if currentOperatingMode == .none {
                    stackOfOperatingMode.append(.tagPair)
                } else if currentOperatingMode == .annotation {
                    stackOfOperatingMode.append(.squareHighlight)
                } else {
                     currentText += String(symbol)
                }
            case "]":
                if currentOperatingMode == .tagPair {
                    guard let tagPair = tagPair(from: currentText) else { return counterparts }
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                    counterparts.append(tagPair)
                } else if currentOperatingMode == .squareHighlight {
                    stackOfOperatingMode.removeLast()
                    currentText = ""
                }
            //Comment
            case "{":
                stackOfOperatingMode.append(.annotation)
            case "}":
                if currentOperatingMode == .annotation {
                    stackOfOperatingMode.removeLast()
                    counterparts.append(.text(currentText))
                    currentText = ""
                }
            case "(":
                stackOfOperatingMode.append(.annotation)
            case ")":
                if currentOperatingMode == .annotation {
                    stackOfOperatingMode.removeLast()
                    counterparts.append(.text(currentText))
                    currentText = ""
                }
            //Move
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if currentOperatingMode == .none || currentOperatingMode == .annotation {
                    currentText = ""
                    stackOfOperatingMode.append(.turn)
                }  
                currentText += String(symbol)
            case ".":
                if currentOperatingMode == .turn {
                    stackOfOperatingMode.removeLast()
                    turn = TurnNumber(currentText)
                    print(currentText)
                    currentText = ""
                    stackOfOperatingMode.append(.whiteMove)
                } else if currentOperatingMode == .blackMove {
                    currentText = ""
                } else {
                    currentText += String(symbol)
                }
            case " ":
                if currentOperatingMode == .whiteMove {
                    guard let move = SAN.move(of: currentText, color: SAN.Color.white) else {
                        return counterparts
                    }
                    turnCounterparts.append(.whiteMove(move))
                    
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                    stackOfOperatingMode.append(.blackMove)
                } else if currentOperatingMode == .blackMove, currentText.isEmpty == false {
                    guard let move = SAN.move(of: currentText, color: SAN.Color.black) else {
                        return counterparts
                    }
                    turnCounterparts.append(.blackMove(move))
                    
                    guard let turn = turn else {
                        return counterparts
                    }
                    counterparts.append(.turn(turn, turnCounterparts))
                    turnCounterparts.removeAll()
                    
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                } else {
                    currentText += String(symbol)
                }
                
            default:
                currentText += String(symbol)
            }
        }
        
        return counterparts
    }
    
    
    public func parse2(pgn text: String) -> [Counterpart] {
        enum OperatingMode {
            case none
            case turn
            case whiteMove
            case blackMove
            case moveResult
            case annotation
            case text
            case arrow
            case squareHighlight
        }
        let text = text.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "...", with: ".")
        
        var counterparts: [Counterpart] = []
        var currentText: String = ""
        
        var stackOfOperatingMode: [OperatingMode] = [.none]
        var currentOperatingMode: OperatingMode {
            assert(stackOfOperatingMode.count >= 1)
            return stackOfOperatingMode.last ?? .none
        }
                
        var turn: TurnNumber?
        var turnCounterparts: [Counterpart] = []
         
        
        for symbol in text {
            switch String(symbol) {
            //TAG
            case "[":
                if currentOperatingMode == .annotation {
                    currentText = ""
                } else {
                    stackOfOperatingMode.append(.squareHighlight)
                }
            case "]":
                if currentOperatingMode == .squareHighlight {
                    print(currentText)
                    currentText = ""
                }
            //Comment
            case "{":
                stackOfOperatingMode.append(.annotation)
            case "}":
                if currentOperatingMode == .annotation {
                    print(parse2(pgn: currentText))
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                }
            case "(":
                stackOfOperatingMode.append(.annotation)
            case ")":
                if currentOperatingMode == .annotation {
                    print(parse2(pgn: currentText))
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                }
            //Move
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if currentOperatingMode == .none  {
                    currentText = ""
                    stackOfOperatingMode.append(.turn)
                }
                currentText += String(symbol)
            case ".":
                if currentOperatingMode == .turn {
                    stackOfOperatingMode.removeLast()
                    turn = TurnNumber(currentText)
                    print(currentText)
                    currentText = ""
                    stackOfOperatingMode.append(.whiteMove)
                } else if currentOperatingMode == .blackMove {
                    currentText = ""
                } else {
                    currentText += String(symbol)
                }
            case " ":
                if currentOperatingMode == .whiteMove {
                    guard let move = SAN.move(of: currentText, color: SAN.Color.white) else {
                        return counterparts
                    }
                    turnCounterparts.append(.whiteMove(move))
                    
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                    stackOfOperatingMode.append(.blackMove)
                } else if currentOperatingMode == .blackMove, currentText.isEmpty == false {
                    guard let move = SAN.move(of: currentText, color: SAN.Color.black) else {
                        return counterparts
                    }
                    turnCounterparts.append(.blackMove(move))
                    
                    guard let turn = turn else {
                        return counterparts
                    }
                    counterparts.append(.turn(turn, turnCounterparts))
                    turnCounterparts.removeAll()
                    
                    currentText = ""
                    stackOfOperatingMode.removeLast()
                } else {
                    currentText += String(symbol)
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
