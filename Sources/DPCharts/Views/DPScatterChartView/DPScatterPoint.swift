//
//  DPScatterPoint.swift
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

/// A struct to model scatter points.
public struct DPScatterPoint {
    var x: CGFloat
    var y: CGFloat
    var datasetIndex: Int
    var index: Int
    var size: CGFloat
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }
}

