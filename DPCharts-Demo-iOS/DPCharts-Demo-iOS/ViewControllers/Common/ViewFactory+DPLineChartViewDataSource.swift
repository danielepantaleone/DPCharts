//
//  ViewFactory+DPLineChartViewDataSource.swift
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

extension ViewFactory: DPLineChartViewDataSource {
    
    func numberOfLines(_ lineChartView: DPLineChartView) -> Int {
        return lineChartValues.count
    }
    
    func numberOfPoints(_ lineChartView: DPLineChartView) -> Int {
        return lineChartValues.first?.count ?? 0
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, valueForLineAtIndex lineIndex: Int, forPointAtIndex index: Int) -> CGFloat {
        return lineChartValues[lineIndex][index]
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, colorForLineAtIndex lineIndex: Int) -> UIColor {
        if lineIndex == 0 {
            return .primary500
        } else {
            return .secondary500
        }
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, widthForLineAtIndex lineIndex: Int) -> CGFloat {
        return 1.0
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, xAxisLabelAtIndex index: Int) -> String? {
        if let scalar = UnicodeScalar(index + Int(("A" as UnicodeScalar).value)) {
            return String(Character(scalar))
        }
        return "\(index)"
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, yAxisLabelAtIndex index: Int, for value: CGFloat) -> String? {
        return String(format: "%.2f", value)
    }
    
}
