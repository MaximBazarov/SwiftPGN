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

        guard let regularExpression = try? NSRegularExpression(pattern: pattern, options: []) else {
            return matchList
        }

        let range = NSMakeRange(0, nsString.length)
        let result = regularExpression.matches(in: self, options: [], range: range)

        let matches = result.map { nsString.substring(with: $0.range) }

        for match in matches {
            matchList.append(match)
        }

        return matchList
    }
}
