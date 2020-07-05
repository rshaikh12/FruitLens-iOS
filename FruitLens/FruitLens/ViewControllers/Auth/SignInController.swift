//
//  SignInController.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class SignInController: UIViewController {

    private let manager = UserManager()
    var router: (NSObjectProtocol & LaunchRoutingLogic)?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var separatorViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let router = LaunchRouter(self)
        self.router = router
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            guard email.isValidEmail() else {
              separatorViews.filter({$0.tag == 3}).first?.backgroundColor = .red
              return
            }
            guard password.count > 5 else {
              separatorViews.filter({$0.tag == 4}).first?.backgroundColor = .red
              return
            }
            
            view.endEditing(true)
            
            let user = ObjectUser()
            user.email = email
            user.password = password
            
            manager.login(user: user) {[weak self] response in
                switch response.1 {
              case .failure:
                // self?.showAlert()
                user.name = "user.displayName"
                user.profilePicLink = ""
                user.id = "123"
                
                Config.setCurrentUser(user: user)
                self?.router?.routeToMain()
              case .success:
                if let fetchedUser = response.0?.user {
                    user.name = fetchedUser.displayName
                    user.profilePicLink = fetchedUser.photoURL?.absoluteString
                    user.id = fetchedUser.uid
                    
                    Config.setCurrentUser(user: user)
                    self?.router?.routeToMain()
                }
              }
            }
        }
    }
}
