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
    var pieChartValues: [CGFloat] = []
    var scatterChartValues: [[CGPoint]] = []

    
    // MARK: - Initialization

    init() {
        reloadDatasets()
    }

    // MARK: - Interface

    func createView(ofType type: ViewType) -> UIView {
        switch type {
            case .barChart:
                return createBarChart(stacked: false, yAxisInverted: false)
            case .barChartStacked:
                return createBarChart(stacked: true, yAxisInverted: false)
            case .barChartYAxisInverted:
                return createBarChart(stacked: false, yAxisInverted: true)
            case .barChartYAxisInvertedStacked:
                return createBarChart(stacked: true, yAxisInverted: true)
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
            case .pieChart:
                return createPieChart(asDonut: false)
            case .pieChartDonut:
                return createPieChart(asDonut: true)
            case .scatterChart:
                return createScatterChart(yAxisInverted: false)
            case .scatterChartYAxisInverted:
                return createScatterChart(yAxisInverted: true)
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
        pieChartValues = (0..<4).map { _ in
            return CGFloat.random(in: (0)...(100))
        }
        scatterChartValues = [
            (0..<40).map { _ in CGPoint(x: .random(in: 100...220), y: .random(in: 100...220)) },
            (0..<20).map { _ in CGPoint(x: .random(in: 10...120), y: .random(in: 10...120)) },
        ]
    }

}

// MARK: - Factory implementation

extension ViewFactory {

    func createBarChart(stacked: Bool, yAxisInverted: Bool) -> DPBarChartView {
        let barChartView = DPBarChartView()
        barChartView.datasource = self
        barChartView.barStacked = stacked
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
    
    func createPieChart(asDonut: Bool) -> DPPieChartView {
        let pieChartView = DPPieChartView()
        pieChartView.datasource = self
        pieChartView.donutEnabled = asDonut
        pieChartView.donutTitle = "550km"
        pieChartView.donutSubtitle = "Total distance"
        pieChartView.donutVerticalSpacing = 4.0
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        return pieChartView
    }
    
    func createScatterChart(yAxisInverted: Bool) -> DPScatterChartView {
        let scatterChartView = DPScatterChartView()
        scatterChartView.datasource = self
        scatterChartView.xAxisTitle = "Title of X-axis"
        scatterChartView.yAxisInverted = yAxisInverted
        scatterChartView.yAxisMarkersWidthRetained = true
        scatterChartView.yAxisTitle = "Title of Y-axis"
        scatterChartView.topSpacing = 8
        scatterChartView.translatesAutoresizingMaskIntoConstraints = false
        scatterChartView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return scatterChartView
    }

}