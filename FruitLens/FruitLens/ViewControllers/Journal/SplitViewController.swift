//
//  SplitViewController.swift
//  FruitLens
//
//  Created by admin on 05.07.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        
    }

    func splitViewController(
            _ splitViewController: UISplitViewController,
            collapseSecondary secondaryViewController: UIViewController,
            onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }


}
