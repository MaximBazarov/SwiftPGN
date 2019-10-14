//
//  String+Regex.swift
//  SwiftPGNTests
//
//  Created by Maxim Bazarov on 06.10.19.
//

import Foundation

extension String {
    
    func groups(for regexPattern: String) throws -> [[String]] {        
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
        
    }
}
