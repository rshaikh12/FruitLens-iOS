//
//  NSObjectExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import Foundation

extension NSObject {
  class var className: String {
    return String(describing: self.self)
  }
}
