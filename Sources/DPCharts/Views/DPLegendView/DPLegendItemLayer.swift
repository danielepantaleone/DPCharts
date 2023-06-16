//
//  DPLegendItemLayer.swift
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

/// A layer to draw a legend item.
open class DPLegendItemLayer: CALayer {
    
    // MARK: - Properties
    
    var shapeSize: CGFloat = 10.0
    var shapeType: DPShapeType = .circle
    var shapeColor: UIColor = .black
    var spacing: CGFloat = 8.0
    var title: String?
    var titleColor: UIColor = .lightGray
    var titleFont: UIFont = .systemFont(ofSize: 12, weight: .regular)
    
    // MARK: - Computed properties
    
    var titleAttributedString: NSAttributedString? {
        guard let title else {
            return nil
        }
        return NSAttributedString(string: title, attributes: [
            .foregroundColor: titleColor,
            .font: titleFont
        ])
    }
    var titleSize: CGSize {
        return titleAttributedString?.size() ?? .zero
    }
    var size: CGSize {
        guard let titleAttributedString = titleAttributedString else {
            return .zero
        }
        let height = max(titleAttributedString.size().height, shapeSize)
        let width = shapeSize + spacing + titleAttributedString.size().width
        return CGSize(width: width, height: height)
    }
  
    // MARK: - Sublayers
    
    lazy var shapeLayer: DPShapeLayer = DPShapeLayer()
    lazy var titleLayer: CATextLayer = CATextLayer()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        commonInit()
    }
   
    override init(layer: Any) {
        guard let layer = layer as? DPLegendItemLayer else {
            fatalError("Expecting DPLegendItemLayer got \(type(of: layer))")
        }
        shapeSize = layer.shapeSize
        shapeType = layer.shapeType
        shapeColor = layer.shapeColor
        title = layer.title
        titleColor = layer.titleColor
        titleFont = layer.titleFont
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
        addSublayer(shapeLayer)
        addSublayer(titleLayer)
        masksToBounds = true
        isOpaque = true
    }

    // MARK: - Rendering
    
    private func setupLayers() {
        guard let titleAttributedString = titleAttributedString else {
            shapeLayer.frame = .zero
            titleLayer.frame = .zero
            return
        }
        let maxHeight = max(titleAttributedString.size().height, shapeSize)
        shapeLayer.color = shapeColor
        shapeLayer.type = shapeType
        shapeLayer.frame = CGRect(
            x: 0,
            y: (maxHeight - shapeSize) * 0.5,
            width: shapeSize,
            height: shapeSize)
        titleLayer.contentsScale = UIScreen.main.scale
        titleLayer.alignmentMode = .left
        titleLayer.string = titleAttributedString
        titleLayer.frame = CGRect(
            x: shapeSize + spacing,
            y: (maxHeight - titleSize.height) * 0.5,
            width: titleSize.width,
            height: titleSize.height)
    }
    
}
