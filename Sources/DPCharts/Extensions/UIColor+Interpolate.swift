//
//  UIColor+Interpolate.swift
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

extension UIColor {
    
    func linearInterpolateTo(_ color: UIColor, percentage: CGFloat) -> UIColor {
        switch percentage {
            case 0:
                return self
            case 1:
                return color
            default:
                var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
                var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
                guard getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else {
                    return self
                }
                guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else {
                    return self
                }
                return UIColor(
                    red: r1 + (r2 - r1) * percentage,
                    green: g1 + (g2 - g1) * percentage,
                    blue: b1 + (b2 - b1) * percentage,
                    alpha: a1 + (a2 - a1) * percentage)
        }
    }
    
}
