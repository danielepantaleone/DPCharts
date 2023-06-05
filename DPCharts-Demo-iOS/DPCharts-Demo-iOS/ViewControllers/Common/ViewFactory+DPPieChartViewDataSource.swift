//
//  ViewFactory+DPPieChartViewDataSource.swift
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

extension ViewFactory: DPPieChartViewDataSource {
    
    func numberOfSlices(_ pieChartView: DPPieChartView) -> Int {
        return pieChartValues.count
    }

    func pieChartView(_ pieChartView: DPPieChartView, valueForSliceAtIndex index: Int) -> CGFloat {
        return pieChartValues[index]
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

    func pieChartView(_ pieChartView: DPPieChartView, labelForSliceAtIndex index: Int, forValue value: CGFloat, withTotal total: CGFloat) -> String? {
        return String(format: "%.2f%%", (value / total * 100))
    }
   
}

