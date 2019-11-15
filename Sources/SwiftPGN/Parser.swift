//
//  Parser.swift
//  SwiftPGN

import Foundation

extension PGN {
    private enum OperatingMode: String {
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
        
    public func parse(pgn text: String) -> [Counterpart] {
        let text = text.replacingOccurrences(of: "\n", with: " ")
        var counterparts: [Counterpart] = []
        
        var temp: String = ""
        var operatings: [OperatingMode] = [.none]
        
        for symbol in text {
            let symbol = String(symbol)
            print(symbol)
            switch symbol {
            case "[":
                if operatings.last! == .none {
                    operatings.append(.tagPair)
                } else if operatings.last! == .text {
                    operatings.append(.squareHighlight)
                }
            case "]":
                if operatings.last! == .tagPair {
                    operatings.removeLast()
                    counterparts.append(tagPair(from: temp)!)
                    temp = ""
                } else if operatings.last! == .squareHighlight {
                    operatings.removeLast()
                    counterparts.append(.text(temp))
                    temp = ""
                }
            case "{":
                if operatings.last! == .none {
                    operatings.append(.text)
                } else {
                    temp += symbol
                }
            case "}":
                if operatings.last! == .text {
                    operatings.removeLast()
                    counterparts.append(.text(temp))
                    temp = ""
                } else {
                    temp += symbol
                }
            case "(":
                if operatings.last! == .none {
                    operatings.append(.annotation)
                }
            case ")":
                if operatings.last! == .annotation {
                    let result = parse(pgn: temp)
                    operatings.removeLast()
                    temp = ""
                    counterparts.append(.annotation(result))
                }
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if operatings.last! == .none {
                    operatings.append(.turn)
                }
                temp += symbol
            case "a", "b", "c", "d", "e", "f", "g", "h", "K", "Q", "R", "B", "N", "k", "q", "r", "n":
                if operatings.last! == .none {
                    operatings.append(.blackMove)
                }
                temp += symbol
            case ".":
                if operatings.last! == .turn {
                    operatings.removeLast()
                    counterparts.append(.text(temp))
                    temp = ""
                    operatings.append(.whiteMove)
                } else if operatings.last! == .whiteMove {
                    operatings.removeLast()
                    operatings.append(.whiteMove)
                } else if operatings.last! == .blackMove {
                    break
                } else {
                    temp += symbol
                }
            case " ":
                if operatings.last! == .whiteMove {
                    operatings.removeLast()
                    counterparts.append(.whiteMove(SAN.move(of: temp, color: .white)!))
                    temp = ""
                } else if operatings.last! == .blackMove {
                    operatings.removeLast()
                    counterparts.append(.blackMove(SAN.move(of: temp, color: .black)!))
                    temp = ""
                } else {
                   temp += symbol
                }
            default: temp += symbol
            }
        }
        
        if temp.isEmpty == false {
            if operatings.last! != .none {
                if operatings.last! == .whiteMove {
                    operatings.removeLast()
                    counterparts.append(.whiteMove(SAN.move(of: temp, color: .white)!))
                    temp = ""
                } else if operatings.last! == .blackMove {
                    operatings.removeLast()
                    counterparts.append(.blackMove(SAN.move(of: temp, color: .black)!))
                    temp = ""
                }
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
