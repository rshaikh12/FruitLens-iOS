//
//  OptionalExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import Foundation
//define isNone and isSome
extension Optional {
  var isNone: Bool {
    return self == nil
  }
  
  var isSome: Bool {
    return self != nil
  }
}
