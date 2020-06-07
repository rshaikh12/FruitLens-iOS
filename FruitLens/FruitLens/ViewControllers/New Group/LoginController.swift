//
//  LoginController.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var router: (NSObjectProtocol & LaunchRoutingLogic)?
    
    @IBOutlet weak var loginButton: UIButton!

    fileprivate var rootViewController: UIViewController? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
    }
    
    private func setup() {
        let router = LaunchRouter(self)
        self.router = router
    }
}
