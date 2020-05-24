//
//  ViewController.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import UIKit


//vc for initial.storyboard
class InitialViewController: UIViewController {

    //default status can be changed to .lightContent
      override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
      }
      
    //after appearing of the initialView if user is not logged in --> auth  else --> conversations
      override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = UIStoryboard.initial(storyboard: UserManager().currentUserID().isNone ? .auth : .objrecwin)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
      }
    }

