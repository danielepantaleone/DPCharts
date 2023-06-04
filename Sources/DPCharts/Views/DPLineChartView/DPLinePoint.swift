//
//  DPLinePoint.swift
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

/// A struct to model line points.
public struct DPLinePoint {
    var x: CGFloat
    var y: CGFloat
    var lineIndex: Int
    var index: Int
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
}
