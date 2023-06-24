//
//  DPHeatMapCellLayer.swift
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

/// A layer to draw heatmap cells.
open class DPHeatMapCellLayer: CALayer {
    
    // MARK: - Properties
    
    var animationEnabled: Bool = true
    var animationDuration: TimeInterval = 0.2
    var animationTimingFunction: CAMediaTimingFunctionName = .linear
    var absenceColor: UIColor = .lightGray
    var lowPercentageColor: UIColor = .yellow
    var highPercentageColor: UIColor = .green
    var absenceTextColor: UIColor = .clear
    var text: String?
    var textColor: UIColor = .white
    var textFont: UIFont = .systemFont(ofSize: 12)
    var textCentered: Bool = false
    var textPadding: CGFloat = 2.0
    var cellCornerRadius: CGFloat = 2.0
    var cellValue: DPHeatMapCellValue = .zero
    var selectedIndexAlphaPredominance: CGFloat = 0.6
    var selectedIndex: (rowIndex: Int, columnIndex: Int)? {
        didSet {
            setupLayer()
            setupOpacity()
        }
    }
    
    // MARK: - Computed properties
    
    var shapeFillColor: UIColor {
        if cellValue.percentage > 0 {
            return lowPercentageColor.linearInterpolateTo(highPercentageColor, percentage: cellValue.percentage)
        } else {
            return absenceColor
        }
    }
    var shapePath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: max(cellCornerRadius, 0))
    }
    var textAttributedString: NSAttributedString? {
        guard let text else {
            return nil
        }
        return NSAttributedString(string: text, attributes: [
            .foregroundColor: cellValue.percentage > 0 ? textColor : absenceTextColor,
            .font: textFont
        ])
    }
    var textSize: CGSize {
        return textAttributedString?.size() ?? .zero
    }
    
    // MARK: - Sublayers
    
    lazy var textLayer: CATextLayer = CATextLayer()
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .butt
        layer.lineJoin = .bevel
        layer.lineWidth = 0
        layer.strokeColor = nil
        return layer
    }()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        commonInit()
    }
    
    override init(layer: Any) {
        guard let layer = layer as? DPHeatMapCellLayer else {
            fatalError("Expecting DPHeatMapCellLayer got \(Swift.type(of: layer))")
        }
        absenceColor = layer.absenceColor
        absenceTextColor = layer.absenceTextColor
        lowPercentageColor = layer.lowPercentageColor
        highPercentageColor = layer.highPercentageColor
        cellCornerRadius = layer.cellCornerRadius
        cellValue = layer.cellValue
        textColor = layer.textColor
        textFont = layer.textFont
        text = layer.text
        super.init(layer: layer)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init()
        commonInit()
    }
    
    func commonInit() {
        addSublayer(shapeLayer)
        addSublayer(textLayer)
        masksToBounds = true
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        setupLayer()
    }
    
    // MARK: - Layer configuration
    
    private func setupLayer() {
        let oldPath = shapeLayer.path
        let newPath = shapePath.cgPath
        let oldFillColor = shapeLayer.fillColor
        let newFillColor = shapeFillColor.cgColor
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shapeLayer.fillColor = newFillColor
        shapeLayer.path = newPath
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = .center
        if let string = textAttributedString {
            let x = textCentered ? (bounds.width - textSize.width) * 0.5 : textPadding
            let y = textCentered ? (bounds.height - textSize.height) * 0.5 : textPadding
            let w = min(textSize.width, bounds.width - 2 * textPadding)
            let h = min(textSize.height, bounds.height - 2 * textPadding)
            textLayer.string = string
            textLayer.frame = CGRect(x: x, y: y, width: h, height: w)
        } else {
            textLayer.string = nil
            textLayer.frame = .zero
        }
        CATransaction.commit()
        shapeLayer.removeAllAnimations()
        if animationEnabled {
            let colorAnim: CABasicAnimation = CABasicAnimation(keyPath: "fillColor")
            colorAnim.fromValue = oldFillColor
            colorAnim.toValue = newFillColor
            let pathAnim: CABasicAnimation = CABasicAnimation(keyPath: "path")
            pathAnim.fromValue = oldPath
            pathAnim.toValue = newPath
            let animations: CAAnimationGroup = CAAnimationGroup()
            animations.animations = [colorAnim, pathAnim]
            animations.duration = animationDuration
            animations.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
            animations.isRemovedOnCompletion = true
            shapeLayer.add(animations, forKey: "animations")
        }
    }
    
    private func setupOpacity() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let selectedIndex {
            if selectedIndex.rowIndex == cellValue.rowIndex && selectedIndex.columnIndex == cellValue.columnIndex {
                opacity = 1.0
            } else {
                opacity = 1.0 - Float(selectedIndexAlphaPredominance)
            }
        } else {
            opacity = 1.0
        }
        CATransaction.commit()
    }
    
}
