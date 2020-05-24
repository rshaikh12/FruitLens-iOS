//
//  AuthViewController.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import UIKit

class AuthViewController: UIViewController {
  
  //Properties: IBOutlets
  @IBOutlet weak var registerImageView: UIImageView!
  @IBOutlet weak var registerNameTextField: UITextField!
  @IBOutlet weak var registerEmailTextField: UITextField!
  @IBOutlet weak var registerPasswordTextField: UITextField!
  @IBOutlet weak var loginEmailTextField: UITextField!
  @IBOutlet weak var loginPasswordTextField: UITextField!
  @IBOutlet var separatorViews: [UIView]!
  @IBOutlet weak var cloudsImageView: UIImageView!
  @IBOutlet weak var cloudsImageViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var loginViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var registerViewTopConstraint: NSLayoutConstraint!
    
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }

  // Private properties
  private var selectedImage: UIImage?
  private let manager = UserManager()
  private let imageService = ImagePickerService()
  
  //Animation lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateClouds()
  }
    
  /*override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
  }*/
}

//IBActions
extension AuthViewController {
  
  @IBAction func register(_ sender: Any) {
    guard let name = registerNameTextField.text, let email = registerEmailTextField.text, let password = registerPasswordTextField.text else {
      return
    }
    //colorize the tags black if empty or not valid
    guard !name.isEmpty else {
      separatorViews.filter({$0.tag == 2}).first?.backgroundColor = .black
      return
    }
    guard email.isValidEmail() else {
      separatorViews.filter({$0.tag == 3}).first?.backgroundColor = .black
      return
    }
    guard password.count > 5 else {
      separatorViews.filter({$0.tag == 4}).first?.backgroundColor = .black
      return
    }
    view.endEditing(true)
    let user = ObjectUser()
    user.name = name
    user.email = email
    user.password = password
    user.profilePic = selectedImage
    ThemeService.showLoading(true)
    manager.register(user: user) {[weak self] response in
      ThemeService.showLoading(false)
      switch response {
        case .failure: self?.showAlert()
        case .success: self?.dismiss(animated: true, completion: nil)//Dismisses the view controller that was presented modally by the view controller
      }
    }
  }
  
  @IBAction func login(_ sender: Any) {
    guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {
      return
    }
    //colorize the tags black if empty or not valid
    guard email.isValidEmail() else {
      separatorViews.filter({$0.tag == 0}).first?.backgroundColor =
        .black
      return
    }
    guard password.count > 5 else {
      separatorViews.filter({$0.tag == 1}).first?.backgroundColor =
        .black
      return
    }
    view.endEditing(true)
    let user = ObjectUser()
    user.email = email
    user.password = password
    ThemeService.showLoading(true)
    manager.login(user: user) {[weak self] response in
      ThemeService.showLoading(false)
      switch response {
      case .failure: self?.showAlert() //UIViewControllerExtension
      case .success: self?.dismiss(animated: true, completion: nil) //Dismisses the view controller that was presented modally by the view controller
      }
    }
  }
  
  @IBAction func switchViews(_ sender: UIButton) {
    let shouldShowLogin = loginViewTopConstraint.constant != 30
    sender.setTitle(!shouldShowLogin ? "Login": "Create Your Account", for: .normal)
    //set the constraint constant for the current device
    loginViewTopConstraint.constant = shouldShowLogin ? 30 : -800
    registerViewTopConstraint.constant = shouldShowLogin ? -800 : 30
    UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  @IBAction func profileImage(_ sender: Any) {
    imageService.pickImage(from: self) {[weak self] image in
      self?.registerImageView.image = image
      self?.selectedImage = image
    }
  }
}

// Clouds-Animation
extension AuthViewController {
  
  private func animateClouds() {
    cloudsImageViewLeadingConstraint.constant = 0
    cloudsImageView.layer.removeAllAnimations()
    view.layoutIfNeeded()
    let distance = view.bounds.width - cloudsImageView.bounds.width
    self.cloudsImageViewLeadingConstraint.constant = distance
    UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .curveLinear], animations: {
      self.view.layoutIfNeeded()
    })
  }
}

//UITextField Delegate
extension AuthViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    separatorViews.forEach({$0.backgroundColor = .darkGray})
  }
}

