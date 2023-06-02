//
//  DPBarChartViewDelegate.swift
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

/// A protocol to handle bar chart user interaction.
public protocol DPBarChartViewDelegate: AnyObject {
    /// Sent to the delegate when the user touches the chart
    func barChartView(_ barChartView: DPBarChartView, didTouchAtItem index: Int)
    /// Sent to the delegate when the user releases the touch from the chart
    func barChartView(_ barChartView: DPBarChartView, didReleaseTouchFromItem index: Int)
}
