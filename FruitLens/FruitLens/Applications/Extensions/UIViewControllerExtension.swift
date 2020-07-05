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
  
  func showAlert(title: String = "Error", message: String = "Connection error", completion: EmptyCompletion? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
      completion?()
    }))
    present(alert, animated: true, completion: nil)
  }
    
    func canPerformSegue(withIdentifier id: String) -> Bool {
        guard let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        return segues.first { $0.value(forKey: "identifier") as? String == id } != nil
    }
    
    /// Performs segue with passed identifier, if self can perform it.
    func performSegueIfPossible(id: String?, sender: AnyObject? = nil) {
        guard let id = id, canPerformSegue(withIdentifier: id) else { return }
        self.performSegue(withIdentifier: id, sender: sender)
    }
}
