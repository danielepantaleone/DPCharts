//
//  ViewFactory.swift
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

// MARK: - ViewFactory

class ViewFactory {

    // MARK: - Properties

    var barChartValues: [[CGFloat]] = []
    var lineChartValues: [[CGFloat]] = []

    // MARK: - Initialization

    init() {
        reloadDatasets()
    }

    // MARK: - Interface

    func createView(ofType type: ViewType) -> UIView {
        switch type {
            case .barChart:
                return createBarChart(yAxisInverted: false)
            case .barChartYAxisInverted:
                return createBarChart(yAxisInverted: true)
            case .lineChart:
                return createLineChart(bezierCurveEnabled: false, areaEnabled: false, yAxisInverted: false)
            case .lineChartArea:
                return createLineChart(bezierCurveEnabled: false, areaEnabled: true, yAxisInverted: false)
            case .lineChartBezier:
                return createLineChart(bezierCurveEnabled: true, areaEnabled: false, yAxisInverted: false)
            case .lineChartBezierArea:
                return createLineChart(bezierCurveEnabled: true, areaEnabled: true, yAxisInverted: false)
            case .lineChartYAxisInverted:
                return createLineChart(bezierCurveEnabled: false, areaEnabled: false, yAxisInverted: true)
            case .lineChartYAxisInvertedArea:
                return createLineChart(bezierCurveEnabled: false, areaEnabled: true, yAxisInverted: true)
            case .lineChartYAxisInvertedBezier:
                return createLineChart(bezierCurveEnabled: true, areaEnabled: false, yAxisInverted: true)
            case .lineChartYAxisInvertedBezierArea:
                return createLineChart(bezierCurveEnabled: true, areaEnabled: true, yAxisInverted: true)
        }
    }

    func reloadDatasets() {
        barChartValues = [
            (0..<6).map { _ in CGFloat.random(in: (20)...(200)) },
            (0..<6).map { _ in CGFloat.random(in: (20)...(200)) }
        ]
        lineChartValues = [
            (0..<20).map { _ in CGFloat.random(in: (20)...(100)) },
            (0..<20).map { _ in CGFloat.random(in: (20)...(100)) }
        ]
    }

}

// MARK: - Factory implementation

extension ViewFactory {

    private func createBarChart(yAxisInverted: Bool) -> DPBarChartView {
        let barChartView = DPBarChartView()
        barChartView.datasource = self
        barChartView.xAxisTitle = "Title of X-axis"
        barChartView.yAxisInverted = yAxisInverted
        barChartView.yAxisMarkersWidthRetained = true
        barChartView.yAxisTitle = "Title of Y-axis"
        barChartView.topSpacing = 8
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return barChartView
    }
    
    func createLineChart(bezierCurveEnabled: Bool, areaEnabled: Bool, yAxisInverted: Bool) -> DPLineChartView {
        let lineChartView = DPLineChartView()
        lineChartView.datasource = self
        lineChartView.bezierCurveEnabled = bezierCurveEnabled
        lineChartView.areaEnabled = areaEnabled
        lineChartView.xAxisTitle = "Title of X-axis"
        lineChartView.yAxisInverted = yAxisInverted
        lineChartView.yAxisMarkersWidthRetained = true
        lineChartView.yAxisTitle = "Title of Y-axis"
        lineChartView.topSpacing = 8
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return lineChartView
    }

}
