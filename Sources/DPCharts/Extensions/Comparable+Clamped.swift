//
//  Comparable+Clamped.swift
//  DPCharts
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import Foundation

extension Comparable {
    
    /// Clamp the current value so that it's contained within the provided range.
    ///
    /// - parameters:
    ///   - limits: The range used to limit the value
    ///
    /// - returns: The clamped value
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
    
}
