//
//  DPShapeLayer.swift
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

/// A layer to draw a custom shape.
open class DPShapeLayer: CALayer {
    
    // MARK: - Properties
    
    /// The shape color
    @IBInspectable
    open var color: UIColor = .black {
        didSet {
            shapeLayer.fillColor = color.cgColor
        }
    }
    
    /// The type of the shape to render.
    open var type: DPShapeType = .circle {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Sublayers
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = color.cgColor
        layer.lineCap = .butt
        layer.lineJoin = .bevel
        layer.lineWidth = 0
        layer.strokeColor = nil
        layer.needsDisplayOnBoundsChange = true
        return layer
    }()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        commonInit()
    }
    
    override init(layer: Any) {
        guard let layer = layer as? DPShapeLayer else {
            fatalError("Expecting DPBarLayer got \(Swift.type(of: layer))")
        }
        color = layer.color
        type = layer.type
        super.init(layer: layer)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init()
        commonInit()
    }
    
    func commonInit() {
        addSublayer(shapeLayer)
        masksToBounds = true
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        setupLayer()
    }
    
    // MARK: - Layer configuration
    
    private func setupLayer() {
        switch type {
            case .circle:
                let arcCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
                let arcRadius = (min(bounds.height, bounds.width) * 0.5)
                shapeLayer.path = UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: 0, endAngle: Double.pi * 2.0, clockwise: true).cgPath
            case .diamond:
                let path: UIBezierPath = UIBezierPath()
                path.move(to: CGPoint(x: bounds.midX, y: 0))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
                path.addLine(to: CGPoint(x: 0, y: bounds.midY))
                path.close()
                shapeLayer.path = path.cgPath
            case .square:
                shapeLayer.path = UIBezierPath(rect: bounds).cgPath
            case .triangle:
                let path: UIBezierPath = UIBezierPath()
                path.move(to: CGPoint(x: bounds.midX, y: 0))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                path.addLine(to: CGPoint(x: 0, y: bounds.maxY))
                path.close()
                shapeLayer.path = path.cgPath
        }
    }
    
}
