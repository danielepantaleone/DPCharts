//
//  DPScatterChartView.swift
//  DPCharts
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import Foundation
import UIKit

// MARK: - DPScatterChartView

/// A scatter chart that draws according with a provided datasource.
@IBDesignable
open class DPScatterChartView: DPCanvasView {
    
    // MARK: - Static properties
    
    /// Default size for scatter points
    static let defaultPointSize: CGFloat = 10.0
    /// Default color to use when rendering points
    static let defaultPointColor: UIColor = .black
    /// Default shape type to use when rendering points
    static let defaultPointShapeType: DPShapeType = .circle

    // MARK: - Animation properties
    
    /// The duration (in seconds) to use when animating dots (default = `0.2`).
    @IBInspectable
    open var animationDuration: Double = 0.2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The animation function to use when animating dots (default = `linear`).
    @IBInspectable
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'animationTimingFunction' instead.")
    open var animationTimingFunctionName: String {
        get { animationTimingFunction.rawValue }
        set { animationTimingFunction = CAMediaTimingFunctionName(rawValue: newValue) }
    }
    
    /// The animation function to use when animating dots (default = `.linear`).
    open var animationTimingFunction: CAMediaTimingFunctionName = .linear {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// True to enable animations (default = `true`).
    @IBInspectable
    open var animationsEnabled: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Interaction configuration properties
    
    /// Whether or not to enable touch events (default = `true`).
    @IBInspectable
    open var touchEnabled: Bool = true {
        didSet {
            trackingView.isEnabled = touchEnabled
        }
    }
    
    // MARK: - X-axis properties

    /// The number of markers on X-axis (default = `6`).
    @IBInspectable
    open var xAxisMarkersCount: Int = 6 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The spacing between the marker label and the bottom border (default = `8`).
    @IBInspectable
    open var xAxisMarkersSpacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Public weak properties
    
    /// Reference to the chart datasource.
    open weak var datasource: (any DPScatterChartViewDataSource)? {
        didSet {
            setNeedsLayout()
        }
    }
    
//    /// Reference to the chart delegate.
//    open weak var delegate: (any DPLineChartViewDelegate)? {
//        didSet {
//            setNeedsLayout()
//        }
//    }
    
    // MARK: - Subviews
    
    lazy var trackingView: DPTrackingView = {
        let trackingView = DPTrackingView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        trackingView.insets = insets
        trackingView.delegate = self
        trackingView.isEnabled = touchEnabled
        return trackingView
    }()

    // MARK: - Private properties
        
    var points: [[DPScatterPoint]] = [] // array of points in the chart
    var datasetLayers: [DPScatterDatasetLayer] = [] // array of views to display scatter datasets
    var numberOfPointsByDataset: [Int] = [] // number of points for each dataset
    var numberOfDatasets: Int = 0 // number of datasets in the chart
    var xAxisMaxValue: CGFloat = 0 // maximum value on X-axis
    var yAxisMaxValue: CGFloat = 0 // minimum value on Y-axis
    
    // MARK: - Overridden properties
    
    override var xAxisMarkersMaxHeight: CGFloat {
        guard xAxisMarkersCount > 0 else {
            return 0
        }
        var height: CGFloat = 0
        for i in 0..<xAxisMarkersCount {
            if let marker = markerOnXAxisAtIndex(i, for: valueOnXAxisAtIndex(i)) {
                height = max(height, marker.size().height)
            }
        }
        return height + xAxisMarkersSpacing
    }

    // MARK: - Lifecycle
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        initDatasetsIfNeeded()
        initLimits()
        initPoints()
        layoutDatasets()
        layoutTrackingView()
        setNeedsDisplay()
    }
    
    // MARK: - Interface
    
    /// Reload chart content by reading its datasource.
    func reloadData() {
        setNeedsLayout()
    }
    
    // MARK: - Initialization

    func commonInit() {
        isOpaque = false
        addSubview(trackingView)
    }

    func initDatasetsIfNeeded() {
        guard let datasource else {
            return
        }
        let numberOfDatasetsChanged = datasource.numberOfDatasets(self) != numberOfDatasets
        var numberOfPointsChanged = false
        for (index, numberOfPoints) in numberOfPointsByDataset.enumerated() {
            if numberOfPoints != datasource.scatterChartView(self, numberOfPointsForDatasetAtIndex: index) {
                numberOfPointsChanged = true
                break
            }
        }
        if numberOfDatasetsChanged || numberOfPointsChanged {
            initDatasets()
        }
    }
    
    func initDatasets() {
        guard let datasource else {
            return
        }
        datasetLayers.forEach { $0.removeFromSuperlayer() }
        datasetLayers.removeAll()
        numberOfPointsByDataset.removeAll()
        numberOfDatasets = datasource.numberOfDatasets(self)
        for i in 0..<numberOfDatasets {
            let numberOfPoints = datasource.scatterChartView(self, numberOfPointsForDatasetAtIndex: i)
            let datasetLayer = DPScatterDatasetLayer(numberOfPoints: numberOfPoints)
            numberOfPointsByDataset.append(numberOfPoints)
            datasetLayers.append(datasetLayer)
            layer.addSublayer(datasetLayer)
        }
    }
    
    func initLimits() {
        xAxisMaxValue = 0.0
        yAxisMaxValue = 0.0
        guard let datasource else { return }
        for i in 0..<numberOfDatasets {
            for j in 0..<numberOfPointsByDataset[i] {
                let x = datasource.scatterChartView(self, xAxisValueForDataSetAtIndex: i, forPointAtIndex: j)
                let y = datasource.scatterChartView(self, yAxisValueForDataSetAtIndex: i, forPointAtIndex: j)
                xAxisMaxValue = max(x, yAxisMaxValue)
                yAxisMaxValue = max(y, yAxisMaxValue)
            }
        }
    }

    func initPoints() {
        points.removeAll()
        guard let datasource else { return }
        let canvasHeight = canvasHeight
        let canvasWidth = canvasWidth
        for i in 0..<numberOfDatasets {
            points.insert([], at: i)
            for j in 0..<numberOfPointsByDataset[i] {
                let x = datasource.scatterChartView(self, xAxisValueForDataSetAtIndex: i, forPointAtIndex: j)
                let y = datasource.scatterChartView(self, yAxisValueForDataSetAtIndex: i, forPointAtIndex: j)
                let size = datasource.scatterChartView(self, sizeDataSetAtIndex: i, forPointAtIndex: j)
                let xAxisPosition: CGFloat = ((xAxisMaxValue - x) / xAxisMaxValue) * canvasWidth
                let yAxisPosition: CGFloat = ((yAxisMaxValue - y) / yAxisMaxValue) * canvasHeight
                points[i].insert(DPScatterPoint(
                    x: xAxisPosition,
                    y: yAxisPosition,
                    datasetIndex: i,
                    index: j,
                    size: size), at: j)
            }
        }
    }

    // MARK: - Layout

    func layoutDatasets() {
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let canvasWidth = canvasWidth
        let canvasHeight = canvasHeight
        for i in 0..<numberOfDatasets {
            guard i < datasetLayers.count else { break }
            let dataset = datasetLayers[i]
            dataset.frame = CGRect(x: canvasPosX, y: canvasPosY, width: canvasWidth, height: canvasHeight)
            dataset.animationEnabled = animationsEnabled
            dataset.animationDuration = animationDuration
            dataset.animationTimingFunction = animationTimingFunction
            dataset.scatterPointsColor = datasource?.scatterChartView(self, colorForDataSetAtIndex: i) ?? DPScatterChartView.defaultPointColor
            dataset.scatterPointsType = datasource?.scatterChartView(self, shapeForDataSetAtIndex: i) ?? DPScatterChartView.defaultPointShapeType
            dataset.scatterPoints = points[i]
            dataset.setNeedsLayout()
        }
    }
    
    func layoutTrackingView() {
        trackingView.frame = CGRect(x: canvasPosX, y: canvasPosY, width: canvasWidth, height: canvasHeight)
        trackingView.insets = insets
        trackingView.isEnabled = touchEnabled
    }
   
    // MARK: - Touch gesture
    
//    func closestIndex(at x: CGFloat) -> Int? {
//        for line in lineLayers {
//            if let point = line.closestPointAt(x: x) {
//                return point.index
//            }
//        }
//        return nil
//    }
//
//    func touchAt(_ point: CGPoint) {
//        guard touchEnabled else { return } // Disabled
//        guard point.x >= 0 else { return } // Out of bounds
//        guard let closestIndex = closestIndex(at: point.x) else { return } // Out of scope
//        layoutTouchCursorAt(point)
//        layoutShapesAt(closestIndex)
//        delegate?.lineChartView(self, didTouchAtIndex: closestIndex)
//    }
//
//    func touchEndedAt(_ point: CGPoint) {
//        guard touchEnabled else { return } // Disabled
//        guard let closestIndex = closestIndex(at: point.x) else { return } // Out of scope
//        hideTouchCursor()
//        hideShapes()
//        delegate?.lineChartView(self, didReleaseTouchFromIndex: closestIndex)
//    }
    
    // MARK: - Custom drawing
    
    public override func draw(_ rect: CGRect) {
        drawXAxisMarkers(rect)
        super.draw(rect)
    }

    func drawXAxisMarkers(_ rect: CGRect) {
        
        guard xAxisMarkersCount >= 2 else {
            return
        }
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.saveGState()
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
        
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let canvasWidth = canvasWidth
        let canvasHeight = canvasHeight
        let yAxisLineBeginPosition: CGFloat = canvasPosY + (markersLineWidth * 0.5)
        let yAxisLineEndPosition: CGFloat = yAxisLineBeginPosition + canvasHeight - (markersLineWidth * 0.5)
        let distance: CGFloat = canvasWidth / CGFloat(xAxisMarkersCount - 1)
        for i in 0..<xAxisMarkersCount {
            let xAxisPosition: CGFloat = canvasPosX + (CGFloat(i) * distance) - markersLineWidth * 0.5
            // Draw the marker line without overlapping with the LEADING and TRAILING border/marker line
            if i > 0 && i < xAxisMarkersCount - 1 {
                ctx.setAlpha(markersLineAlpha)
                ctx.setLineWidth(markersLineWidth)
                ctx.setStrokeColor(markersLineColor.cgColor)
                ctx.setLineDash(phase: 0, lengths: markersLineDashed ? markersLineDashLengths : [])
                ctx.move(to: CGPoint(x: xAxisPosition, y: yAxisLineBeginPosition))
                ctx.addLine(to: CGPoint(x: xAxisPosition, y: yAxisLineEndPosition))
                ctx.strokePath()
            }
            // Draw the marker text if we have some content
            if let marker = markerOnXAxisAtIndex(i, for: valueOnXAxisAtIndex(i)) {
                let xMin: CGFloat = 0.0
                let xMax: CGFloat = bounds.width - marker.size().width
                let xAxisLabelPosition: CGFloat = (xAxisPosition - (marker.size().width * 0.5)).clamped(to: xMin...xMax)
                let yAxisLabelPosition: CGFloat = canvasPosY + canvasHeight + xAxisMarkersSpacing
                ctx.setAlpha(1.0)
                marker.draw(at: CGPoint(x: xAxisLabelPosition, y: yAxisLabelPosition))
            }
        }
        
        ctx.restoreGState()
        
    }

    // MARK: - Misc
    
    func markerOnXAxisAtIndex(_ index: Int, for value: CGFloat) -> NSAttributedString? {
        guard let string = datasource?.scatterChartView(self, labelForMarkerOnXAxisAtIndex: index, for: value) else {
            return nil
        }
        return markerFor(string)
    }
    
    func valueOnXAxisAtIndex(_ index: Int) -> CGFloat {
        return (xAxisMaxValue / CGFloat(xAxisMarkersCount)) * CGFloat(index)
    }
    
    // MARK: - Overrides
    
    override func markerOnYAxisAtIndex(_ index: Int, for value: CGFloat) -> NSAttributedString? {
        guard let string = datasource?.scatterChartView(self, labelForMarkerOnYAxisAtIndex: index, for: value) else {
            return nil
        }
        return markerFor(string)
    }
    
    override func valueOnYAxisAtIndex(_ index: Int) -> CGFloat {
        return (yAxisMaxValue / CGFloat(yAxisMarkersCount)) * CGFloat(index)
    }
    
    // MARK: - Storyboard
    
    #if TARGET_INTERFACE_BUILDER
    let ibDataSource = DPScatterChartViewIBDataSource()
    
    // swiftlint:disable:next overridden_super_call
    public override func prepareForInterfaceBuilder() {
        datasource = ibDataSource
    }
    #endif

}

// MARK: - DPTrackingViewDelegate

extension DPScatterChartView: DPTrackingViewDelegate {
    
    func trackingView(_ trackingView: DPTrackingView, touchDownAt point: CGPoint) {
//        touchAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, touchMovedTo point: CGPoint) {
//        touchAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, touchUpAt point: CGPoint) {
//        touchEndedAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, touchCanceledAt point: CGPoint) {
//        touchEndedAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, tapSingleAt point: CGPoint) {
//        touchEndedAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, tapDoubleAt point: CGPoint) {
//        touchEndedAt(point)
    }
    
}
