//
//  UIViewControllerExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import UIKit

//showAllert if register-connection is not possible or something going wrong
extension UIViewController {
  
  func showAlert(title: String = "Error", message: String = "Ups, please try again", completion: EmptyCompletion? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
      completion?()
    }))
    present(alert, animated: true, completion: nil)
  }
}
