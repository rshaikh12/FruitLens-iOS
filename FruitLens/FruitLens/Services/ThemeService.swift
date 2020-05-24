//
//  ThemeService.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import UIKit
import ALLoadingView

class ThemeService {
    
    //ColorPicker Ralf Ebert
    
   //#1fafa6
  //static let blueColor = UIColor(red: 31/255, green: 175/255, blue: 166/255, alpha: 1.0)
    
  //#02e8d4
  static let blueColor = UIColor(red: 2/255, green: 232/255, blue: 212/255, alpha: 1.0)
  
  //#088a85
  static let darkblueColor = UIColor(red: 8/255, green: 138/255, blue: 133/255, alpha: 1.0)
  
    //#3ca6b2
  //static let darkblueColor = UIColor(red: 60/255, green: 166/255, blue: 178/255, alpha: 1.0)

  //displaying pop-up views to notify users that some work is in progress
  static func showLoading(_ status: Bool)  {
    if status {
      ALLoadingView.manager.messageText = ""
      ALLoadingView.manager.animationDuration = 1.0
      ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicator)
      return
    }
    ALLoadingView.manager.hideLoadingView()
  }
}
