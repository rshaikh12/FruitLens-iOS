//
//  RegisterViewController.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    private let manager = UserManager()
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var separatorViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }

    
    @IBAction func submit(_ sender: UIButton) {
        if let name = nameField.text, let email = emailField.text, let password = passwordField.text {
            
            guard !name.isEmpty else {
              separatorViews.filter({$0.tag == 2}).first?.backgroundColor = .red
              return
            }
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
            user.name = name
            user.email = email
            user.password = password
            
            manager.register(user: user) {[weak self] response in
              ThemeService.showLoading(false)
              switch response {
                case .failure: self?.showAlert()
                case .success:
                    print(response)
              }
            }
        }
    }
    
}
