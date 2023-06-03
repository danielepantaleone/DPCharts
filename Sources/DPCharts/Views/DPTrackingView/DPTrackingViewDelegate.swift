//
//  DPTrackingViewDelegate.swift
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

protocol DPTrackingViewDelegate: AnyObject {
    /// Sent to the delegate when a touch gesture starts at a specific point
    func trackingView(_ trackingView: DPTrackingView, touchDownAt point: CGPoint)
    /// Sent to the delegate when a touch gesture moves to a specific point
    func trackingView(_ trackingView: DPTrackingView, touchMovedTo point: CGPoint)
    /// Sent to the delegate when a touch gesture ends at a specific point
    func trackingView(_ trackingView: DPTrackingView, touchUpAt point: CGPoint)
    /// Sent to the delegate when a touch gesture is canceled at specific point
    func trackingView(_ trackingView: DPTrackingView, touchCanceledAt point: CGPoint)
    /// Sent to the delegate when a tap is detected at a specific point
    func trackingView(_ trackingView: DPTrackingView, tapSingleAt point: CGPoint)
    /// Sent to the delegate when a double tap is detected at a specific point
    func trackingView(_ trackingView: DPTrackingView, tapDoubleAt point: CGPoint)
}
