//
//  ViewFactory+DPLegendViewViewDataSource.swift
//  DPCharts-Demo-iOS
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import DPCharts
import Foundation
import UIKit

extension ViewFactory: DPLegendViewDataSource {
   
    func numberOfItems(_ legendView: DPLegendView) -> Int {
        return 2
    }
    func legendView(_ legendView: DPLegendView, shapeColorForItemAtIndex index: Int) -> UIColor {
        return index == 0 ? .primary500 : .secondary500
    }
    func legendView(_ legendView: DPLegendView, shapeTypeForItemAtIndex index: Int) -> DPShapeType {
        return .circle
    }
    func legendView(_ legendView: DPLegendView, titleForItemAtIndex index: Int) -> String {
        return "Item #\(index)"
    }
    
}
