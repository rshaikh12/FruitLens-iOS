//
//  DictionaryExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import Foundation

//converting between JSON and the equivalent Foundation objects (Apple Developer)

extension Dictionary {
  
  var data: Data? {
    return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }
}
