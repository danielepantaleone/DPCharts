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
    var datasetIndex: Int = 0
    var numberOfPoints: Int = 0
    var scatterPointsAlpha: CGFloat = DPScatterChartView.defaultPointAlpha
    var scatterPointsColor: UIColor = DPScatterChartView.defaultPointColor
    var scatterPointsType: DPShapeType = DPScatterChartView.defaultPointShapeType
    var scatterPoints: [DPScatterPoint] = []
    var selectedIndexAlphaPredominance: CGFloat = 0.6
    var selectedIndex: Int? {
        didSet {
            setupLayers()
            setupOpacity()
        }
    }
    
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
    
    init(datasetIndex: Int, numberOfPoints: Int) {
        super.init()
        self.datasetIndex = datasetIndex
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
    
    // MARK: - Lifecycle
    
    open override func layoutSublayers() {
        super.layoutSublayers()
        setupLayers()
    }

    // MARK: - Initialization
    
    func commonInit() {
        shapeLayers.forEach { addSublayer($0) }
        masksToBounds = true
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
            shape.color = scatterPointsColor.withAlphaComponent(scatterPointsAlpha)
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
    
    private func setupOpacity() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        opacity = selectedIndex == nil || selectedIndex == datasetIndex ? 1.0 : 1.0 - Float(selectedIndexAlphaPredominance)
        CATransaction.commit()
    }

}

