//
//  DPLegendViewDataSource.swift
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

/// A protocol to configure chart legend appearance.
public protocol DPLegendViewDataSource: AnyObject {
    /// The number of items in the legend view.
    func numberOfItems(_ legendView: DPLegendView) -> Int
    /// The color of the shape of the item at the given index.
    func legendView(_ legendView: DPLegendView, shapeColorForItemAtIndex index: Int) -> UIColor
    /// The type of the shape of the item at the given index.
    func legendView(_ legendView: DPLegendView, shapeTypeForItemAtIndex index: Int) -> DPShapeType
    /// The label for the title of the item at the given index.
    func legendView(_ legendView: DPLegendView, titleForItemAtIndex index: Int) -> String
}

#if TARGET_INTERFACE_BUILDER
public class DPLegendViewIBDataSource: DPLegendViewDataSource {
    
    func numberOfItems(_ legendView: DPLegendView) -> Int {
        return 2
    }
    func legendView(_ legendView: DPLegendView, shapeColorForItemAtIndex index: Int) -> UIColor {
        return index == 0 ? .blue : .red
    }
    func legendView(_ legendView: DPLegendView, shapeTypeForItemAtIndex index: Int) -> DPShapeType {
        return .circle
    }
    func legendView(_ legendView: DPLegendView, titleForItemAtIndex index: Int) -> String {
        return "Item #\(index)"
    }
    
}
#endif
