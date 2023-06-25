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
    case barChartYAxisInverted = "Bar chart (Y inverted)"
    case barChartYAxisInvertedStacked = "Bar chart (Y inverted + stacked)"
    case heatmap = "Heatmap"
    case heatmapXAxisInverted = "Heatmap (X inverted)"
    case heatmapYAxisInverted = "Heatmap (Y inverted)"
    case heatmapXandYAxisInverted = "Heatmap (X/Y inverted)"
    case heatmapText = "Heatmap (text)"
    case heatmapTextXAxisInverted = "Heatmap (X inverted + text)"
    case heatmapTextYAxisInverted = "Heatmap (Y inverted + text)"
    case heatmapTextXandYAxisInverted = "Heatmap (X/Y inverted + text)"
    case legendHorizontal = "Legend (horizontal stack)"
    case legendVertical = "Legend (vertical stack)"
    case lineChart = "Line chart"
    case lineChartArea = "Line chart (area)"
    case lineChartBezier = "Line chart (bezier curve)"
    case lineChartBezierArea = "Line chart (bezier curve + area)"
    case lineChartPoints = "Line chart (points)"
    case lineChartPointsArea = "Line chart (points + area)"
    case lineChartPointsBezier = "Line chart (points + bezier curve)"
    case lineChartPointsBezierArea = "Line chart (points + bezier curve + area)"
    case lineChartYAxisInverted = "Line chart (Y inverted)"
    case lineChartYAxisInvertedArea = "Line chart (Y inverted + area)"
    case lineChartYAxisInvertedBezier = "Line chart (Y inverted + bezier curve)"
    case lineChartYAxisInvertedBezierArea = "Line chart (Y inverted + bezier curve + area)"
    case lineChartYAxisInvertedPoints = "Line chart (Y inverted + points)"
    case lineChartYAxisInvertedPointsArea = "Line chart (Y inverted + points + area)"
    case lineChartYAxisInvertedPointsBezier = "Line chart (Y inverted + points + bezier curve)"
    case lineChartYAxisInvertedPointsBezierArea = "Line chart (Y inverted + points +bezier curve + area)"
    case pieChart = "Pie chart"
    case pieChartDonut = "Pie chart (donut)"
    case scatterChart = "Scatter chart"
    case scatterChartYAxisInverted = "Scatter chart (Y inverted)"
}
