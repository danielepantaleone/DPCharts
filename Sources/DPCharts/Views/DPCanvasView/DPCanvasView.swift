//
//  DPCanvasView.swift
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

/// Basic implementation that draws a canvas where to render charts content.
@IBDesignable
open class DPCanvasView: UIView {
    
    // MARK: - Border properties
    
    /// The color of the borders surrounding the chart (default = `.lightGray`).
    @IBInspectable
    open var bordersColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }

    /// The width of the borders surrounding the chart (default = `1`).
    @IBInspectable
    open var bordersWidth: CGFloat = 1 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Markers properties
    
    /// The alpha to be applied when drawing markers lines (default = `0.7`).
    @IBInspectable
    open var markersLineAlpha: CGFloat = 0.7 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color of the marker lines (default = `.lightGray`).
    @IBInspectable
    open var markersLineColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Whether to draw markers using a dash pattern (`true`), or `false` to use a solid line (default = `true`).
    @IBInspectable
    open var markersLineDashed: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The dash pattern (comma separated) to apply when `markersLineDashed` is `true` (default = `2, 2`).
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'markersLineDashLengths' instead.")
    @IBInspectable
    open var markersLineDashPattern: String {
        get { markersLineDashLengths.map(String.init).joined(separator: ", ") }
        set { markersLineDashLengths = newValue.components(separatedBy: ",").compactMap { Double($0).map { CGFloat($0) } } }
    }
   
    /// The width of marker lines (default = `0.5`).
    @IBInspectable
    open var markersLineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    /// The color of markers text (default = `.lightGray`).
    @IBInspectable
    open var markersTextColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
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
    
    // MARK: - X-axis properties
    
    /// The X-axis title (default = `nil`).
    @IBInspectable
    open var xAxisTitle: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color of the X-axis title (default = `.lightGray`).
    @IBInspectable
    open var xAxisTitleColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The spacing between X-axis title and the markers (default = `8`).
    @IBInspectable
    open var xAxisTitleSpacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Y-axis properties
    
    /// The the Y-axis title (default = `nil`).
    @IBInspectable
    open var yAxisTitle: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The color Y-axis title color (default = `.lightGray`).
    @IBInspectable
    open var yAxisTitleColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The spacing between Y-axis title and the markers (default = `8`).
    @IBInspectable
    open var yAxisTitleSpacing: CGFloat = 8 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// If `true` the Y-axis will be placed on the right, otherwise on the left (default = `true`).
    @IBInspectable
    open var yAxisInverted: Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Public properties
    
    /// The internal insets of the chart (default = `UIEdgeInsets.zero`).
    open var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The dash lengths to apply when `markersLineDashed` is `true` (default = `[2, 2]`).
    open var markersLineDashLengths: [CGFloat] = [2, 2] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The font used to render markers (default = `.systemFont(ofSize: 12)`).
    open var markersTextFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The font of the title of the markers on the X-axis (default = `.systemFont(ofSize: 12)`).
    open var xAxisTitleFont: UIFont = .italicSystemFont(ofSize: 12) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// The font of the title of the markers on the Y-axis (default = `.systemFont(ofSize: 12)`).
    open var yAxisTitleFont: UIFont = .italicSystemFont(ofSize: 12) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Computed properties
    
    var canvasHeight: CGFloat {
        return frame.height - insets.top - insets.bottom - bordersWidth - markersLineWidth - xAxisMarkersMaxHeight - xAxisTitleHeight
    }
    var canvasWidth: CGFloat {
        return frame.width - insets.left - insets.right - bordersWidth - markersLineWidth - yAxisMarkersMaxWidth - yAxisTitleHeight
    }
    var canvasPosX: CGFloat {
        var pos: CGFloat = insets.left
        if yAxisInverted {
            pos += markersLineWidth
        } else {
            pos += bordersWidth + yAxisMarkersMaxWidth + yAxisTitleHeight
        }
        return pos
    }
    var canvasPosY: CGFloat {
        return insets.top + markersLineWidth
    }
    var xAxisTitleHeight: CGFloat {
        guard let string = xAxisTitleAttributedString else {
            return 0
        }
        return string.size().height + xAxisTitleSpacing
    }
    var xAxisTitleAttributedString: NSAttributedString? {
        guard let title = xAxisTitle, !title.isEmpty else {
            return nil
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return NSAttributedString(string: title, attributes: [
            .foregroundColor: xAxisTitleColor,
            .font: xAxisTitleFont,
            .paragraphStyle: paragraph
        ])
    }
    var yAxisTitleHeight: CGFloat {
        guard let string = yAxisTitleAttributedString else {
            return 0
        }
        return string.size().height + yAxisTitleSpacing
    }
    var yAxisTitleAttributedString: NSAttributedString? {
        guard let title = yAxisTitle, !title.isEmpty else {
            return nil
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        return NSAttributedString(string: title, attributes: [
            .foregroundColor: yAxisTitleColor,
            .font: yAxisTitleFont,
            .paragraphStyle: paragraph
        ])
    }
    
    // MARK: - Abstract properties
    
    var xAxisMarkersMaxHeight: CGFloat {
        preconditionFailure("xAxisMarkersMaxHeight must be implemented")
    }
    var yAxisMarkersMaxWidth: CGFloat {
        preconditionFailure("yAxisMarkersMaxWidth must be implemented")
    }
    
    // MARK: - Custom drawing
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawAxisTitles(rect)
        drawCanvas(rect)
    }
    
    // MARK: - Drawing
    
    func drawCanvas(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // ----------------------------------------
        // BEGIN

        let x1, x2: CGFloat
        let y1 = insets.top
        let y2 = rect.height - insets.bottom - xAxisMarkersMaxHeight - xAxisTitleHeight
        if yAxisInverted {
            x1 = insets.left
            x2 = rect.width - insets.right - yAxisMarkersMaxWidth - yAxisTitleHeight
        } else {
            x1 = insets.left + yAxisMarkersMaxWidth + yAxisTitleHeight
            x2 = rect.width - insets.right
        }
        
        ctx.saveGState()
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)

        // ----------------------------------------
        // BORDERS
        
        // ************************************* //
        // (x1, y1) ------------------ (x2, y1)  //
        //     |                           |     //
        //     |                           |     //
        //     |                           |     //
        //     |                           |     //
        //     |                           |     //
        // (x1, y2) ------------------ (x2, y2)  //
        // ************************************* //
        
        ctx.saveGState()
        ctx.setLineWidth(bordersWidth)
        ctx.setStrokeColor(bordersColor.cgColor)
        if yAxisInverted { // TRAILING AND BOTTOM
            ctx.move(to: CGPoint(x: x1, y: y2 - (bordersWidth * 0.5)))
            ctx.addLine(to: CGPoint(x: x2 - (bordersWidth * 0.5), y: y2 - (bordersWidth * 0.5)))
            ctx.addLine(to: CGPoint(x: x2 - (bordersWidth * 0.5), y: y1))
        } else { // LEADING AND BOTTOM
            ctx.move(to: CGPoint(x: x1 + (bordersWidth * 0.5), y: y1))
            ctx.addLine(to: CGPoint(x: x1 + (bordersWidth * 0.5), y: y2 - (bordersWidth * 0.5)))
            ctx.addLine(to: CGPoint(x: x2, y: y2 - (bordersWidth * 0.5)))
        }
        ctx.strokePath()
        ctx.restoreGState()
        
        // ----------------------------------------
        // OUTER MARKERS
        
        // ************************************* //
        // (x1, y1) ------------------ (x2, y1)  //
        //     |                           |     //
        //     |                           |     //
        //     |                           |     //
        //     |                           |     //
        //     |                           |     //
        // (x1, y2) ------------------ (x2, y2)  //
        // ************************************* //
        
        ctx.saveGState()
        ctx.setAlpha(markersLineAlpha)
        ctx.setLineDash(phase: 0, lengths: markersLineDashed ? markersLineDashLengths : [])
        ctx.setLineWidth(markersLineWidth)
        ctx.setStrokeColor(markersLineColor.cgColor)
        if yAxisInverted { // LEADING AND TOP
            ctx.move(to: CGPoint(x: x1 + (markersLineWidth * 0.5), y: y2))
            ctx.addLine(to: CGPoint(x: x1 + (markersLineWidth * 0.5), y: y1 + (markersLineWidth * 0.5)))
            ctx.addLine(to: CGPoint(x: x2, y: y1 + (markersLineWidth * 0.5)))
        } else { // TRAILING AND TOP
            ctx.move(to: CGPoint(x: x1, y: y1 - (markersLineWidth * 0.5) + (bordersWidth * 0.5)))
            ctx.addLine(to: CGPoint(x: x2 - (markersLineWidth * 0.5), y: y1 - (markersLineWidth * 0.5) + (bordersWidth * 0.5)))
            ctx.addLine(to: CGPoint(x: x2 - (markersLineWidth * 0.5), y: y2))  // V
        }
        ctx.strokePath()
        ctx.restoreGState()
    
        // ----------------------------------------
        // END
        
        ctx.restoreGState()
        
    }
    
    func drawAxisTitles(_ rect: CGRect) {
     
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.saveGState()
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
        ctx.setAlpha(1.0)
        
        let canvasPosX = canvasPosX
        let canvasPosY = canvasPosY
        let canvasWidth = canvasWidth
        let canvasHeight = canvasHeight
        
        // ----------------------------------------
        // X-AXIS TITLE
        
        if let xAxisTitleAttributedString {
            let labelPositionOnXAxis: CGFloat = canvasPosX
            let labelPositionOnYAxis: CGFloat = canvasPosY + canvasHeight + xAxisTitleSpacing + xAxisMarkersMaxHeight
            xAxisTitleAttributedString.draw(in: CGRect(
                x: labelPositionOnXAxis,
                y: labelPositionOnYAxis,
                width: canvasWidth,
                height: xAxisTitleAttributedString.size().height))
        }
        
        // ----------------------------------------
        // Y-AXIS TITLE
        
        if let yAxisTitleAttributedString {
            let labelPositionOnXAxis: CGFloat = rect.height - canvasPosY - canvasHeight
            let labelPositionOnYAxis: CGFloat
            if yAxisInverted {
                labelPositionOnYAxis = rect.width - insets.right - (yAxisTitleHeight * 0.5)
            } else {
                labelPositionOnYAxis = 0
            }
            ctx.concatenate(CGAffineTransform(rotationAngle: -(.pi * 0.5)))
            ctx.translateBy(x: -rect.height, y: 0)
            yAxisTitleAttributedString.draw(in: CGRect(
                x: labelPositionOnXAxis,
                y: labelPositionOnYAxis,
                width: canvasHeight,
                height: yAxisTitleAttributedString.size().height))
        }
        
        ctx.restoreGState()
        
    }

}


