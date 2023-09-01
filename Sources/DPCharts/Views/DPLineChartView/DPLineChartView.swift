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

/// A line chart is a graphical representation of data that uses lines to connect
/// data points, typically showing the relationship or trend between two or more
/// variables over a specific period.
@IBDesignable
open class DPLineChartView: DPCanvasView {
    
    // MARK: - Static properties
    
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
    
    // MARK: - Point properties
    
    /// True to hide the display of points by default and show them only upon touch events, false to display them always (default = `true`).
    @IBInspectable
    open var pointsHidden: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The size of the shape displayed on every point in the chart (default = `8`).
    @IBInspectable
    open var pointSize: CGFloat = 8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The name type of the shape to render on points in the chart (default = `circle`).
    @IBInspectable
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'touchShapeType' instead.")
    open var pointShapeTypeName: String {
        get { pointShapeType.rawValue }
        set { pointShapeType = DPShapeType(rawValue: newValue) ?? .circle }
    }
    
    /// The type of the shape to render on points in the chart (default = `.circle`).
    open var pointShapeType: DPShapeType = .circle {
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
    var pointLayers: [[DPShapeLayer]] = [] // array of shapes to display chart points
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
    
    override var xAxisLabelsMaxHeight: CGFloat {
        guard xAxisMarkersCount > 0 else {
            return 0
        }
        var height: CGFloat = 0
        for i in 0..<xAxisMarkersCount {
            if let label = xAxisLabelAtIndex(i) {
                height = max(height, label.size().height)
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
        initShapesIfNeeded()
        initLimits()
        initPoints()
        layoutLines()
        layoutPoints()
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
        backgroundColor = .clear
        isOpaque = true
        addSubview(touchCursor)
        addSubview(trackingView)
    }

    func initShapesIfNeeded() {
        guard let datasource else {
            return
        }
        let numberOfPointsChanged = datasource.numberOfPoints(self) != numberOfPoints
        let numberOfLinesChanged = datasource.numberOfLines(self) != numberOfLines
        if numberOfPointsChanged || numberOfLinesChanged {
            initShapes()
        }
    }
    
    func initShapes() {
        guard let datasource else {
            return
        }
        lineLayers.forEach { $0.removeFromSuperlayer() }
        lineLayers.removeAll()
        pointLayers.flatMap { $0 }.forEach { $0.removeFromSuperlayer() }
        pointLayers.removeAll()
        numberOfLines = datasource.numberOfLines(self)
        numberOfPoints = datasource.numberOfPoints(self)
        for i in 0..<numberOfLines {
            let lineLayer = DPLineLayer()
            pointLayers.insert([], at: i)
            lineLayers.insert(lineLayer, at: i)
            layer.addSublayer(lineLayer)
            for j in 0..<numberOfPoints {
                let pointLayer = DPShapeLayer()
                pointLayers[i].insert(pointLayer, at: j)
                layer.addSublayer(pointLayer)
            }
        }
    }
    
    func initLimits() {
        yAxisMaxValue = DPLineChartView.defaultYAxisMaxValue
        yAxisMinValue = DPLineChartView.defaultYAxisMinValue
        guard let datasource else { return }
        for i in 0..<numberOfLines {
            for j in 0..<numberOfPoints {
                let v = datasource.lineChartView(self, valueForLineAtIndex: i, forPointAtIndex: j)
                yAxisMaxValue = max(v, yAxisMaxValue)
                yAxisMinValue = min(v, yAxisMinValue)
            }
        }
    }

    func initPoints() {
        points.removeAll()
        guard let datasource else { return }
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
    
    func layoutPoints() {
        guard let datasource else {
            return
        }
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        for i in 0..<numberOfLines {
            for j in 0..<numberOfPoints {
                let shape = pointLayers[i][j]
                let point = points[i][j]
                let oldPosition = shape.position
                let oldBounds = shape.bounds
                let newBounds = CGRect(origin: .zero, size: CGSize(width: pointSize, height: pointSize))
                let newPosition = CGPoint(x: canvasPosX + point.x, y: canvasPosY + point.y)
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                shape.bounds = newBounds
                shape.position = newPosition
                shape.type = pointShapeType
                shape.color = datasource.lineChartView(self, colorForLineAtIndex: i)
                shape.isHidden = pointsHidden
                shape.setNeedsLayout()
                CATransaction.commit()
                if animationsEnabled {
                    let positionAnim: CABasicAnimation = CABasicAnimation(keyPath: "position")
                    positionAnim.fromValue = oldPosition
                    positionAnim.toValue = newPosition
                    let boundsAnim: CABasicAnimation = CABasicAnimation(keyPath: "bounds")
                    boundsAnim.fromValue = oldBounds
                    boundsAnim.toValue = newBounds
                    let animations: CAAnimationGroup = CAAnimationGroup()
                    animations.animations = [positionAnim, boundsAnim]
                    animations.duration = animationDuration
                    animations.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
                    animations.isRemovedOnCompletion = true
                    shape.add(positionAnim, forKey: "frame")
                }
            }
        }
    }
    
    func layoutTrackingView() {
        trackingView.frame = CGRect(x: canvasPosX, y: canvasPosY, width: canvasWidth, height: canvasHeight)
        trackingView.insets = insets
        trackingView.isEnabled = touchEnabled
    }
    
    func hideTouchCursor() {
        touchCursor.isHidden = true
    }
    
    func hideOrShowAllPoints() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for i in 0..<numberOfLines {
            for j in 0..<numberOfPoints {
                let shape = pointLayers[i][j]
                shape.isHidden = pointsHidden
                shape.setNeedsLayout()
            }
        }
        CATransaction.commit()
    }
    
    func showTouchCursorAt(_ point: CGPoint) {
        guard numberOfPoints > 0 else {
            return
        }
        let width: CGFloat = canvasWidth / CGFloat(numberOfPoints)
        let x = point.x + canvasPosX - (width * 0.5)
        touchCursor.frame = CGRect(x: x, y: canvasPosY, width: width, height: canvasHeight)
        touchCursor.alpha = 0.2
        touchCursor.isHidden = false
    }
    
    func showPointAt(_ closestIndex: Int) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for i in 0..<numberOfLines {
            for j in 0..<numberOfPoints {
                let shape = pointLayers[i][j]
                shape.isHidden = j != closestIndex
                shape.setNeedsLayout()
            }
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
        showTouchCursorAt(point)
        showPointAt(closestIndex)
        delegate?.lineChartView(self, didTouchAtIndex: closestIndex)
    }
    
    func touchEndedAt(_ point: CGPoint) {
        guard touchEnabled else { return } // Disabled
        guard let closestIndex = closestIndex(at: point.x) else { return } // Out of scope
        hideTouchCursor()
        hideOrShowAllPoints()
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
            if let label = xAxisLabelAtIndex(i) {
                let xMin: CGFloat = canvasPosX
                let xMax: CGFloat = canvasPosX + canvasWidth - label.size().width
                let xAxisLabelPosition: CGFloat = (xAxisPosition - (label.size().width * 0.5)).clamped(to: xMin...xMax)
                let yAxisLabelPosition: CGFloat = canvasPosY + canvasHeight + xAxisMarkersSpacing
                ctx.setAlpha(1.0)
                label.draw(at: CGPoint(x: xAxisLabelPosition, y: yAxisLabelPosition))
            }
        }
        
        ctx.restoreGState()
        
    }

    // MARK: - Misc
    
    func xAxisLabelAtIndex(_ index: Int) -> NSAttributedString? {
        guard let string = datasource?.lineChartView(self, xAxisLabelAtIndex: index) else {
            return nil
        }
        return axisLabel(string)
    }
    
    // MARK: - Overrides
    
    override func yAxisLabelAtIndex(_ index: Int, for value: CGFloat) -> NSAttributedString? {
        guard let string = datasource?.lineChartView(self, yAxisLabelAtIndex: index, for: value) else {
            return nil
        }
        return axisLabel(string)
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

// MARK: - Deprecations

extension DPLineChartView {
    
    /// The size of the shape displayed on every point when the chart is touched (default = `8`).
    @available(*, deprecated, renamed: "pointSize")
    public var touchShapeSize: CGFloat {
        get { pointSize }
        set { pointSize = newValue }
    }
    
    /// The name type of the shape to render on points when the chart is touched (default = `circle`).
    @IBInspectable
    @available(*, deprecated, renamed: "pointShapeTypeName")
    public var touchShapeTypeName: String {
        get { pointShapeType.rawValue }
        set { pointShapeType = DPShapeType(rawValue: newValue) ?? .circle }
    }
    
    /// The type of the shape to render on points when the chart is touched (default = `.circle`).
    @available(*, deprecated, renamed: "pointShapeType")
    public var touchShapeType: DPShapeType {
        get { pointShapeType }
        set { pointShapeType = newValue}
    }
    
}
