//
//  Sequence+AdditiveArithmetic.swift
//  DPCharts
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
    
    /// Returns the total sum of all elements in the sequence
    func sum() -> Element {
        reduce(.zero, +)
    }
    
}
