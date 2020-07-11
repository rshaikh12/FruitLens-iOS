//
//  DictionaryExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright Apple Developer
//


import Foundation

//converting between JSON and the equivalent Foundation objects for Firebase communication

extension Dictionary {
  
  var data: Data? {
    return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
  }
}
