//
//  String+Regex.swift
//  SwiftPGNTests
//
//  Created by Maxim Bazarov on 06.10.19.
//

import Foundation

extension String {
    
    typealias RegexPattern = String
    
    func matches(withPattern pattern: RegexPattern) -> [String]  {
        let nsString = self as NSString
        var matchList: [String] = []
        
        guard let regularExpression = try? NSRegularExpression(
            pattern: pattern,
            options: [])
            else { return matchList }
        
        let range = NSMakeRange(0, nsString.length)
        let result = regularExpression.matches(in: self, options: [], range: range)
        
        let matches = result.map { nsString.substring(with: $0.range) }
        
        for match in matches {
            matchList.append(match)
        }
        
        return matchList
    }
    
    
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(
                in: text,
                range: NSRange(text.startIndex..., in: text)
            )
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
