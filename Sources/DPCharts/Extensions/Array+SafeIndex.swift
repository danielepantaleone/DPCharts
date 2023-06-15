//
//  Array+SafeIndex.swift
//  DPCharts
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import Foundation

extension Array {
    
    /// Returns the element at the specified index or `nil` if no element is found.
    ///
    /// - parameters:
    ///   - safeIndex: The index for the element lookup
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
}
