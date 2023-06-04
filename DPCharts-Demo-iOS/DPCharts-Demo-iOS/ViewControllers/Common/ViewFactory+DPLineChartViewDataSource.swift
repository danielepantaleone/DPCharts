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
            return .blue
        } else {
            return .gray
        }
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, widthForLineAtIndex lineIndex: Int) -> CGFloat {
        return 1.0
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, labelForMarkerOnXAxisAtIndex index: Int) -> String? {
        return "\(index + 2000)"
    }
    
    func lineChartView(_ lineChartView: DPLineChartView, labelForMarkerOnYAxisAtIndex index: Int, for value: CGFloat) -> String? {
        return String(format: "%.2f", value)
    }
    
}
