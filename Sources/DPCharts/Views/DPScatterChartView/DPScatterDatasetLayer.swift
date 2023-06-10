//
//  DPScatterDatasetLayer.swift
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

/// A layer to draw a scatter points.
open class DPScatterDatasetLayer: CALayer {

    // MARK: - Properties
    
    var animationEnabled: Bool = true
    var animationDuration: TimeInterval = 0.2
    var animationTimingFunction: CAMediaTimingFunctionName = .linear
    var numberOfPoints: Int = 0
    var scatterPointsColor: UIColor = .black
    var scatterPointsType: DPShapeType = .circle
    var scatterPoints: [DPScatterPoint] = []
    
    // MARK: - Sublayers

    lazy var shapeLayers: [DPShapeLayer] = {
        var layers: [DPShapeLayer] = []
        for _ in 0..<numberOfPoints {
            layers.append(DPShapeLayer())
        }
        return layers
    }()

    // MARK: - Initialization
    
    override init() {
        super.init()
        commonInit()
    }
    
    init(numberOfPoints: Int) {
        super.init()
        self.numberOfPoints = numberOfPoints
        commonInit()
    }
    
    override init(layer: Any) {
        guard let layer = layer as? DPScatterDatasetLayer else {
            fatalError("Expecting DPScatterDatasetLayer got \(type(of: layer))")
        }
        animationEnabled = layer.animationEnabled
        animationDuration = layer.animationDuration
        animationTimingFunction = layer.animationTimingFunction
        numberOfPoints = layer.numberOfPoints
        scatterPointsColor = layer.scatterPointsColor
        scatterPointsType = layer.scatterPointsType
        scatterPoints = layer.scatterPoints
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
    }

    // MARK: - Initialization
    
    func commonInit() {
        shapeLayers.forEach { addSublayer($0) }
        masksToBounds = true
    }

    // MARK: - Interface
    
    func closestPointAt(_ point: CGPoint) -> DPScatterPoint? {
        var compare: CGFloat = .greatestFiniteMagnitude
        var p: DPScatterPoint?
        for scatterPoint in scatterPoints {
            let distance = sqrt(pow(point.x - scatterPoint.x, 2) + pow(point.y - scatterPoint.y, 2))
            if distance < compare {
                compare = distance
                p = scatterPoint
            }
        }
        return p
    }

//    func pointAt(index: Int) -> DPScatterPoint? {
//        return scatterPoints[safeIndex: index]
//    }

    func removeAllPoints() {
        scatterPoints.removeAll()
    }
    
    // MARK: - Rendering
    
    private func setupLayers() {
        for i in 0..<numberOfPoints {
            let point = scatterPoints[i]
            let shape = shapeLayers[i]
            let oldPosition = shape.position
            let oldBounds = shape.bounds
            let newPosition: CGPoint = point.cgPoint
            let newBounds: CGRect = CGRect(x: 0, y: 0, width: point.size, height: point.size)
            CATransaction.setDisableActions(true)
            shape.color = scatterPointsColor
            shape.type = scatterPointsType
            shape.position = newPosition
            shape.bounds = newBounds
            CATransaction.setDisableActions(false)
            shape.removeAllAnimations()
            shape.setNeedsLayout()
            if animationEnabled {
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

