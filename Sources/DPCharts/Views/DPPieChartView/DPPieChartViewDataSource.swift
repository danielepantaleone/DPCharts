//
//  DPPieChartViewDataSource.swift
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

/// A protocol to configure pie chart appearance.
public protocol DPPieChartViewDataSource: AnyObject {
    /// The number of slices in this chart
    func numberOfSlices(_ pieChartView: DPPieChartView) -> Int
    /// The value for the given slice
    func pieChartView(_ pieChartView: DPPieChartView, valueForSliceAtIndex index: Int) -> CGFloat
    /// The color for the given slice
    func pieChartView(_ pieChartView: DPPieChartView, colorForSliceAtIndex index: Int) -> UIColor
    /// The string to be displayed on the slice at the given index
    func pieChartView(_ pieChartView: DPPieChartView, labelForSliceAtIndex index: Int, forValue value: CGFloat, withTotal total: CGFloat) -> String?
}

public extension DPPieChartViewDataSource {
    
    func pieChartView(_ pieChartView: DPPieChartView, labelForSliceAtIndex index: Int, forValue value: CGFloat, withTotal total: CGFloat) -> String? {
        return String(format: "%.2f%%", (value / total * 100))
    }
    
}

#if TARGET_INTERFACE_BUILDER
public class DPPieChartViewIBDataSource: DPPieChartViewDataSource {
    
    func numberOfSlices(_ pieChartView: DPPieChartView) -> Int {
        return 4
    }
    func pieChartView(_ pieChartView: DPPieChartView, valueForSliceAtIndex index: Int) -> CGFloat {
        return .random(in: 10...100)
    }
    func pieChartView(_ pieChartView: DPPieChartView, colorForSliceAtIndex index: Int) -> UIColor {
        switch index {
            case 1:
                return .blue
            case 2:
                return .yellow
            case 3:
                return .red
            default:
                return .gray
        }
    }
  
}
#endif
