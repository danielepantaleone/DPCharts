//
//  DPHeatMapView.swift
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

// MARK: - DPBarChartView

/// An heatmap chart that draws according with the configured datasource.
@IBDesignable
open class DPHeatMapView: UIView {
    
    // MARK: - Animation properties
    
    /// The duration (in seconds) to use when animating bars (default = `0.2`).
    @IBInspectable
    open var animationDuration: Double = 0.2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The animation function to use when animating bars (default = `linear`).
    @IBInspectable
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'animationTimingFunction' instead.")
    open var animationTimingFunctionName: String {
        get { animationTimingFunction.rawValue }
        set { animationTimingFunction = CAMediaTimingFunctionName(rawValue: newValue) }
    }
    
    /// The animation function to use when animating bars (default = `.linear`).
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
    
    // MARK: - Spacing properties
    
    /// The left spacing (default = `0`).
    @IBInspectable
    open var leftSpacing: CGFloat {
        get { insets.left }
        set { insets = UIEdgeInsets(top: insets.top, left: newValue, bottom: insets.bottom, right: insets.right) }
    }
    
    /// The bottom spacing (default = `0`).
    @IBInspectable
    open var bottomSpacing: CGFloat {
        get { insets.bottom }
        set { insets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: newValue, right: insets.right) }
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
    
    /// The internal insets of the chart (default = `UIEdgeInsets.zero`).
    open var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - X-axis properties
    
    /// If `true` the X-axis will be placed on the bottom, otherwise on the top (default = `false`).
    @IBInspectable
    open var xAxisInverted: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The spacing between the X-axis labels and top/bottom cells (default = `8`).
    @IBInspectable
    open var xAxisLabelsSpacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The height of X-axis labels, 0 or negative if should be calculated automatically (default = `0`).
    @IBInspectable
    open var xAxisLabelsHeight: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// Whether to retain the first computed X-axis label height across updates (`true`), or `false` to re-calculate every time (default = `false`).
    @IBInspectable
    open var xAxisLabelsHeightRetained: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Y-axis properties
    
    /// If `true` the Y-axis will be placed on the right, otherwise on the left (default = `false`).
    @IBInspectable
    open var yAxisInverted: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The spacing between the X-axis label and leading/trailing cells (default = `8`).
    @IBInspectable
    open var yAxisLabelsSpacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The width of Y-axis labels, 0 or negative if should be calculated automatically (default = `0`).
    @IBInspectable
    open var yAxisLabelsWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// Whether to retain the first computed Y-axis label width across updates (`true`), or `false` to re-calculate every time (default = `false`).
    @IBInspectable
    open var yAxisLabelsWidthRetained: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Labels properties
    
    /// The color of markers text (default = `.lightGray`).
    @IBInspectable
    open var axisLabelsTextColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The font used to render markers (default = `.systemFont(ofSize: 12)`).
    open var axisLabelsTextFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Cell configuration properties
    
    /// The corner radius of each cell (default = `2.0`).
    @IBInspectable
    open var cellCornerRadius: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The horizontal spacing between cells (default = `2.0`).
    @IBInspectable
    open var cellHorizontalSpacing: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The vertical spacing between cells (default = `2.0`).
    @IBInspectable
    open var cellVerticalSpacing: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The number of interpolated colors to use (default = `4`).
    @IBInspectable
    open var cellInterpolationCount: Int = 4 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The color to be used to display the value absence (default = `.lightGray`).
    @IBInspectable
    open var cellAbsenceColor: UIColor = .lightGray {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The color to be used to display the low percentage value (interpolated) (default = `.yellow`).
    @IBInspectable
    open var cellLowPercentageColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The color to be used to display the high percentage value (interpolated) (default = `.yellow`).
    @IBInspectable
    open var cellHighPercentageColor: UIColor = .green {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Public weak properties

    /// Reference to the view datasource.
    open weak var datasource: (any DPHeatMapViewDataSource)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private properties
    
    var maxValue: CGFloat = 0
    var numberOfRows: Int = 0
    var numberOfColumns: Int = 0
    var cellLayers: [[DPHeatMapCellLayer]] = []
    var cellValues: [[DPHeatMapCellValue]] = []
    var cellWidth: CGFloat {
        guard numberOfRows > 0 && numberOfColumns > 0 else {
            return 0
        }
        let insets = insets.left + insets.right
        let spacing = numberOfColumns > 1 ? cellHorizontalSpacing * CGFloat(numberOfColumns - 1) : 0.0
        return (bounds.width - insets - spacing - yAxisLabelsMaxWidth) / CGFloat(numberOfColumns)
    }
    var cellHeight: CGFloat {
        guard numberOfRows > 0 && numberOfColumns > 0 else {
            return 0
        }
        let insets = insets.top + insets.bottom
        let spacing = numberOfRows > 1 ? cellVerticalSpacing * CGFloat(numberOfRows - 1) : 0.0
        return (bounds.height - insets - spacing - xAxisLabelsMaxHeight) / CGFloat(numberOfRows)
    }
    var xAxisLabelsRetainedHeight: CGFloat?
    var xAxisLabelsMaxHeight: CGFloat {
        guard numberOfColumns > 0 else {
            return 0
        }
        if xAxisLabelsHeight > 0 {
            return xAxisLabelsHeight
        }
        if xAxisLabelsHeightRetained, let xAxisLabelsRetainedHeight {
            return xAxisLabelsRetainedHeight
        }
        var height: CGFloat = 0
        for i in 0..<numberOfColumns {
            if let marker = xAxisMarkerAtColumnIndex(i) {
                height = max(height, marker.size().height)
            }
        }
        height += xAxisLabelsSpacing
        xAxisLabelsRetainedHeight = height
        return height
    }
    var yAxisLabelsRetainedWidth: CGFloat?
    var yAxisLabelsMaxWidth: CGFloat {
        guard numberOfRows > 0 else {
            return 0
        }
        if yAxisLabelsWidth > 0 {
            return yAxisLabelsWidth
        }
        if yAxisLabelsWidthRetained, let yAxisLabelsRetainedWidth {
            return yAxisLabelsRetainedWidth
        }
        var width: CGFloat = 0
        for i in 0..<numberOfRows {
            if let marker = yAxisMarkerAtRowIndex(i) {
                width = max(width, marker.size().width)
            }
        }
        width += yAxisLabelsSpacing
        yAxisLabelsRetainedWidth = width
        return width
    }
    var canvasHeight: CGFloat {
        return frame.height - insets.top - insets.bottom - xAxisLabelsMaxHeight
    }
    var canvasWidth: CGFloat {
        return frame.width - insets.left - insets.right - yAxisLabelsMaxWidth
    }
    var canvasPosX: CGFloat {
        var pos: CGFloat = insets.left
        if !yAxisInverted {
            pos += yAxisLabelsMaxWidth
        }
        return pos
    }
    var canvasPosY: CGFloat {
        var pos: CGFloat = insets.top
        if !xAxisInverted {
            pos += xAxisLabelsMaxHeight
        }
        return pos
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
        initCellsIfNeeded()
        initLimit()
        initValues()
        layoutCells()
        setNeedsDisplay()
    }
    
    // MARK: - Interface
    
    /// Reload heatmap content by reading its datasource.
    func reloadData() {
        setNeedsLayout()
    }
    
    // MARK: - Initialization

    func commonInit() {
        isOpaque = false
    }
    
    func initCellsIfNeeded() {
        guard let datasource = datasource else {
            return
        }
        let numberOfRowsChanged = datasource.numberOfRows(self) != numberOfRows
        let numberOfColumnsChanged = datasource.numberOfColumns(self) != numberOfColumns
        if numberOfRowsChanged || numberOfColumnsChanged {
            initCells()
        }
    }
    
    func initCells() {
        guard let datasource = datasource else {
            return
        }
        cellLayers.flatMap { $0 }.forEach { $0.removeFromSuperlayer() }
        cellLayers.removeAll()
        numberOfRows = datasource.numberOfRows(self)
        numberOfColumns = datasource.numberOfColumns(self)
        for i in 0..<numberOfRows {
            cellLayers.insert([], at: i)
            for j in 0..<numberOfColumns {
                let cellLayer = DPHeatMapCellLayer()
                cellLayers[i].insert(cellLayer, at: j)
                layer.addSublayer(cellLayer)
            }
        }
    }
    
    func initLimit() {
        maxValue = 0
        guard let datasource = datasource else {
            return
        }
        for i in 0..<numberOfRows {
            for j in 0..<numberOfColumns {
                maxValue = max(maxValue, datasource.heatMapView(self, valueForRowAtIndex: i, forColumnAtIndex: j))
            }
        }
    }
    
    func initValues() {
        guard let datasource = datasource else {
            return
        }
        let step = ((1.0 / CGFloat(cellInterpolationCount)) * 100.0).rounded(.toNearestOrEven)
        cellValues.removeAll()
        for i in 0..<numberOfRows {
            cellValues.insert([], at: i)
            for j in 0..<numberOfColumns {
                let value = datasource.heatMapView(self, valueForRowAtIndex: i, forColumnAtIndex: j)
                let percentage = maxValue > 0 ? (step * (((value / maxValue) * 100.0) / step).rounded(.toNearestOrEven)) / 100.0 : 0.0
                cellValues[i].insert(DPHeatMapCellValue(
                    value: value,
                    percentage: percentage,
                    rowIndex: i,
                    columnIndex: j), at: j)
            }
        }
    }
    
    func layoutCells() {
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let cellWidth = cellWidth
        let cellHeight = cellHeight
        var y: CGFloat = canvasPosY
        for i in 0..<numberOfRows {
            var x: CGFloat = canvasPosX
            for j in 0..<numberOfColumns {
                let cellLayer = cellLayers[i][j]
                cellLayer.animationEnabled = animationsEnabled
                cellLayer.animationDuration = animationDuration
                cellLayer.animationTimingFunction = animationTimingFunction
                cellLayer.cellValue = cellValues[i][j]
                cellLayer.absenceColor = cellAbsenceColor
                cellLayer.lowPercentageColor = cellLowPercentageColor
                cellLayer.highPercentageColor = cellHighPercentageColor
                cellLayer.frame = CGRectMake(x, y, cellWidth, cellHeight)
                cellLayer.setNeedsLayout()
                x += cellWidth + cellHorizontalSpacing
            }
            y += cellHeight + cellVerticalSpacing
        }
    }
    
    // MARK: - Misc
    
    func xAxisMarkerAtColumnIndex(_ columnIndex: Int) -> NSAttributedString? {
        guard let string = datasource?.heatMapView(self, xAxisMarkerLabelForColumnAtIndex: columnIndex) else {
            return nil
        }
        return marker(string)
    }
    
    func yAxisMarkerAtRowIndex(_ rowIndex: Int) -> NSAttributedString? {
        guard let string = datasource?.heatMapView(self, yAxisMarkerLabelForRowAtIndex: rowIndex) else {
            return nil
        }
        return marker(string)
    }
    
    func marker(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            .foregroundColor: axisLabelsTextColor,
            .font: axisLabelsTextFont
        ])
    }
    
    // MARK: - Custom drawing
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawXAxisLabels(rect)
        drawYAxisLabels(rect)
    }
    
    func drawXAxisLabels(_ rect: CGRect) {
        
        guard numberOfColumns > 0 else {
            return
        }
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let canvasHeight = canvasHeight
        let cellWidth = cellWidth
    
        ctx.saveGState()
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
        ctx.setAlpha(1.0)
        
        for i in 0..<numberOfColumns {
            guard let marker = xAxisMarkerAtColumnIndex(i) else {
                continue
            }
            let xShift: CGFloat = (cellWidth * CGFloat(i + 1)) + cellHorizontalSpacing * CGFloat(i) - (cellWidth * 0.5)
            let xPos: CGFloat = canvasPosX + xShift - (marker.size().width * 0.5)
            let yPos: CGFloat
            if xAxisInverted {
                yPos = canvasPosY + canvasHeight + xAxisLabelsSpacing
            } else {
                yPos = insets.top
            }
            marker.draw(at: CGPoint(x: xPos, y: yPos))
        }
        
        ctx.restoreGState()
        
    }
    
    func drawYAxisLabels(_ rect: CGRect) {

        guard numberOfRows > 1 else {
            return
        }
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }

        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let canvasWidth = canvasWidth
        let cellHeight = cellHeight

        ctx.saveGState()
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
        ctx.setAlpha(1.0)
        
        for i in 0..<numberOfRows {
            guard let marker = yAxisMarkerAtRowIndex(i) else {
                continue
            }
            let yShift: CGFloat = (cellHeight * CGFloat(i + 1)) + (cellVerticalSpacing * CGFloat(i)) - (cellHeight * 0.5)
            let yPos: CGFloat = canvasPosY + yShift - (marker.size().height * 0.5)
            let xPos: CGFloat
            if yAxisInverted {
                xPos = canvasPosX + canvasWidth + yAxisLabelsSpacing
            } else {
                xPos = insets.left
            }
            marker.draw(at: CGPoint(x: xPos, y: yPos))
        }
        
        ctx.restoreGState()

    }
    
    // MARK: - Storyboard
    
    #if TARGET_INTERFACE_BUILDER
    let ibDataSource = DPHeatMapViewIBDataSource()
    // swiftlint:disable:next overridden_super_call
    public override func prepareForInterfaceBuilder() {
        datasource = ibDataSource
    }
    #endif

}
