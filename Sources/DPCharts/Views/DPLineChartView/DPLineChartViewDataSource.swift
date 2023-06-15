//
//  DPLineChartViewDataSource.swift
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

/// A protocol to configure line chart appearance.
public protocol DPLineChartViewDataSource: AnyObject {
    /// The number of lines in this chart.
    func numberOfLines(_ lineChartView: DPLineChartView) -> Int
    /// The number of points along the X-axis of the chart.
    func numberOfPoints(_ lineChartView: DPLineChartView) -> Int
    /// The value for the given line/index combination.
    func lineChartView(_ lineChartView: DPLineChartView, valueForLineAtIndex lineIndex: Int, forPointAtIndex index: Int) -> CGFloat
    /// The color for the given line.
    func lineChartView(_ lineChartView: DPLineChartView, colorForLineAtIndex lineIndex: Int) -> UIColor
    /// The width for the given line.
    func lineChartView(_ lineChartView: DPLineChartView, widthForLineAtIndex lineIndex: Int) -> CGFloat
    /// The string to be displayed below the marker at the given index on the X-axis.
    func lineChartView(_ lineChartView: DPLineChartView, xAxisLabelAtIndex index: Int) -> String?
    /// The string to be displayed right next to the marker at the given index on the Y-axis.
    func lineChartView(_ lineChartView: DPLineChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String?
}

public extension DPLineChartViewDataSource {
    
    func lineChartView(_ lineChartView: DPLineChartView, colorForLineAtIndex lineIndex: Int) -> UIColor {
        return DPLineChartView.defaultLineColor
    }
    func lineChartView(_ lineChartView: DPLineChartView, widthForLineAtIndex lineIndex: Int) -> CGFloat {
        return DPLineChartView.defaultLineWidth
    }
    func lineChartView(_ lineChartView: DPLineChartView, xAxisLabelAtIndex index: Int) -> String? {
        return "\(index)"
    }
    func lineChartView(_ lineChartView: DPLineChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
        return String(format: "%ld", Int(floor(value)))
    }
    
}

#if TARGET_INTERFACE_BUILDER
public class DPLineChartViewIBDataSource: DPLineChartViewDataSource {
    
    func numberOfPoints(_ lineChartView: DPLineChartView) -> Int {
        return 20
    }
    func numberOfLines(_ lineChartView: DPLineChartView) -> Int {
        return 1
    }
    func lineChartView(_ lineChartView: DPLineChartView, valueForLineAtIndex lineIndex: Int, forPointAtIndex index: Int) -> CGFloat {
        return .random(in: 100...300)
    }
    
}
#endif
