//
//  DPLegendView.swift
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

/// Chart legend that draws according with a provided datasource.
@IBDesignable
open class DPLegendView: UIView {
    
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
    
    /// The spacing between the shape and the title of every legend item (default = `4.0`).
    @IBInspectable
    open var itemsSpacing: CGFloat = 4.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The spacing between items in the view (default = `4.0`).
    @IBInspectable
    open var spacing: CGFloat = 4.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The internal insets of the legend view.
    open var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Layout properties
    
    /// Whether to layout legend items horizontally (default = `false`).
    @IBInspectable
    open var horizontal: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Shape properties
    
    /// The size of the shapein every legend item (default = `10.0`).
    @IBInspectable
    open var shapeSize: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Text properties
    
    /// The color of the title in every legend item (default = `.lightGray`).
    @IBInspectable
    open var textColor: UIColor = .lightGray {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The font of the title in every legend item (default = `.systemFont(ofSize: 12, weight: .regular)`).
    open var textFont: UIFont = .systemFont(ofSize: 12, weight: .regular) {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Public weak properties
    
    /// Reference to the legend view datasource.
    open weak var datasource: (any DPLegendViewDataSource)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private properties
        
    var numberOfLegendItems: Int = 0
    var legendItemLayers: [DPLegendItemLayer] = []
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        initLegendItemsIfNeeded()
        layoutLegendItems()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Initialization
    
    func initLegendItemsIfNeeded() {
        guard let datasource else {
            return
        }
        let numberOfLegendItemsChanged = datasource.numberOfItems(self) != numberOfLegendItems
        let numberOfLegendItemsInvalidated = datasource.numberOfItems(self) != legendItemLayers.count
        if numberOfLegendItemsChanged || numberOfLegendItemsInvalidated {
            initLegendItems()
        }
    }
    
    func initLegendItems() {
        guard let datasource else {
            return
        }
        numberOfLegendItems = datasource.numberOfItems(self)
        legendItemLayers.forEach { $0.removeFromSuperlayer() }
        legendItemLayers.removeAll()
        for _ in 0..<numberOfLegendItems {
            let legendItemLayer = DPLegendItemLayer()
            legendItemLayers.append(legendItemLayer)
            layer.addSublayer(legendItemLayer)
        }
    }
    
    // MARK: - Interface
    
    /// Reload legend content by reading its datasource.
    open func reloadData() {
        setNeedsLayout()
    }
    
    // MARK: - Layout

    func layoutLegendItems() {
        guard let datasource else {
            return
        }
        var acc: CGFloat = 0.0
        for i in 0..<numberOfLegendItems {
            let legendItemLayer = legendItemLayers[i]
            legendItemLayer.shapeSize = shapeSize
            legendItemLayer.shapeType = datasource.legendView(self, shapeTypeForItemAtIndex: i)
            legendItemLayer.shapeColor = datasource.legendView(self, shapeColorForItemAtIndex: i)
            legendItemLayer.titleFont = textFont
            legendItemLayer.titleColor = textColor
            legendItemLayer.title = datasource.legendView(self, titleForItemAtIndex: i)
            legendItemLayer.spacing = itemsSpacing
            if horizontal {
                legendItemLayer.frame = CGRect(origin: CGPoint(x: acc, y: 0), size: legendItemLayer.size)
                acc += legendItemLayer.frame.width
            } else {
                legendItemLayer.frame = CGRect(origin: CGPoint(x: 0, y: acc), size: legendItemLayer.size)
                acc += legendItemLayer.frame.height
            }
            acc += spacing
            legendItemLayer.setNeedsLayout()
        }
    }
    
    // MARK: - Storyboard
    
    #if TARGET_INTERFACE_BUILDER
    let ibDataSource = DPLegendViewIBDataSource()
    
    // swiftlint:disable:next overridden_super_call
    public override func prepareForInterfaceBuilder() {
        datasource = ibDataSource
    }
    #endif

    // MARK: - Overrides
    
    public override var intrinsicContentSize: CGSize {
        if horizontal {
            let height: CGFloat = legendItemLayers.map { $0.frame.height }.max() ?? 0.0
            let width: CGFloat = legendItemLayers.last?.frame.maxX ?? 0.0
            return CGSize(width: width, height: height)
        } else {
            let height: CGFloat = legendItemLayers.last?.frame.maxY ?? 0.0
            let width: CGFloat = legendItemLayers.map { $0.frame.width }.max() ?? 0.0
            return CGSize(width: width, height: height)
        }
    }
    
}
