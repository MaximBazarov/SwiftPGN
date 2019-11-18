//
//  Parser.swift
//  SwiftPGN

import Foundation

extension PGN {
    public static func initByParse(pgn text: String) -> PGN? {
        let counterpart = PGN.parse(pgn: text)
        return PGN(counterparts: counterpart)
    }
    
    private static func parse(pgn text: String) -> [Counterpart] {
         enum ParseMode: String {
            case none
            case nag
            case tagPair
            case turn
            case whiteMove
            case blackMove
            case moveResult
            case annotation
            case text
            case highlight
        }
        
        let text = text.replacingOccurrences(of: "\n", with: " ")
        var counterparts: [Counterpart] = []
        
        var temp: String = ""
        var mode: [ParseMode] = [.none]
        
        for symbol in text {
            let symbol = String(symbol)
            switch symbol {
            case "[":
                if mode.last! == .none {
                    mode.append(.tagPair)
                } else if mode.last! == .text {
                    mode.append(.highlight)
                }
            case "]":
                if mode.last! == .tagPair {
                    mode.removeLast()
                    counterparts.append(tagPair(from: temp)!)
                    temp = ""
                } else if mode.last! == .highlight {
                    mode.removeLast()
                    counterparts.append(contentsOf: highlight(from: temp))
                    temp = ""
                }
            case "{":
                if mode.last! == .none {
                    mode.append(.text)
                } else {
                    temp += symbol
                }
            case "}":
                if mode.last! == .text {
                    mode.removeLast()
                    counterparts.append(.text(temp))
                    temp = ""
                } else {
                    temp += symbol
                }
            case "(":
                if mode.last! == .none {
                    mode.append(.annotation)
                }
            case ")":
                if mode.last! == .annotation {
                    let result = parse(pgn: temp)
                    mode.removeLast()
                    temp = ""
                    counterparts.append(.annotation(result))
                }
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if mode.last! == .none {
                    mode.append(.turn)
                }
                temp += symbol
            case "a", "b", "c", "d", "e", "f", "g", "h", "K", "Q", "R", "B", "N", "k", "q", "r", "n", "O":
                if mode.last! == .none {
                    mode.append(.blackMove)
                }
                temp += symbol
            case ".":
                if mode.last! == .turn {
                    mode.removeLast()
                    
                    let number = String(temp.filter { "01234567890".contains($0) })
                                        
                    counterparts.append(.turn(PGN.TurnNumber(number)!, []))
                    temp = ""
                    mode.append(.whiteMove)
                } else if mode.last! == .whiteMove {
                    mode.removeLast()
                    mode.append(.blackMove)
                } else if mode.last! == .blackMove {
                    break
                } else {
                    temp += symbol
                }
            case " ":
                if mode.last! == .whiteMove {
                    mode.removeLast()
                    counterparts.append(.whiteMove(SAN.move(of: temp, color: .white)!))
                    temp = ""
                } else if mode.last! == .blackMove {
                    mode.removeLast()
                    counterparts.append(.blackMove(SAN.move(of: temp, color: .black)!))
                    temp = ""
                } else if mode.last! == .nag {
                    mode.removeLast()
                    temp = ""
                } else {
                   temp += symbol
                }
            case "-":
                if mode.last! == .none || mode.last! == .turn {
                    if mode.last! == .turn {
                        mode.removeLast()
                    }
                    mode.append(.moveResult)
                }
                temp += symbol
            case "!", "?", "+", "⩲", "=", "⩱", "∓", "□", "∞", "⨀", "⟳", "↑", "→", "⇆", "⊕", "∆", "⌓":
                if mode.last! == .none || mode.last! == .moveResult {
                    if mode.last! == .moveResult {
                        mode.removeLast()
                    }
                    mode.append(.nag)
                }
                temp += symbol
            default: temp += symbol
            }
        }
        
        if temp.isEmpty == false {
            if mode.last! != .none {
                if mode.last! == .whiteMove {
                    mode.removeLast()
                    counterparts.append(.whiteMove(SAN.move(of: temp, color: .white)!))
                    temp = ""
                } else if mode.last! == .blackMove {
                    mode.removeLast()
                    counterparts.append(.blackMove(SAN.move(of: temp, color: .black)!))
                    temp = ""
                } else if mode.last! == .moveResult {
                    mode.removeLast()
                    counterparts.append(.moveResult(NAG(rawValue: temp)!))
                    temp = ""
                } else if mode.last! == .nag {
                    mode.removeLast()
                    temp = ""
                }
            }
        }
                
        return counterparts
    }

    private static func tagPair(from text: String) -> Counterpart? {
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
    
    private static func highlight(from text: String) -> [Counterpart] {
        if text.contains("#") {
            return []
        } else if text.contains("%csl") {
            let text = text.replacingOccurrences(of: "%csl", with: "").replacingOccurrences(of: " ", with: "")
            let parts = text.components(separatedBy: ",")
            var result: [Counterpart] = []
            for part in parts {
                var part = part
                let color = String(part.removeFirst())
                let square = part
                
                result.append(.squareHighlight(SAN.Square(square)!, PGN.HighlightColor(rawValue: color)!))
            }
            return result
        } else if text.contains("%cal") {
            let text = text.replacingOccurrences(of: "%cal", with: "").replacingOccurrences(of: " ", with: "")
            let parts = text.components(separatedBy: ",")
            var result: [Counterpart] = []
            for part in parts {
                var part = part
                let color = String(part.removeFirst())
                let from = String(part.prefix(2))
                let to = String(part.suffix(2))

                result.append(.arrow(from: SAN.Square(from)!, to: SAN.Square(to)!, color: PGN.HighlightColor(rawValue: color)!))
            }
            return result
        } else {
            return []
        }
    }
}
