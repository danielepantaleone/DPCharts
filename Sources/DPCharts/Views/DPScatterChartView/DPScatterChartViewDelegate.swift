//
//  DPScatterChartViewDelegate.swift
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

/// A protocol to handle scatter chart user interaction.
public protocol DPScatterChartViewDelegate: AnyObject {
    /// Sent to the delegate when the user touches the chart.
    func scatterChartView(_ lineChartView: DPScatterChartView, didTouchDatasetAtIndex datasetIndex: Int, withPointAt index: Int)
    /// Sent to the delegate when the user releases the touch from the chart.
    func scatterChartView(_ lineChartView: DPScatterChartView, didReleaseTouchFromDatasetAtIndex datasetIndex: Int, withPointAt index: Int)
}
