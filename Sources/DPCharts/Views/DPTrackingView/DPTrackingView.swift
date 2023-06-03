//
//  DPTrackingView.swift
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

/// Custom view to track touch gestures.
class DPTrackingView: UIView {
    
    // MARK: - Properties
    
    var isEnabled: Bool = true

    var insets: UIEdgeInsets = .zero {
        didSet {
            if insets != oldValue {
                setNeedsLayout()
            }
        }
    }
    
    weak var delegate: DPTrackingViewDelegate?
    
    // MARK: - Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Initialization

    private func commonInit() {
        backgroundColor = .clear
        isExclusiveTouch = true
    }
    
    // MARK: - Misc
    
    private func inTouchArea(_ point: CGPoint) -> Bool {
        return point.x > insets.left &&
            point.x < bounds.width - insets.right &&
            point.y > insets.top &&
            point.y < bounds.height - insets.bottom
    }
    
    // MARK: - Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled && touches.count == 1, let touch = touches.first else {
            super.touchesBegan(touches, with: event)
            return
        }
        let point = touch.location(in: self)
        if inTouchArea(point) {
             if touch.tapCount == 1 {
                delegate?.trackingView(self, touchDownAt: point)
            } else if touch.tapCount == 2 {
                NSObject.cancelPreviousPerformRequests(withTarget: self)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled && touches.count == 1, let touch = touches.first else {
            super.touchesMoved(touches, with: event)
            return
        }
        let point = touch.location(in: self)
        if inTouchArea(point) {
            delegate?.trackingView(self, touchMovedTo: point)
        } else {
            delegate?.trackingView(self, touchCanceledAt: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled && touches.count == 1, let touch = touches.first else {
            super.touchesEnded(touches, with: event)
            return
        }
        let point = touch.location(in: self)
        if inTouchArea(point) {
            delegate?.trackingView(self, touchUpAt: point)
            if touch.tapCount == 1 {
                delegate?.trackingView(self, tapSingleAt: point)
            } else if touch.tapCount == 2 {
                delegate?.trackingView(self, tapDoubleAt: point)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled && touches.count == 1, let touch = touches.first else {
            super.touchesCancelled(touches, with: event)
            return
        }
        let point = touch.location(in: self)
        if inTouchArea(point) {
            delegate?.trackingView(self, touchCanceledAt: point)
        }
    }
    
}

