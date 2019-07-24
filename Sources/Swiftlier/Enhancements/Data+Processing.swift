//
//  Data+Processing.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/16/17.
//
//

import Foundation

extension Data {
    public func ranges(of: Data, in search: Range<Data.Index>? = nil) -> [Range<Data.Index>] {
        var output = [Range<Data.Index>]()

        var search = search ?? 0 ..< self.count
        while let range = self.range(of: of, in: search) {
            output.append(range)
            search = range.upperBound ..< search.upperBound
        }

        return output
    }

    public func ranges(separatedBy separator: Data, in search: Range<Data.Index>? = nil) -> [Range<Data.Index>] {
        let search = search ?? 0 ..< self.count
        let ranges = self.ranges(of: separator, in: search)
        guard let first = ranges.first else {
            return [search]
        }

        let last = ranges.last!

        var output: [Range<Data.Index>] = [search.lowerBound ..< first.lowerBound]
            + ranges.enumerateByTwos().map({ $0.upperBound ..< $1.lowerBound})
        output.append(last.upperBound ..< search.upperBound)
        return output.filter({$0.count > 0})
    }
}
