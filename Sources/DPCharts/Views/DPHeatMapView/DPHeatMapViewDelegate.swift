//
//  DPHeatMapViewDelegate.swift
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

/// A protocol to handle heatmap user interaction.
public protocol DPHeatMapViewDelegate: AnyObject {
    /// Sent to the delegate when the user touches the chart.
    func heatMapView(_ heatMapView: DPHeatMapView, didTouchAtRowIndex rowIndex: Int, andColumnIndex columnIndex: Int)
    /// Sent to the delegate when the user releases the touch from the chart.
    func heatMapView(_ heatMapView: DPHeatMapView, didReleaseTouchFromRowIndex rowIndex: Int, andColumnIndex columnIndex: Int)
}
