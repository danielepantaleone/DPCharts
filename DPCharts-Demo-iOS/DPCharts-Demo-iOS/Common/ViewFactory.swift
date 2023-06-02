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
        }
    }

    func reloadDatasets() {
        barChartValues = [
            (0..<6).map { _ in CGFloat.random(in: (0)...(200)) },
            (0..<6).map { _ in CGFloat.random(in: (0)...(200)) }
        ]
    }

}

// MARK: - Factory implementation

extension ViewFactory {

    private func createBarChart(yAxisInverted: Bool) -> UIView {
        let barChartView = DPBarChartView()
        barChartView.datasource = self
        barChartView.topSpacing = 8
        barChartView.yAxisInverted = yAxisInverted
        barChartView.yAxisMarkersWidthRetained = true
        barChartView.xAxisTitle = "Title of X-axis"
        barChartView.yAxisTitle = "Title of Y-axis"
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return barChartView
    }

    // MARK: - Misc

    private func centered(view: UIView) -> UIView {
        let containerView = UIView(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        view.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }

}
