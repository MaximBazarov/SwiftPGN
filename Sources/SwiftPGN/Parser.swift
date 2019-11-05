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
    
    private class OperatingData {
        var text: String = ""
        let mode: OperatingMode
        
        var stack: [OperatingData]?
        private var counterparts: [Counterpart]?
        
        init(with mode: OperatingMode) {
            self.mode = mode
            if mode == .annotation {
                stack = []
                counterparts = []
            }
        }
        
        func data() -> Counterpart {
            switch mode {
            case .tagPair:
                return tagPair(from: text)!
            case .annotation:
                return .annotation(counterparts!)
            default:
                return .text("\(mode.rawValue) = \(text)")
            }
        }
        
        func closeCurrent() {
            if let top = stack?.last {
                counterparts?.append(top.data())
                stack?.removeLast()
            }
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
    }
    
    public func parse(pgn text: String) -> [Counterpart] {
        let text = text.replacingOccurrences(of: "\n", with: " ")
        var counterparts: [Counterpart] = []
        var _stack: [OperatingData] = []
        
        var stack: [OperatingData] {
            if _stack.last?.stack != nil {
                return _stack.last!.stack!
            } else {
                return _stack
            }
        }
        
        var top: OperatingData? {
            return stack.last
        }
        
        func append(_ data: OperatingData) {
            if _stack.last?.stack != nil {
                _stack.last!.stack!.append(data)
            } else {
                _stack.append(data)
            }
        }
        
        func closeCurrent() {
            if _stack.last?.stack != nil {
                _stack.last!.closeCurrent()
            } else {
                counterparts.append(top!.data())
                _stack.removeLast()
            }
        }
        
        for symbol in text {
            let symbol = String(symbol)
            switch symbol {
            case "[":
                //closeCurrent()
                if stack.isEmpty {
                    append(OperatingData(with: .tagPair))
                } else {
                    append(OperatingData(with: .squareHighlight))
                }
            case "]":
                closeCurrent()
            case "{":
                append(OperatingData(with: .text))
            case "}":
                closeCurrent()
            case "(":
                append(OperatingData(with: .annotation))
            case ")":
                closeCurrent()
                counterparts.append(_stack.last!.data())
                _stack.removeLast()
            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if top == nil || top?.mode == .annotation {
                    append(OperatingData(with: .turn))
                }
                top?.text += symbol
            case ".":
                if top?.mode == .turn {
                    closeCurrent()
                    append(OperatingData(with: .whiteMove))
                } else if top?.mode == .whiteMove {
                    //removeLast()
                    append(OperatingData(with: .blackMove))
                } else {
                    top?.text += symbol
                }
            case " ":
                if let top = top {
                    if top.mode == .whiteMove {
                        closeCurrent()
                        append(OperatingData(with: .blackMove))
                    } else if top.mode == .blackMove {
                        closeCurrent()
                    } else {
                        top.text += symbol
                    }
                } else {
                    top?.text += symbol
                }
            default: top?.text += symbol
            }
        }
        
        return counterparts
    }
    
//    public func parse(pgn text: String) -> [Counterpart] {
//        let text = text.replacingOccurrences(of: "\n", with: " ")
//
//        var currentText: String = ""
//        var currentTurn: TurnNumber?
//
//        var counterparts: [[Counterpart]] = [[]]
//        var currentCounterpartsIndex: Int {
//            return counterparts.endIndex - 1
//        }
//        var currentCounterparts: [Counterpart] {
//            assert(counterparts.count >= 1)
//            return counterparts.last!
//        }
//
//        var stackOfOperatingMode: [OperatingMode] = [.none]
//        var currentOperatingMode: OperatingMode {
//            assert(stackOfOperatingMode.count >= 1)
//            return stackOfOperatingMode.last!
//        }
//
//        for symbol in text {
//            let symbol = String(symbol)
//            switch symbol {
//            case "[":
//                if currentOperatingMode == .none {
//                    currentText = ""
//                    stackOfOperatingMode.append(.tagPair)
//                } else if currentOperatingMode == .text {
//                    currentText = ""
//                    stackOfOperatingMode.append(.squareHighlight)
//                } else if currentOperatingMode == .annotation {
//                    currentText = ""
//                    stackOfOperatingMode.append(.squareHighlight)
//                } else {
//                    currentText += symbol
//                }
//            case "]":
//                if currentOperatingMode == .tagPair {
//                    guard let tagPair = tagPair(from: currentText) else {
//                        return []
//                    }
//                    currentText = ""
//                    stackOfOperatingMode.removeLast()
//                    var parts = currentCounterparts
//                    parts.append(tagPair)
//                    counterparts[currentCounterpartsIndex] = parts
//                } else if currentOperatingMode == .squareHighlight {
//                    // TODO
//                    stackOfOperatingMode.removeLast()
//                    var parts = currentCounterparts
//                    parts.append(.text(currentText))
//                    counterparts[currentCounterpartsIndex] = parts
//                    currentText = ""
//                } else {
//                    currentText += symbol
//                }
//            case "{":
//                stackOfOperatingMode.append(.text)
//                currentText = ""
//            case "}":
//                if currentOperatingMode == .text {
//                    var parts = currentCounterparts
//                    parts.append(.text(currentText))
//                    counterparts[currentCounterpartsIndex] = parts
//                    currentText = ""
//                    stackOfOperatingMode.removeLast()
//                }
//            case "(":
//                stackOfOperatingMode.append(.annotation)
//                counterparts.append([])
//                currentText = ""
//            case ")":
//                if currentOperatingMode == .annotation || currentOperatingMode == .blackMove {
//                    let annotationParts = counterparts.popLast()!
//                    currentText = ""
//                    stackOfOperatingMode.removeLast()
//                    if currentOperatingMode == .none {
//                        switch currentCounterparts.last! {
//                        case .turn(let turn, let coun):
//                            var parts = currentCounterparts
//                            parts.removeLast()
//                            let dsf = coun + annotationParts
//                            parts.append(.turn(turn, dsf))
//                            counterparts[currentCounterpartsIndex] = parts
//                        default: break
//                        }
//                    } else {
//                        var parts = currentCounterparts
//                        parts.append(.annotation(annotationParts))
//                        counterparts[currentCounterpartsIndex] = parts
//                    }
//                }
//            case "1", "2", "3", "4", "5", "6", "7", "8", "9":
//                if currentOperatingMode == .none || currentOperatingMode == .annotation {
//                    stackOfOperatingMode.append(.turn)
//                    counterparts.append([])
//                    currentText = ""
//                }
//                currentText += symbol
//            case ".":
//                if currentOperatingMode == .turn {
//                    currentTurn = TurnNumber(currentText)
//                    stackOfOperatingMode.append(.whiteMove)
//                    currentText = ""
//                } else if currentOperatingMode == .whiteMove {
//                    stackOfOperatingMode.removeLast()
//                    stackOfOperatingMode.append(.blackMove)
//                    currentText = ""
//                } else if currentOperatingMode == .blackMove {
//                    currentText = ""
//                } else {
//                    currentText += symbol
//                }
//            case " ":
//                if currentOperatingMode == .whiteMove {
//                    var parts = currentCounterparts
//                    parts.append(.text(currentText))
//                    counterparts[currentCounterpartsIndex] = parts
//                    currentText = ""
//                    stackOfOperatingMode.removeLast()
//                    stackOfOperatingMode.append(.blackMove)
//                } else if currentOperatingMode == .blackMove && !currentText.isEmpty {
//                    var parts = currentCounterparts
//                    parts.append(.text(currentText))
//                    counterparts[currentCounterpartsIndex] = parts
//                    currentText = ""
//                    stackOfOperatingMode.removeLast()
//
//                    let turnParts = counterparts.popLast()!
//                    var _parts = currentCounterparts
//                    _parts.append(.turn(currentTurn!, turnParts))
//                    counterparts[currentCounterpartsIndex] = _parts
//                    currentText = ""
//                    stackOfOperatingMode.removeLast()
//                }
//            default:
//                currentText += symbol
//            }
//
//            print(currentText)
//            print(currentOperatingMode)
//        }
//
//        print(counterparts)
//        assert(counterparts.count == 1)
//
//        return currentCounterparts
//    }
    

    //
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

private extension String {
    func findTurns() -> [String] {
        let fullMovePattern = "(\\d{1,3}\\.)"
        guard let regularExpression = try? NSRegularExpression(pattern: fullMovePattern, options: []) else { return [] }
        
        let str = self as NSString
        
        let rangesForOpeningBracket = self.ranges(for: "(")
        let rengesForClosingBracket = self.ranges(for: ")")
        
        guard rangesForOpeningBracket.count == rengesForClosingBracket.count else { return [] }
        
        var commentsRanges: [NSRange] = []
        for index in 0..<rangesForOpeningBracket.count {
            let open = rangesForOpeningBracket[index]
            let close = rengesForClosingBracket[index]
            commentsRanges.append(NSRange(location: open.location, length: close.location - open.location + 1))
        }
        
        var regularExpressionResults = regularExpression.matches(in: self, options: [], range: NSRange(location: 0, length: str.length))
        regularExpressionResults = regularExpressionResults.filter { result in
            for range in commentsRanges {
                if range.contains(result.range.location) {
                    return false
                }
            }
            return true
        }
        
        class FullMoveCounter {
            var string: String
            var range: NSRange
            var asInt: Int { return Int(string) ?? 0 }
            
            init(string: String, range: NSRange) {
                self.string = string
                self.range = range
            }
        }
        
        var fullMoveCounters: [FullMoveCounter] = []
        for result in regularExpressionResults {
            fullMoveCounters.append(FullMoveCounter(string: str.substring(with: result.range).replacingOccurrences(of: ".", with: ""), range: result.range))
        }

        var lastResult: FullMoveCounter?
        var results: [FullMoveCounter] = []
        for result in fullMoveCounters {
            if lastResult == nil {
                lastResult = result
                results.append(result)
            } else {
                if lastResult!.asInt < result.asInt {
                    results.append(result)
                    let length = result.range.location - lastResult!.range.location
                    lastResult!.range = NSRange(location: lastResult!.range.location, length: length)
                    lastResult = result
                } else {
                    lastResult!.range = NSRange(location: lastResult!.range.location, length: lastResult!.range.length + result.range.length)
                }
            }
        }

        if let last = results.last {
            let length = str.length - last.range.location
            last.range = NSRange(location: last.range.location, length: length)
        }

        return results.compactMap { str.substring(with: $0.range) }
    }
}

private extension String {
    func ranges(for char: String) -> [NSRange] {
        var result: [NSRange] = []
        for (index, ch) in self.enumerated() {
            if ch == Character(char) {
                result.append(NSRange(location: index, length: 1))
            }
        }
        
        return result
    }
}
