//
//  ViewFactory+DPHeatMapViewDataSource.swift
//  DPCharts-Demo-iOS
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import DPCharts
import Foundation
import UIKit

extension ViewFactory: DPHeatMapViewDataSource {
    
    func numberOfRows(_ heatMapView: DPHeatMapView) -> Int {
        return heatMapValues.count
    }
    func numberOfColumns(_ heatMapView: DPHeatMapView) -> Int {
        return heatMapValues.map { $0.count }.max() ?? 0
    }
    func heatMapView(_ heatMapView: DPHeatMapView, valueForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> CGFloat {
        return heatMapValues[rowIndex][columnIndex]
    }
    func heatMapView(_ heatMapView: DPHeatMapView, textForRowAtIndex rowIndex: Int, forColumnAtIndex columnIndex: Int) -> String? {
        if heatMapView.cellTextEnabled {
            return "\(Int(heatMapValues[rowIndex][columnIndex]))"
        } else {
            return nil
        }
    }
    
    func heatMapView(_ heatMapView: DPHeatMapView, xAxisLabelForColumnAtIndex columnIndex: Int) -> String? {
        return "\(columnIndex)"
    }
    func heatMapView(_ heatMapView: DPHeatMapView, yAxisLabelForRowAtIndex rowIndex: Int) -> String? {
        if let scalar = UnicodeScalar(rowIndex + Int(("A" as UnicodeScalar).value)) {
            return String(Character(scalar))
        }
        return "\(rowIndex)"
    }
    
}
