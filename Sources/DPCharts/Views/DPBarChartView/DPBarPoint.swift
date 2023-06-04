//
//  DPBarPoint.swift
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

/// A struct to model bar points
public struct DPBarPoint {
    var x: CGFloat
    var y: CGFloat
    var height: CGFloat
    var width: CGFloat
    var barIndex: Int
    var index: Int
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
}
