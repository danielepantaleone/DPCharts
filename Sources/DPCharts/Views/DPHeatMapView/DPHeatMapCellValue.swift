//
//  DPHeatMapCellValue.swift
//  DPCharts
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import Foundation
import UIKit

/// A struct to model heatmap values.
public struct DPHeatMapCellValue: Equatable {
    
    static let zero: DPHeatMapCellValue = DPHeatMapCellValue(value: 0, percentage: 0, rowIndex: 0, columnIndex: 0)
    
    var value: CGFloat
    var percentage: CGFloat
    var rowIndex: Int
    var columnIndex: Int
    
}

