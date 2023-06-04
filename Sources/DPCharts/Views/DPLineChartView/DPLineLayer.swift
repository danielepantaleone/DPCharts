//
//  DPLineLayer.swift
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

/// A layer to draw a line with optional underneath area.
open class DPLineLayer: CALayer {

    // MARK: - Properties
    
    var animationEnabled: Bool = true
    var animationDuration: TimeInterval = 0.2
    var animationTimingFunction: CAMediaTimingFunctionName = .linear
    var areaEnabled: Bool = false
    var areaAlpha: CGFloat = 0.3
    var areaGradientEnabled: Bool = false
    var lineColor: UIColor = .black
    var lineBezierCurveEnabled: Bool = false
    var linePoints: [DPLinePoint] = []
    var lineWidth: CGFloat = 1.0
    var canvasOriginOffsetY: CGFloat = 0
    
    // MARK: - Sublayers
    
    let linePath = UIBezierPath()
    let areaPath = UIBezierPath()
    
    lazy var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.fillColor = nil
        return layer
    }()
    lazy var areaLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.lineWidth = 0
        return layer
    }()
    lazy var areaGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 1.0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.0)
        return layer
    }()

    // MARK: - Initialization
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    override init(layer: Any) {
        guard let layer = layer as? DPLineLayer else {
            fatalError("Expecting DPBarLayer got \(type(of: layer))")
        }
        animationEnabled = layer.animationEnabled
        animationDuration = layer.animationDuration
        animationTimingFunction = layer.animationTimingFunction
        linePoints = layer.linePoints
        lineColor = layer.lineColor
        lineWidth = layer.lineWidth
        lineBezierCurveEnabled = layer.lineBezierCurveEnabled
        areaEnabled = layer.areaEnabled
        areaAlpha = layer.areaAlpha
        areaGradientEnabled = layer.areaGradientEnabled
        canvasOriginOffsetY = layer.canvasOriginOffsetY
        super.init(layer: layer)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open override func layoutSublayers() {
        super.layoutSublayers()
        setupLayers()
        setupAnimations()
    }

    // MARK: - Initialization
    
    func commonInit() {
        addSublayer(areaGradientLayer)
        addSublayer(lineLayer)
        masksToBounds = true
    }

    // MARK: - Interface
    
    func closestPointAt(x: CGFloat) -> DPLinePoint? {
        var compare: CGFloat = .greatestFiniteMagnitude
        var p: DPLinePoint?
        for point in linePoints {
            let distance = abs(point.x - x)
            if distance < compare {
                compare = distance
                p = point
            }
        }
        return p
    }

    func pointAt(index: Int) -> DPLinePoint? {
        return linePoints[safeIndex: index]
    }

    func removeAllPoints() {
        linePoints.removeAll()
    }
    
    // MARK: - Rendering
    
    private func setupLayers() {
        
        var p0: CGPoint = .zero
        var p1: CGPoint = .zero
        var p2: CGPoint = .zero
        var p3: CGPoint = .zero
        var cp1: CGPoint = .zero
        var cp2: CGPoint = .zero
        
        // ----------------------------------------
        // COMPUTE PATH
        
        areaPath.removeAllPoints()
        linePath.removeAllPoints()

        for i in 0..<linePoints.count {
            p0 = linePoints[i].cgPoint
            if i == 0 {
                areaPath.move(to: p0)
                linePath.move(to: p0)
            } else {
                if lineBezierCurveEnabled {
                    p1 = linePoints[i - 1].cgPoint
                    p2 = i >= 2 ? linePoints[i - 2].cgPoint : CGPoint(x: 0, y: linePoints[0].cgPoint.y)
                    p3 = i < linePoints.count - 1 ? linePoints[i + 1].cgPoint : linePoints.last?.cgPoint ?? .zero
                    cp1 = CGPoint(x: p1.x + (p0.x - p1.x) * 0.3, y: p1.y - (p1.y - p0.y) * 0.3 - (p2.y - p1.y) * 0.3)
                    cp2 = CGPoint(x: p1.x + 2 * (p0.x - p1.x) * 0.3, y: (p1.y - 2 * (p1.y - p0.y) * 0.3) + (p0.y - p3.y) * 0.3)
                    areaPath.addCurve(to: p0, controlPoint1: cp1, controlPoint2: cp2)
                    linePath.addCurve(to: p0, controlPoint1: cp1, controlPoint2: cp2)
                } else {
                    areaPath.addLine(to: p0)
                    linePath.addLine(to: p0)
                }
            }
        }

        if linePoints.count > 0 {
            areaPath.addLine(to: CGPoint(x: p0.x, y: canvasOriginOffsetY))
            areaPath.addLine(to: CGPoint(x: 0, y: canvasOriginOffsetY))
            areaPath.close()
        }

        // ----------------------------------------
        // SETUP LAYERS
        
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = lineWidth
        areaLayer.path = areaPath.cgPath
        areaLayer.frame = areaPath.bounds
        areaLayer.bounds = areaPath.bounds
        areaGradientLayer.frame = bounds
        areaGradientLayer.bounds = bounds
        areaGradientLayer.mask = areaLayer
        areaGradientLayer.isHidden = !areaEnabled

        if areaGradientEnabled {
            areaGradientLayer.colors = [
                UIColor.clear.cgColor,
                lineColor.withAlphaComponent(areaAlpha).cgColor
            ]
        } else {
            areaGradientLayer.colors = [
                lineColor.withAlphaComponent(areaAlpha).cgColor,
                lineColor.withAlphaComponent(areaAlpha).cgColor
            ]
        }
        
    }
    
    private func setupAnimations() {
        areaLayer.removeAnimation(forKey: "path")
        lineLayer.removeAnimation(forKey: "path")
        if animationEnabled {
            func animate(layer: CAShapeLayer, path: UIBezierPath) {
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = animationDuration
                animation.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
                animation.toValue = path
                animation.isRemovedOnCompletion = true
                layer.add(animation, forKey: "path")
            }
            animate(layer: lineLayer, path: linePath)
            animate(layer: areaLayer, path: areaPath)
        }
    }

}
