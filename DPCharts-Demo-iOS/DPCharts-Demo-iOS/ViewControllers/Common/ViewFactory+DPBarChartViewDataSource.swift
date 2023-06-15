//
//  ViewFactory+DPBarChartViewDataSource.swift
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

extension ViewFactory: DPBarChartViewDataSource {
    
    func numberOfDatasets(_ barChartView: DPBarChartView) -> Int {
        return barChartValues.count
    }

    func numberOfItems(_ barChartView: DPBarChartView) -> Int {
        return barChartValues.first?.count ?? 0
    }

    func barChartView(_ barChartView: DPBarChartView, valueForDatasetAtIndex datasetIndex: Int, forItemAtIndex index: Int) -> CGFloat {
        return barChartValues[datasetIndex][index]
    }

    func barChartView(_ barChartView: DPBarChartView, colorForDatasetAtIndex datasetIndex: Int) -> UIColor {
        if datasetIndex == 0 {
            return .primary500
        } else {
            return .secondary500
        }
    }

    func barChartView(_ barChartView: DPBarChartView, xAxisLabelForItemAtIndex index: Int) -> String? {
        if let scalar = UnicodeScalar(index + Int(("A" as UnicodeScalar).value)) {
            return String(Character(scalar))
        }
        return "\(index)"
    }

    func barChartView(_ barChartView: DPBarChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
        return String(format: "%ld", Int(floor(value)))
    }
    
}
