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
    
    func numberOfBars(_ barChartView: DPBarChartView) -> Int {
        return barChartValues.count
    }

    func numberOfItems(_ barChartView: DPBarChartView) -> Int {
        return barChartValues.first?.count ?? 0
    }

    func barChartView(_ barChartView: DPBarChartView, valueForBarAtIndex barIndex: Int, forItemAtIndex index: Int) -> CGFloat {
        return barChartValues[barIndex][index]
    }

    func barChartView(_ barChartView: DPBarChartView, colorForBarAtIndex barIndex: Int) -> UIColor {
        if barIndex == 0 {
            return .blue
        } else {
            return .gray
        }
    }

    func barChartView(_ barChartView: DPBarChartView, labelForMarkerOnXAxisAtItem index: Int) -> String? {
        return "\(index + 2000)"
    }

    func barChartView(_ barChartView: DPBarChartView, labelForMarkerOnYAxisAtIndex index: Int, for value: CGFloat) -> String? {
        return String(format: "%ld", Int(floor(value)))
    }
    
}
