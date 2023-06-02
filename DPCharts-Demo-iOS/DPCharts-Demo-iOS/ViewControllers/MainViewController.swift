//
//  MainViewController.swift
//  DPCharts-Demo-iOS
//
//  Created by Daniele Pantaleone
//    - Github: https://github.com/danielepantaleone
//    - LinkedIn: https://www.linkedin.com/in/danielepantaleone
//
//  Copyright © 2023 Daniele Pantaleone. Licensed under MIT License.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Properties
    
    let viewFactory: ViewFactory = ViewFactory()
    
    // MARK: - Lifecycle
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    // MARK: - Initialization

    private func setupNavigationBar() {
        navigationItem.title = "DPCharts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onDeletePressed(_ :)))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddPressed(_ :))),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(onRefreshPressed(_ :)))
        ]
    }
    
    // MARK: - Actions

    @objc func onAddPressed(_ sender: Any) {
        guard let viewController = UIStoryboard.load(identifier: .PickerViewController) as? PickerViewController else {
            return
        }
        viewController.completionHandler = { viewType in
            self.addView(ofType: viewType)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

    @objc func onDeletePressed(_ sender: Any) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }

    @objc func onRefreshPressed(_ sender: Any) {
        viewFactory.reloadDatasets()
        stackView.arrangedSubviews.forEach {
            $0.setNeedsLayout()
            $0.setNeedsDisplay()
        }
    }
    
    // MARK: - Internals
    
    private func addView(ofType type: ViewType) {
        let view = viewFactory.createView(ofType: type)
        stackView.addArrangedSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
}
