//
//  CGFloat+Conversions.swift
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

extension CGFloat {
    
    /// Converts decimal degrees to radians.
    var fromDegToRad: CGFloat {
        return self * .pi / 180.0
    }
    
    /// Converts radians to decimal degrees.
    var fromRadToDeg: CGFloat {
        return self * 180.0 / .pi
    }
    
}
