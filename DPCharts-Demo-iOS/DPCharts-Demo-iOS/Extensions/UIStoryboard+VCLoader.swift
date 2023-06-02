//
//  UIStoryboard+VCLoader.swift
//  DPCharts-Demo-iOS
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import Foundation
import UIKit

enum StoryboardID: String {
    case MainViewController = "MainViewController"
    case PickerViewController = "PickerViewController"
}

enum Storyboard: String {
    case Main = "Main"
}

extension UIStoryboard {

    static func load(from storyboard: Storyboard = .Main, identifier: StoryboardID) -> UIViewController {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue)
    }

}
