//
//  ViewType.swift
//  DPCharts-Demo-iOS
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

enum ViewType: String, CaseIterable {
    case barChart = "Bar chart"
    case barChartStacked = "Bar chart (stacked)"
    case barChartYAxisInverted = "Bar chart (Y-axis inverted)"
    case barChartYAxisInvertedStacked = "Bar chart (Y-axis inverted + stacked)"
    case lineChart = "Line chart"
    case lineChartArea = "Line chart (area)"
    case lineChartBezier = "Line chart (bezier curve)"
    case lineChartBezierArea = "Line chart (bezier curve + area)"
    case lineChartYAxisInverted = "Line chart (Y-axis inverted)"
    case lineChartYAxisInvertedArea = "Line chart (Y-axis inverted + area)"
    case lineChartYAxisInvertedBezier = "Line chart (Y-axis inverted + bezier curve)"
    case lineChartYAxisInvertedBezierArea = "Line chart (Y-axis inverted, bezier curve + area)"
}
