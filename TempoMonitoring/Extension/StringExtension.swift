//
//  StringExtension.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation

extension String {
    // MARK: Source from: https://github.com/mRs-/HexColors/blob/master/Sources/HexColors.swift
    mutating func removeHashIfNecessary() {
      if hasPrefix("#") {
        self = replacingOccurrences(of: "#", with: "")
      }
    }
    
    // MARK: source from: https://github.com/DragonCherry/VersionCompare
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: versionDelimiter)
                .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
        }
        return result
    }
    
    public func isVersion(equalTo targetVersion: String) -> Bool {
        return self.compare(toVersion: targetVersion) == .orderedSame
        
    }
    public func isVersion(greaterThan targetVersion: String) -> Bool {
        return self.compare(toVersion: targetVersion) == .orderedDescending
        
    }
    public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool {
        return self.compare(toVersion: targetVersion) != .orderedAscending
        
    }
    public func isVersion(lessThan targetVersion: String) -> Bool {
        return self.compare(toVersion: targetVersion) == .orderedAscending
        
    }
    public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool {
        return self.compare(toVersion: targetVersion) != .orderedDescending
    }
}
