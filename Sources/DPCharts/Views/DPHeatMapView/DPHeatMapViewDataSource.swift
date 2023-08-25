//
//  DPHeatMapViewDataSource.swift
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

/// A protocol to configure heatmap appearance.
public protocol DPHeatMapViewDataSource: AnyObject {
    /// The number of rows that we want to display in this heatmap chart.
    func numberOfRows(_ heatMapView: DPHeatMapView) -> Int
    /// The number of columns to display in this heatmap chart.
    func numberOfColumns(_ heatMapView: DPHeatMapView) -> Int
    /// The size for the given row/column combination.
    func heatMapView(_ heatMapView: DPHeatMapView, valueForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> CGFloat
    /// The text to display in the cell at the given row/column combination.
    func heatMapView(_ heatMapView: DPHeatMapView, textForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> String?
    /// The string to be displayed above/below the given column on the X-axis.
    func heatMapView(_ heatMapView: DPHeatMapView, xAxisLabelForColumnAtIndex columnIndex: Int) -> String?
    /// The string to be displayed before/after the given row on the Y-axis.
    func heatMapView(_ heatMapView: DPHeatMapView, yAxisLabelForRowAtIndex rowIndex: Int) -> String?
}

public extension DPHeatMapViewDataSource {
    
    func heatMapView(_ heatMapView: DPHeatMapView, xAxisLabelForColumnAtIndex columnIndex: Int) -> String? {
        return "\(columnIndex)"
    }
    func heatMapView(_ heatMapView: DPHeatMapView, yAxisLabelForRowAtIndex rowIndex: Int) -> String? {
        if let scalar = UnicodeScalar(rowIndex + Int(("A" as UnicodeScalar).value)) {
            return String(Character(scalar))
        }
        return "\(rowIndex)"
    }
    func heatMapView(_ heatMapView: DPHeatMapView, textForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> String? {
        return nil
    }
    
}

#if TARGET_INTERFACE_BUILDER
public class DPHeatMapViewIBDataSource: DPHeatMapViewDataSource {
    
    public func numberOfRows(_ heatMapView: DPHeatMapView) -> Int {
        return 6
    }
    public func numberOfColumns(_ heatMapView: DPHeatMapView) -> Int {
        return 8
    }
    public func heatMapView(_ heatMapView: DPHeatMapView, valueForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> CGFloat {
        return .random(in: 0...100)
    }
    
}
#endif
