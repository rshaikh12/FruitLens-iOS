//
//  UIStoryboardExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


//possible storyboards enumerating
import UIKit

extension UIStoryboard {
  
  class func controller<T: UIViewController>(storyboard: StoryboardEnum) -> T {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
  }
  
  class func initial<T: UIViewController>(storyboard: StoryboardEnum) -> T {
    return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController() as! T
  }
  
  enum StoryboardEnum: String {
    case auth = "Auth"
    case objrecwin = "Objrecwin"

    //case profile = "Profile"
    //case previews = "Previews"
    
  }
}
