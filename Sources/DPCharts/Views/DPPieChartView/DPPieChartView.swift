//
//  DPPieChartView.swift
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

/// A pie chart is a circular graphical representation that visually displays data
/// as slices of a pie. Each slice in the chart represents a different category or
/// variable, and the size of each slice corresponds to the proportion or percentage
/// of the whole it represents.
@IBDesignable
open class DPPieChartView: UIView {
    
    // MARK: - Spacing properties
    
    /// The bottom spacing (default = `0`).
    @IBInspectable
    open var bottomSpacing: CGFloat {
        get { insets.bottom }
        set { insets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: newValue, right: insets.right) }
    }
    
    /// The left spacing (default = `0`).
    @IBInspectable
    open var leftSpacing: CGFloat {
        get { insets.left }
        set { insets = UIEdgeInsets(top: insets.top, left: newValue, bottom: insets.bottom, right: insets.right) }
    }
    
    /// The right spacing (default = `0`).
    @IBInspectable
    open var rightSpacing: CGFloat {
        get { insets.right }
        set { insets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: newValue) }
    }
    
    /// The top spacing (default = `0`).
    @IBInspectable
    open var topSpacing: CGFloat {
        get { insets.top }
        set { insets = UIEdgeInsets(top: newValue, left: insets.left, bottom: insets.bottom, right: insets.right) }
    }
    
    /// The spacing between slices (default = `2.0`)
    @IBInspectable
    open var slicesSpacing: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The internal insets of the chart.
    open var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Labels properties
    
    /// Whether to enable or not labels in the chart (default = `true`).
    @IBInspectable
    open var labelsEnabled: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The color of the labels in the chart (default = `.lightGray`).
    @IBInspectable
    open var labelsColor: UIColor = .lightGray {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The spacing between the lebales and the slices (default = `8.0`)
    @IBInspectable
    open var labelsSpacing: CGFloat = 8.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The font used to render labels near slices (default = `.systemFont(ofSize: 12)`)
    open var labelsFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Donut properties
    
    /// True to render the chart as a Donut (default = `false`).
    @IBInspectable
    open var donutEnabled: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The width of the chart when the chart is rendered as a Donut (default = `32`).
    @IBInspectable
    open var donutWidth: CGFloat = 32.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The title of the chart to be rendered inside the Donut (default = `nil`).
    @IBInspectable
    open var donutTitle: String? {
        get { donutTitleLabel.text }
        set { donutTitleLabel.text = newValue }
    }
    
    /// The color of the title of the Donut (default = `.black`).
    @IBInspectable
    open var donutTitleColor: UIColor? {
        get { donutTitleLabel.textColor }
        set { donutTitleLabel.textColor = newValue }
    }
    
    /// The font of the title of the Donut (default = `.systemFont(ofSize: 18, weight: .semibold)`).
    open var donutTitleFont: UIFont? {
        get { donutTitleLabel.font }
        set { donutTitleLabel.font = newValue }
    }
    
    /// The subtitle of the chart to be rendered inside the Donut  (default = `nil`).
    @IBInspectable
    open var donutSubtitle: String? {
        get { donutSubtitleLabel.text }
        set { donutSubtitleLabel.text = newValue }
    }
    
    /// The color of the subtitle of the Donut (default = `.gray`).
    @IBInspectable
    open var donutSubtitleColor: UIColor? {
        get { donutSubtitleLabel.textColor }
        set { donutSubtitleLabel.textColor = newValue }
    }
    
    /// The font of the subtitle of the Donut (default = `.systemFont(ofSize: 13, weight: .regular)`).
    open var donutSubtitleFont: UIFont? {
        get { donutSubtitleLabel.font }
        set { donutSubtitleLabel.font = newValue }
    }
    
    /// The spacing between the title and subtitle of the Donut (default = `4.0`).
    @IBInspectable
    open var donutVerticalSpacing: CGFloat {
        get { stackView.spacing}
        set { stackView.spacing = newValue }
    }
    
    // MARK: - Rotation properties
    
    /// The rotation shift angle for the initial slice in degrees (default = `-90`)
    @IBInspectable
    open var rotateBy: CGFloat = -90 {
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
    
    /// Alpha channel predominance for selected bars (default = `0.6`).
    @IBInspectable
    open var touchAlphaPredominance: CGFloat = 0.6 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Public weak properties
    
    /// Reference to the chart datasource.
    open weak var datasource: (any DPPieChartViewDataSource)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Reference to the view delegate.
    open weak var delegate: (any DPPieChartViewDelegate)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Subviews
    
    lazy public var donutTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy public var donutSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    lazy var stackViewContainer: UIView = {
        let stackViewContainer = UIView()
        stackViewContainer.addSubview(stackView)
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        return stackViewContainer
    }()
    lazy var trackingView: DPTrackingView = {
        let trackingView = DPTrackingView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        trackingView.insets = insets
        trackingView.delegate = self
        trackingView.isEnabled = touchEnabled
        return trackingView
    }()
    
    // MARK: - Private properties
        
    var shapeLayers: [CAShapeLayer] = []
    var shapeMaskLayers: [CALayer] = []
    var chartLabels: [CATextLayer] = []
    var chartLabelsShift: [CGPoint] = []
    var chartRatios: [CGFloat] = []
    var chartValues: [CGFloat] = []
    var numberOfSlices: Int = 0
    var selectedIndex: Int? {
        didSet {
            setupOpacity()
        }
    }
    
    // MARK: - Computed properties
    
    var chartHeight: CGFloat { frame.height - insets.top - insets.bottom }
    var chartWidth: CGFloat { frame.width - insets.left + insets.right }
    var arcCenter: CGPoint { CGPoint(x: (chartWidth * 0.5) + insets.left, y: (chartHeight * 0.5) + insets.top) }
    var arcDonutInnerRadius: CGFloat { arcRadius - donutWidth }
    var arcRadius: CGFloat {
        var size = min(chartWidth * 0.5, chartHeight * 0.5)
        if labelsEnabled {
            var reduction: CGFloat = 0
            let rotation = rotateBy.fromDegToRad
            var from: CGFloat = 0.0
            for i in 0..<chartRatios.count {
                let angle = from + (chartRatios[i] / 2) + rotation
                let xReduction = abs(1.0 - ((chartLabels[i].bounds.width * 0.33) * cos(angle)))
                let yReduction = abs(1.0 - ((chartLabels[i].bounds.height * 0.33) * sin(angle)))
                reduction = max(reduction, max(xReduction, yReduction))
                from += chartRatios[i]
            }
            size -= reduction
            size -= labelsSpacing
        }
        return size
    }
    var canvasHeight: CGFloat { frame.height - insets.top - insets.bottom }
    var canvasWidth: CGFloat { frame.width - insets.left - insets.right }
    var canvasPosX: CGFloat { insets.left }
    var canvasPosY: CGFloat { insets.top }
    
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
        layoutInit()
        layoutMaskLayers()
        layoutLabels()
        layoutShapes()
        layoutDonutContent()
        layoutTrackingView()
    }

    // MARK: - Interface
    
    /// Reload chart content by reading its datasource.
    open func reloadData() {
        setNeedsLayout()
    }
    
    // MARK: - Initialization

    func commonInit() {
        isOpaque = false
        stackView.addArrangedSubview(donutTitleLabel)
        stackView.addArrangedSubview(donutSubtitleLabel)
        addSubview(stackViewContainer)
        addSubview(trackingView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: stackViewContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: stackViewContainer.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: stackViewContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: stackViewContainer.bottomAnchor)
        ].map {
            $0.priority = UILayoutPriority(999)
            return $0
        })
    }
    
    func initShapesIfNeeded() {
        guard let datasource else {
            return
        }
        let numberOfSlicesChanged = datasource.numberOfSlices(self) != numberOfSlices
        let numberOfSliceViewsInvalidated = datasource.numberOfSlices(self) != shapeLayers.count
        if numberOfSlicesChanged || numberOfSliceViewsInvalidated {
            initShapes()
        }
    }
    
    func initShapes() {
        guard let datasource else {
            return
        }
        numberOfSlices = datasource.numberOfSlices(self)
        shapeMaskLayers.forEach { $0.removeFromSuperlayer() }
        shapeMaskLayers.removeAll()
        shapeLayers.forEach { $0.removeFromSuperlayer() }
        shapeLayers.removeAll()
        for _ in 0..<numberOfSlices {
            let shapeLayer = CAShapeLayer()
            let shapeMaskLayer = CAShapeLayer()
            shapeLayers.append(shapeLayer)
            shapeMaskLayers.append(shapeMaskLayer)
            layer.addSublayer(shapeLayer)
        }
        chartLabels.forEach { $0.removeFromSuperlayer() }
        chartLabels.removeAll()
        for _ in 0..<numberOfSlices {
            let sliceLabel = CATextLayer()
            layer.addSublayer(sliceLabel)
            chartLabels.append(sliceLabel)
        }
    }

    // MARK: - Layout
    
    func layoutInit() {
        guard let datasource else {
            return
        }
        chartLabelsShift.removeAll()
        chartRatios.removeAll()
        chartValues.removeAll()
        for i in 0..<numberOfSlices {
            chartValues.append(datasource.pieChartView(self, valueForSliceAtIndex: i))
        }
        let total: CGFloat = chartValues.sum()
        for i in 0..<chartValues.count {
            if total > 0 {
                chartRatios.append((chartValues[i] / total) * (2 * .pi))
            } else {
                chartRatios.append(0)
            }
        }
        var from: CGFloat = 0.0
        for i in 0..<numberOfSlices {
            let angle = from + (chartRatios[i] * 0.5) + rotateBy.fromDegToRad
            chartLabelsShift.append(CGPoint(
                x: (chartLabels[i].bounds.midX) * cos(angle),
                y: (chartLabels[i].bounds.midY) * sin(angle)))
            from += chartRatios[i]
        }
    }
    
    func layoutDonutContent() {
        guard donutEnabled else {
            stackViewContainer.isHidden = true
            return
        }
        let x: CGFloat = (stackViewContainer.bounds.width - leftSpacing) * 0.5
        let y: CGFloat = (stackViewContainer.bounds.height - topSpacing) * 0.5
        let maskCenter: CGPoint = CGPoint(x: x, y: y)
        let maskRadius: CGFloat = arcDonutInnerRadius - slicesSpacing
        let mask: CAShapeLayer = CAShapeLayer()
        mask.fillColor = UIColor.black.cgColor
        mask.path = UIBezierPath(
            arcCenter: maskCenter,
            radius: maskRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true).cgPath
        stackViewContainer.center = arcCenter
        stackViewContainer.layer.mask = mask
        stackViewContainer.isHidden = false
    }
    
    func layoutLabels() {
        guard let datasource else {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let rotation = rotateBy.fromDegToRad
        let total: CGFloat = chartValues.sum()
        var from: CGFloat = 0.0
        for i in 0..<numberOfSlices {
            let label = chartLabels[i]
            let angle = from + (chartRatios[i] / 2) + rotation
            let fromX = ((arcRadius + labelsSpacing) * cos(angle)) + chartLabelsShift[i].x
            let fromY = ((arcRadius + labelsSpacing) * sin(angle)) + chartLabelsShift[i].y
            let string = datasource.pieChartView(self, labelForSliceAtIndex: i, forValue: chartValues[i], withTotal: total) ?? ""
            let attributedString = NSAttributedString(string: string, attributes: [
                .foregroundColor: labelsColor,
                .font: labelsFont
            ])
            label.contentsScale = UIScreen.main.scale
            label.alignmentMode = .center
            label.string = attributedString
            label.bounds = CGRect(origin: .zero, size: attributedString.size())
            label.position = CGPoint(x: fromX + arcCenter.x, y: fromY + arcCenter.y)
            from += chartRatios[i]
        }
        CATransaction.commit()
    }
    
    func layoutMaskLayers() {
        let arcRadius = arcRadius
        let arcCenter = arcCenter
        for i in 0..<numberOfSlices {
            shapeMaskLayers[i].frame = bounds
            shapeMaskLayers[i].backgroundColor = UIColor.black.cgColor
            let sublayer: CAShapeLayer = CAShapeLayer()
            let path: UIBezierPath = UIBezierPath()
            // SLICE SPACING
            if slicesSpacing > 0 {
                var from: CGFloat = 0.0
                for j in 0..<chartRatios.count {
                    let subpath = UIBezierPath(rect: CGRect(
                        x: arcCenter.x - slicesSpacing * 0.5 ,
                        y: arcCenter.y - arcRadius,
                        width: slicesSpacing,
                        height: arcRadius))
                    subpath.apply(CGAffineTransform(translationX: -arcCenter.x, y: -arcCenter.y))
                    subpath.apply(CGAffineTransform(rotationAngle: from))
                    subpath.apply(CGAffineTransform(translationX: arcCenter.x, y: arcCenter.y))
                    path.append(subpath)
                    from += chartRatios[j]
                }
            }
            // DONUT
            if donutEnabled {
                path.append(UIBezierPath(
                    arcCenter: arcCenter,
                    radius: arcDonutInnerRadius,
                    startAngle: 0,
                    endAngle: 2 * .pi,
                    clockwise: true))
            }
            // APPLY
            sublayer.compositingFilter = "xor"
            sublayer.path = path.cgPath
            shapeMaskLayers[i].sublayers = nil
            shapeMaskLayers[i].addSublayer(sublayer)
        }
    }

    func layoutShapes() {
        guard let datasource else {
            return
        }
        let rotation = rotateBy.fromDegToRad
        var from: CGFloat = 0.0
        for i in 0..<numberOfSlices {
            let fromX = arcRadius * cos(from + rotation)
            let fromY = arcRadius * sin(from + rotation)
            let to: CGFloat = from + chartRatios[i]
            let path: UIBezierPath = UIBezierPath()
            path.move(to: arcCenter)
            path.addLine(to: CGPoint(x: fromX + arcCenter.x, y: fromY + arcCenter.y))
            path.addArc(
                withCenter: arcCenter,
                radius: arcRadius,
                startAngle: from + rotation,
                endAngle: to + rotation,
                clockwise: true)
            path.addLine(to: arcCenter)
            path.close()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            shapeLayers[i].fillColor = datasource.pieChartView(self, colorForSliceAtIndex: i).cgColor
            shapeLayers[i].mask = shapeMaskLayers[i]
            shapeLayers[i].path = path.cgPath
            CATransaction.commit()
            from = to
        }
    }
    
    func layoutTrackingView() {
        trackingView.frame = CGRect(x: canvasPosX, y: canvasPosY, width: canvasWidth, height: canvasHeight)
        trackingView.insets = insets
        trackingView.isEnabled = touchEnabled
    }
    
    // MARK: - Misc
    
    func setupOpacity() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for i in 0..<numberOfSlices {
            let shapeLayer = shapeLayers[i]
            let chartLabel = chartLabels[i]
            if selectedIndex == nil || selectedIndex == i {
                shapeLayer.opacity = 1.0
                chartLabel.opacity = 1.0
            } else {
                shapeLayer.opacity = 1.0 - Float(touchAlphaPredominance)
                chartLabel.opacity = 1.0 - Float(touchAlphaPredominance)
            }
        }
        CATransaction.commit()
    }
    
    // MARK: - Touch gesture

    func isOnPath(point: CGPoint) -> Bool {
        let shifted = CGPoint(x: point.x + canvasPosX, y: point.y + canvasPosY)
        let xDist = shifted.x - arcCenter.x;
        let yDist = shifted.y - arcCenter.y;
        let distance = sqrt((xDist * xDist) + (yDist * yDist))
        if distance > arcRadius {
            return false
        }
        if donutEnabled && distance < arcDonutInnerRadius {
            return false
        }
        return true
    }
    
    func sliceIndex(at point: CGPoint) -> Int? {
        guard isOnPath(point: point) else {
            return nil
        }
        let shifted = CGPoint(x: point.x + canvasPosX, y: point.y + canvasPosY)
        for i in 0..<numberOfSlices {
            let shapeLayer = shapeLayers[i]
            if let path = shapeLayer.path, path.contains(shifted) {
                return i
            }
        }
        return nil
    }

    func touchAt(_ point: CGPoint) {
        guard touchEnabled else { return } // Disabled
        guard point.x >= 0 else { return } // Out of bounds
        guard let index = sliceIndex(at: point) else { // Out of scope
            if let selectedIndex = selectedIndex {
                self.selectedIndex = nil
                self.delegate?.pieChartView(self, didReleaseTouchFromSliceIndex: selectedIndex)
            }
            return
        }
        selectedIndex = index
        delegate?.pieChartView(self, didTouchAtSliceIndex: index)
    }

    func touchEndedAt(_ point: CGPoint) {
        guard touchEnabled else { return } // Disabled
        let index: Int
        if let sliceIndex = self.sliceIndex(at: point) {
            index = sliceIndex
        } else if let selectedIndex {
            index = selectedIndex
        } else { // Out of scope and nothing was selected
            return
        }
        selectedIndex = nil
        delegate?.pieChartView(self, didReleaseTouchFromSliceIndex: index)
    }
    
    // MARK: - Storyboard
    
    #if TARGET_INTERFACE_BUILDER
    let ibDataSource = DPPieChartViewIBDataSource()
    
    // swiftlint:disable:next overridden_super_call
    public override func prepareForInterfaceBuilder() {
        datasource = ibDataSource
    }
    #endif
  
}

// MARK: - DPTrackingViewDelegate

extension DPPieChartView: DPTrackingViewDelegate {
    
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


