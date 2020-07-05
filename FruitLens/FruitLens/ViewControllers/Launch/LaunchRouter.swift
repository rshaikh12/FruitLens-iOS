//
//  LaunchRouter.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit


@objc protocol LaunchRoutingLogic {
    func routeToWelcome()
    func routeToMain()
}

class LaunchRouter: NSObject, LaunchRoutingLogic {
    
    weak var viewController: UIViewController?
    
    init(_ vc: UIViewController) {
        super.init()
        self.viewController = vc
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .logoutRequest, object: nil)
    }
    
    func routeToWelcome() {
        let top = UIWindow.getVisibleViewControllerFrom(viewController!)!
        top.performSegueIfPossible(id: "Welcome", sender: nil)
    }
    
    func routeToMain() {
        let top = UIWindow.getVisibleViewControllerFrom(viewController!)!
        top.performSegueIfPossible(id: "Main", sender: nil)
    }
    
    @objc func logout() {
        do {
            UserManager.logout()
            Config.clearConfig()
            try Database.deleteTables()
            DispatchQueue.main.async {
                self.routeToWelcome()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
