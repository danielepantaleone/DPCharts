//
//  DPBarChartViewDataSource.swift
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

/// A protocol to configure bar chart appearance.
public protocol DPBarChartViewDataSource: AnyObject {
    /// The number of bars in this chart.
    func numberOfBars(_ barChartView: DPBarChartView) -> Int
    /// The number of items along the X-axis of the chart.
    func numberOfItems(_ barChartView: DPBarChartView) -> Int
    /// The value for the given bar/index combination.
    func barChartView(_ barChartView: DPBarChartView, valueForBarAtIndex barIndex: Int, forItemAtIndex index: Int) -> CGFloat
    /// The color for the given bar.
    func barChartView(_ barChartView: DPBarChartView, colorForBarAtIndex barIndex: Int) -> UIColor
    /// The string to be displayed below the item on the X-axis.
    func barChartView(_ barChartView: DPBarChartView, xAxisLabelForItemAtIndex index: Int) -> String?
    /// The string to be displayed right next to the given index on the Y-axis.
    func barChartView(_ barChartView: DPBarChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String?
}

public extension DPBarChartViewDataSource {
    
    func barChartView(_ barChartView: DPBarChartView, colorForBarAtIndex barIndex: Int) -> UIColor {
        return DPBarChartView.defaultBarColor
    }
    func barChartView(_ barChartView: DPBarChartView, xAxisLabelForItemAtIndex index: Int) -> String? {
        return "\(index)"
    }
    func barChartView(_ barChartView: DPBarChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
        return String(format: "%ld", Int(floor(value)))
    }
    
}

#if TARGET_INTERFACE_BUILDER
public class DPBarChartViewIBDataSource: DPBarChartViewDataSource {
    
    func numberOfBars(_ barChartView: OCTOBarChartView) -> Int {
        return 1
    }
    func numberOfItems(_ barChartView: OCTOBarChartView) -> Int {
        return 8
    }
    func barChartView(_ barChartView: OCTOBarChartView, valueForBarAtIndex barIndex: Int, forItemAtIndex index: Int) -> CGFloat {
        return .random(in: 100...200)
    }
    
}
#endif
