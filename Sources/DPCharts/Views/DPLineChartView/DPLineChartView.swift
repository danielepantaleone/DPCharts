//
//  DPLineChartView.swift
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

// MARK: - DPLineChartChartView

/// A line chart that draws according with a provided datasource.
@IBDesignable
open class DPLineChartView: DPCanvasView {
    
    // MARK: - Static properties
    
    /// Y-axis shift factor not to let bezier lines touch the top of the chart
    static let defaultBezierShiftFactor: CGFloat = 0.20
    /// Y-axis shift factor not to let lines touch the top of the chart
    static let defaultShiftFactor: CGFloat = 0.10
    /// Default color for every line
    static let defaultLineColor: UIColor = .black
    /// Default width for every line
    static let defaultLineWidth: CGFloat = 1.0
    /// Default maximum rendered point on Y-axis
    static let defaultYAxisMaxValue: CGFloat = -(.greatestFiniteMagnitude)
    /// Default minimum rendered point on X-axis
    static let defaultYAxisMinValue: CGFloat = +(.greatestFiniteMagnitude)

    // MARK: - Animation properties
    
    /// The duration (in seconds) to use when animating lines (default = `0.2`).
    @IBInspectable
    open var animationDuration: Double = 0.2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The animation function to use when animating lines (default = `linear`).
    @IBInspectable
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'animationTimingFunction' instead.")
    open var animationTimingFunctionName: String {
        get { animationTimingFunction.rawValue }
        set { animationTimingFunction = CAMediaTimingFunctionName(rawValue: newValue) }
    }
    
    /// The animation function to use when animating lines (default = `.linear`).
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
    
    // MARK: - Area properties
    
    /// The alpha component of the area below each line (default = `0.3`).
    @IBInspectable
    open var areaAlpha: CGFloat = 0.3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Wether to enable the drawing of the area below every line (default = `false`).
    @IBInspectable
    open var areaEnabled: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    /// Wether to enable the rendering of the area using a gradient color, `false` to display a solid color (default = `false`).
    @IBInspectable
    open var areaGradientEnabled: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Line configuration properties
    
    /// Wether to enable to use bezier curves when drawing lines (default = `false`).
    @IBInspectable
    open var bezierCurveEnabled: Bool = false {
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

    /// The color of the touch cursor (default = `.lightGray`).
    @IBInspectable
    open var touchCursorColor: UIColor = .lightGray {
        didSet {
            touchCursor.backgroundColor = touchCursorColor
        }
    }
    
    /// The size of the shape displayed on every point when the chart is touched (default = `8`).
    @IBInspectable
    open var touchShapeSize: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The name type of the shape to render on points when the chart is touched (default = `circle`).
    @IBInspectable
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'touchShapeType' instead.")
    open var touchShapeTypeName: String {
        get { touchShapeType.rawValue }
        set { touchShapeType = DPShapeType(rawValue: newValue) ?? .circle }
    }
    
    /// The type of the shape to render on points when the chart is touched (default = `.circle`).
    open var touchShapeType: DPShapeType = .circle {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Origin display properties
    
    /// The color of the origin horizontal line (default = `.clear`).
    @IBInspectable
    open var originLineColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The width of the origin horizontal line (default = `1.0`).
    @IBInspectable
    open var originLineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
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
    open weak var datasource: (any DPLineChartViewDataSource)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Reference to the chart delegate.
    open weak var delegate: (any DPLineChartViewDelegate)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Subviews
    
    lazy var touchCursor: UIView = {
        let touchCursor = UIView()
        touchCursor.backgroundColor = touchCursorColor
        touchCursor.isHidden = true
        return touchCursor
    }()
    lazy var trackingView: DPTrackingView = {
        let trackingView = DPTrackingView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        trackingView.insets = insets
        trackingView.delegate = self
        trackingView.isEnabled = touchEnabled
        return trackingView
    }()

    // MARK: - Private properties
        
    var lineLayers: [DPLineLayer] = [] // array of line shapes
    var shapeLayers: [DPShapeLayer] = [] // array of views to be displayed selected points
    var points: [[DPLinePoint]] = [] // array of points in the chart
    var numberOfPoints: Int = 0 // number of points on the X-axis
    var numberOfLines: Int = 0 // number of lines in the chart
    var yAxisMinValue: CGFloat = DPLineChartView.defaultYAxisMinValue // maximum value on Y-axis
    var yAxisMaxValue: CGFloat = DPLineChartView.defaultYAxisMaxValue // minimum value on Y-axis
    var yAxisMaxSpan: CGFloat { // absolute value of delta between maximum and minimum value on Y-axis
        guard yAxisMinValue != DPLineChartView.defaultYAxisMinValue &&
              yAxisMaxValue != DPLineChartView.defaultYAxisMaxValue else {
            return 0
        }
        return abs(yAxisMinValue) + abs(yAxisMaxValue)
    }
    var yAxisOriginOffset: CGFloat {
        if yAxisMinValue >= 0 {
            return canvasHeight
        } else if yAxisMaxValue <= 0 {
            return 0
        } else {
            return canvasHeight * (abs(yAxisMaxValue) / yAxisMaxSpan)
        }
    }
    var yAxisOriginIndex: Int {
        let canvasHeight: CGFloat = canvasHeight
        let yAxisOriginPosition = canvasHeight * (abs(yAxisMinValue) / yAxisMaxSpan)
        let distance: CGFloat = canvasHeight / CGFloat(yAxisMarkersCount)
        let yAxisLineShift: CGFloat = yAxisOriginPosition.truncatingRemainder(dividingBy: distance)
        var index: Int = 0
        for i in 0..<yAxisMarkersCount {
            if ((distance * CGFloat(i)) + yAxisLineShift) > yAxisOriginPosition {
                break
            }
            index = i
        }
        return max(index, 0)
    }
    
    // MARK: - Overridden properties
    
    override var xAxisMarkersMaxHeight: CGFloat {
        guard xAxisMarkersCount > 0 else {
            return 0
        }
        var height: CGFloat = 0
        for i in 0..<xAxisMarkersCount {
            if let marker = xAxisMarkerAtIndex(i) {
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
        initLinesIfNeeded()
        initLimits()
        initPoints()
        layoutLines()
        layoutTrackingView()
        setNeedsDisplay()
    }
    
    // MARK: - Interface
    
    /// Reload chart content by reading its datasource.
    open func reloadData() {
        setNeedsLayout()
    }
    
    // MARK: - Initialization

    func commonInit() {
        isOpaque = false
        addSubview(touchCursor)
        addSubview(trackingView)
    }

    func initLinesIfNeeded() {
        guard let datasource = datasource else {
            return
        }
        let numberOfPointsChanged = datasource.numberOfPoints(self) != numberOfPoints
        let numberOfLinesChanged = datasource.numberOfLines(self) != numberOfLines
        let numberOfLineViewsInvalidated = datasource.numberOfLines(self) != lineLayers.count
        if numberOfPointsChanged || numberOfLinesChanged || numberOfLineViewsInvalidated {
            initLines()
        }
    }
    
    func initLines() {
        guard let datasource = datasource else {
            return
        }
        lineLayers.forEach { $0.removeFromSuperlayer() }
        lineLayers.removeAll()
        shapeLayers.forEach { $0.removeFromSuperlayer() }
        shapeLayers.removeAll()
        numberOfLines = datasource.numberOfLines(self)
        numberOfPoints = datasource.numberOfPoints(self)
        for _ in 0..<numberOfLines {
            let lineLayer = DPLineLayer()
            let shapeLayer = DPShapeLayer()
            lineLayers.append(lineLayer)
            shapeLayers.append(shapeLayer)
            layer.addSublayer(lineLayer)
            layer.addSublayer(shapeLayer)
        }
    }
    
    func initLimits() {
        yAxisMaxValue = DPLineChartView.defaultYAxisMaxValue
        yAxisMinValue = DPLineChartView.defaultYAxisMinValue
        guard let datasource = datasource else { return }
        for i in 0..<numberOfLines {
            for j in 0..<numberOfPoints {
                let v = datasource.lineChartView(self, valueForLineAtIndex: i, forPointAtIndex: j)
                yAxisMaxValue = max(v, yAxisMaxValue)
                yAxisMinValue = min(v, yAxisMinValue)
            }
        }
        // Adjust min value (if needed) so that the chart is not cut on bottom and values are better distributed in the canvas
        let shiftFactor = bezierCurveEnabled ? DPLineChartView.defaultBezierShiftFactor : DPLineChartView.defaultShiftFactor
        let maxYAxisSpan = yAxisMaxSpan
        if yAxisMinValue >= 0 {
            yAxisMinValue = 0
        } else {
            yAxisMinValue -= (shiftFactor * maxYAxisSpan)
        }
        if yAxisMaxValue <= 0 {
            yAxisMaxValue = 0
        } else {
            yAxisMaxValue += (shiftFactor * maxYAxisSpan)
        }
    }

    func initPoints() {
        points.removeAll()
        guard let datasource = datasource else { return }
        let canvasHeight = canvasHeight
        let canvasWidth = canvasWidth
        let maxYAxisSpan = yAxisMaxSpan
        for i in 0..<numberOfLines {
            points.insert([], at: i)
            for j in 0..<numberOfPoints {
                let value = datasource.lineChartView(self, valueForLineAtIndex: i, forPointAtIndex: j)
                let xAxisPosition: CGFloat = (canvasWidth / ((CGFloat(numberOfPoints)) - 1)) * CGFloat(j)
                let yAxisPosition: CGFloat = ((yAxisMaxValue - value) / maxYAxisSpan) * canvasHeight
                points[i].insert(DPLinePoint(x: xAxisPosition, y: yAxisPosition, lineIndex: i, index: j), at: j)
            }
        }
    }

    // MARK: - Layout

    func layoutLines() {
        guard numberOfPoints >= 2 else {
            return
        }
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let canvasWidth = canvasWidth
        let canvasHeight = canvasHeight
        let canvasOriginOffsetY = yAxisOriginOffset
        for i in 0..<numberOfLines {
            guard i < lineLayers.count else { break }
            let line = lineLayers[i]
            line.frame = CGRect(x: canvasPosX, y: canvasPosY, width: canvasWidth, height: canvasHeight)
            line.animationEnabled = animationsEnabled
            line.animationDuration = animationDuration
            line.animationTimingFunction = animationTimingFunction
            line.areaAlpha = areaAlpha
            line.areaEnabled = areaEnabled
            line.areaGradientEnabled = areaGradientEnabled
            line.lineBezierCurveEnabled = bezierCurveEnabled
            line.lineColor = datasource?.lineChartView(self, colorForLineAtIndex: i) ?? DPLineChartView.defaultLineColor
            line.lineWidth = datasource?.lineChartView(self, widthForLineAtIndex: i) ?? DPLineChartView.defaultLineWidth
            line.linePoints = points[i]
            line.canvasOriginOffsetY = canvasOriginOffsetY
            line.setNeedsLayout()
        }
    }
    
    func layoutTrackingView() {
        trackingView.frame = CGRect(x: canvasPosX, y: canvasPosY, width: canvasWidth, height: canvasHeight)
        trackingView.insets = insets
        trackingView.isEnabled = touchEnabled
    }
    
    func layoutTouchCursorAt(_ point: CGPoint) {
        guard numberOfPoints > 0 else {
            return
        }
        let width: CGFloat = canvasWidth / CGFloat(numberOfPoints)
        let x = point.x + canvasPosX - (width * 0.5)
        touchCursor.frame = CGRect(x: x, y: canvasPosY, width: width, height: canvasHeight)
        touchCursor.alpha = 0.2
        touchCursor.isHidden = false
    }
    
    func layoutShapesAt(_ closestIndex: Int) {
        guard let datasource = datasource else {
            return
        }
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for i in 0..<numberOfLines {
            guard i < shapeLayers.count, i < points.count else { break }
            guard closestIndex >= 0 && closestIndex < points[i].count else { break}
            let shape = shapeLayers[i]
            let point = points[i][closestIndex]
            let x = canvasPosX + point.x - (touchShapeSize * 0.5)
            let y = canvasPosY + point.y - (touchShapeSize * 0.5)
            shape.frame = CGRect(x: x, y: y, width: touchShapeSize, height: touchShapeSize)
            shape.type = .circle
            shape.color = datasource.lineChartView(self, colorForLineAtIndex: i)
            shape.isHidden = false
            shape.setNeedsLayout()
        }
        CATransaction.commit()
    }
    
    func hideTouchCursor() {
        touchCursor.isHidden = true
    }
    
    func hideShapes() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shapeLayers.forEach {
            $0.isHidden = true
        }
        CATransaction.commit()
    }
    
    // MARK: - Touch gesture
    
    func closestIndex(at x: CGFloat) -> Int? {
        for line in lineLayers {
            if let point = line.closestPointAt(x: x) {
                return point.index
            }
        }
        return nil
    }
    
    func touchAt(_ point: CGPoint) {
        guard touchEnabled else { return } // Disabled
        guard point.x >= 0 else { return } // Out of bounds
        guard let closestIndex = closestIndex(at: point.x) else { return } // Out of scope
        layoutTouchCursorAt(point)
        layoutShapesAt(closestIndex)
        delegate?.lineChartView(self, didTouchAtIndex: closestIndex)
    }
    
    func touchEndedAt(_ point: CGPoint) {
        guard touchEnabled else { return } // Disabled
        guard let closestIndex = closestIndex(at: point.x) else { return } // Out of scope
        hideTouchCursor()
        hideShapes()
        delegate?.lineChartView(self, didReleaseTouchFromIndex: closestIndex)
    }
    
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
            if let marker = xAxisMarkerAtIndex(i) {
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
    
    func xAxisMarkerAtIndex(_ index: Int) -> NSAttributedString? {
        guard let string = datasource?.lineChartView(self, labelForMarkerOnXAxisAtIndex: index) else {
            return nil
        }
        return marker(string)
    }
    
    // MARK: - Overrides
    
    override func yAxisMarkerAtIndex(_ index: Int, for value: CGFloat) -> NSAttributedString? {
        guard let string = datasource?.lineChartView(self, labelForMarkerOnYAxisAtIndex: index, for: value) else {
            return nil
        }
        return marker(string)
    }
    
    override func yAxisValueAtIndex(_ index: Int) -> CGFloat {
        let step: CGFloat = yAxisMaxSpan / CGFloat(yAxisMarkersCount)
        let distance: Int = index - yAxisOriginIndex
        return step * CGFloat(distance)
    }
    
    // MARK: - Storyboard
    
    #if TARGET_INTERFACE_BUILDER
    let ibDataSource = DPLineChartViewIBDataSource()
    
    // swiftlint:disable:next overridden_super_call
    public override func prepareForInterfaceBuilder() {
        datasource = ibDataSource
    }
    #endif

}

// MARK: - DPTrackingViewDelegate

extension DPLineChartView: DPTrackingViewDelegate {
    
    func trackingView(_ trackingView: DPTrackingView, touchDownAt point: CGPoint) {
        touchAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, touchMovedTo point: CGPoint) {
        touchAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, touchUpAt point: CGPoint) {
        touchEndedAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, touchCanceledAt point: CGPoint) {
        touchEndedAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, tapSingleAt point: CGPoint) {
        touchEndedAt(point)
    }
    
    func trackingView(_ trackingView: DPTrackingView, tapDoubleAt point: CGPoint) {
        touchEndedAt(point)
    }
    
}
