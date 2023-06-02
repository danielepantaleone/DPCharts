//
//  DPBarLayer.swift
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

class DPBarLayer: CALayer {
    
    // MARK: - Properties
    
    var animationEnabled: Bool = true
    var animationDuration: TimeInterval = 0.2
    var animationTimingFunction: CAMediaTimingFunctionName = .linear
    var barPoints: [DPBarPoint] = []
    var barColor: UIColor = .darkGray
    var barCornerRadius: CGFloat = 3.0
    var barWidth: CGFloat = 10.0
    var barIndex: Int = 0
    var selectedIndexAlphaPredominance: CGFloat = 0.6
    var selectedIndex: Int? {
        didSet {
            setupLayers()
            setupLayersOpacity()
        }
    }
    
    // MARK: - Sublayers
    
    let areaPath = UIBezierPath()
    let selectionPath = UIBezierPath()
    
    lazy var areaLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .butt
        layer.lineJoin = .round
        return layer
    }()
    
    lazy var selectionLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .butt
        layer.lineJoin = .round
        return layer
    }()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    convenience init(barIndex: Int) {
        self.init()
        self.barIndex = barIndex
    }
    
    required init?(coder: NSCoder) {
        super.init()
        self.commonInit()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSublayers() {
        super.layoutSublayers()
        setupLayers()
        setupLayersOpacity()
        setupAnimations()
    }
    
    // MARK: - Initialization
    
    func commonInit() {
        addSublayer(areaLayer)
        addSublayer(selectionLayer)
        backgroundColor = UIColor.clear.cgColor
        masksToBounds = true
    }
    
    // MARK: - Interface
    
    func add(x: CGFloat, y: CGFloat, barIndex: Int, index: Int) {
        add(point: DPBarPoint(x: x, y: y, barIndex: barIndex, index: index))
    }
    func add(point: DPBarPoint) {
        barPoints.append(point)
    }

    func closestPointAt(x: CGFloat) -> DPBarPoint? {
        var compare: CGFloat = .greatestFiniteMagnitude
        var p: DPBarPoint?
        for point in barPoints {
            let distance = abs((point.x + (barWidth / 2.0)) - x)
            if distance < compare {
                compare = distance
                p = point
            }
        }
        return p
    }
    
    func pointAt(index: Int) -> DPBarPoint? {
        return barPoints[safeIndex: index]
    }

    func removeAllPoints() {
        barPoints.removeAll()
    }
    
    // MARK: - Rendering
    
    private func setupLayers() {
        areaPath.removeAllPoints()
        selectionPath.removeAllPoints()
        for (index, point) in barPoints.enumerated() {
            areaPath.append(UIBezierPath(
                roundedRect: CGRect(
                    x: point.x,
                    y: point.y,
                    width: barWidth,
                    height: bounds.height - point.y + barCornerRadius),
                cornerRadius: barCornerRadius))
            if selectedIndex == index {
                selectionPath.append(UIBezierPath(
                    roundedRect: CGRect(
                        x: point.x,
                        y: point.y,
                        width: barWidth,
                        height: bounds.height - point.y + barCornerRadius),
                    cornerRadius: barCornerRadius))
            }
        }
        areaLayer.fillColor = barColor.cgColor
        areaLayer.path = areaPath.cgPath
        selectionLayer.fillColor = barColor.cgColor
        selectionLayer.path = selectionPath.cgPath
      
    }
    
    func setupLayersOpacity() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        areaLayer.opacity = selectedIndex == nil ? 1.0 : 1.0 - Float(selectedIndexAlphaPredominance)
        selectionLayer.opacity = selectedIndex == nil ? 0.0 : 1.0
        CATransaction.commit()
    }
    
    private func setupAnimations() {
        areaLayer.removeAnimation(forKey: "path")
        selectionLayer.removeAnimation(forKey: "path")
        if animationEnabled {
            func animate(layer: CAShapeLayer, path: UIBezierPath) {
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = animationDuration
                animation.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
                animation.toValue = path
                animation.isRemovedOnCompletion = true
                layer.add(animation, forKey: "path")
            }
            animate(layer: areaLayer, path: areaPath)
            animate(layer: selectionLayer, path: selectionPath)
        }
    }
    
}

