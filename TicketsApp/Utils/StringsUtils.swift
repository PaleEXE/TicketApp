//
//  StringsUtils.swift
//  TicketsApp
//
//  Created by test on 07/07/2026.
//

import Foundation

extension String {
    func fromCamelToTitle() -> String {
        let pattern = "([a-z])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)

        let spacedString = regex?.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: "$1 $2"
        ) ?? self

        return spacedString.prefix(1).capitalized + spacedString.dropFirst()
    }
}
