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
    var heatMapValues: [[CGFloat]] = []
    
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
            case .heatmap:
                return createHeatmap(xAxisInverted: false, yAxisInverted: false)
            case .heatmapXAxisInverted:
                return createHeatmap(xAxisInverted: true, yAxisInverted: false)
            case .heatmapYAxisInverted:
                return createHeatmap(xAxisInverted: false, yAxisInverted: true)
            case .heatmapXandYAxisInverted:
                return createHeatmap(xAxisInverted: true, yAxisInverted: true)
            case .legendHorizontal:
                return createLegend(horizontal: true)
            case .legendVertical:
                return createLegend(horizontal: false)
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
        // BARCHART
        barChartValues = [
            (0..<6).map { _ in .random(in: 20...200) },
            (0..<6).map { _ in .random(in: 20...200) }
        ]
        // LINECHART
        lineChartValues = [
            (0..<20).map { _ in .random(in: 20...100) },
            (0..<20).map { _ in .random(in: 20...100) }
        ]
        // PIE CHART
        pieChartValues = (0..<4).map { _ in
            return CGFloat.random(in: 0...100)
        }
        // SCATTER CHART
        scatterChartValues = [
            (0..<40).map { _ in CGPoint(x: .random(in: 100...220), y: .random(in: 100...220)) },
            (0..<20).map { _ in CGPoint(x: .random(in: 10...120), y: .random(in: 10...120)) }
        ]
        // HEATMAP
        heatMapValues = []
        for i in 0..<8 {
            heatMapValues.insert([], at: i)
            for j in 0..<10 {
                heatMapValues[i].insert(.random(in: 0...100), at: j)
            }
        }
    }

}

// MARK: - Factory implementation

extension ViewFactory {

    func createBarChart(stacked: Bool, yAxisInverted: Bool) -> DPBarChartView {
        let barChartView = DPBarChartView()
        barChartView.datasource = self
        barChartView.barStacked = stacked
        barChartView.axisColor = .grey500
        barChartView.markersLineColor = .grey500
        barChartView.markersTextColor = .grey500
        barChartView.xAxisTitle = "Title of X-axis"
        barChartView.yAxisInverted = yAxisInverted
        barChartView.yAxisMarkersWidthRetained = true
        barChartView.yAxisTitle = "Title of Y-axis"
        barChartView.topSpacing = 8
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return barChartView
    }
    
    func createLegend(horizontal: Bool) -> DPLegendView {
        let legendView = DPLegendView()
        legendView.datasource = self
        legendView.horizontal = horizontal
        legendView.spacing = horizontal ? 8.0 : 4.0
        legendView.textColor = .grey500
        legendView.translatesAutoresizingMaskIntoConstraints = false
        return legendView
    }
    
    func createHeatmap(xAxisInverted: Bool, yAxisInverted: Bool) -> DPHeatMapView {
        let heatmapView = DPHeatMapView()
        heatmapView.datasource = self
        heatmapView.xAxisInverted = xAxisInverted
        heatmapView.yAxisInverted = yAxisInverted
        heatmapView.axisLabelsTextColor = .grey500
        heatmapView.cellAbsenceColor = .grey300
        heatmapView.cellLowPercentageColor = .secondary300
        heatmapView.cellHighPercentageColor = .green600
        heatmapView.translatesAutoresizingMaskIntoConstraints = false
        heatmapView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return heatmapView
    }
    
    func createLineChart(bezierCurveEnabled: Bool, areaEnabled: Bool, yAxisInverted: Bool) -> DPLineChartView {
        let lineChartView = DPLineChartView()
        lineChartView.datasource = self
        lineChartView.bezierCurveEnabled = bezierCurveEnabled
        lineChartView.areaEnabled = areaEnabled
        lineChartView.axisColor = .grey500
        lineChartView.markersLineColor = .grey500
        lineChartView.markersTextColor = .grey500
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
        pieChartView.labelsColor = .grey500
        pieChartView.donutEnabled = asDonut
        pieChartView.donutTitle = "Title"
        pieChartView.donutSubtitle = "Brief description"
        pieChartView.donutVerticalSpacing = 4.0
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        return pieChartView
    }
    
    func createScatterChart(yAxisInverted: Bool) -> DPScatterChartView {
        let scatterChartView = DPScatterChartView()
        scatterChartView.datasource = self
        scatterChartView.axisColor = .grey500
        scatterChartView.markersLineColor = .grey500
        scatterChartView.markersTextColor = .grey500
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
