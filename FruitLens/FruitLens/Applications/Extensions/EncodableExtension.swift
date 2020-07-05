//
//  EncodableExtension.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import Foundation

extension Encodable {
  var values: [String: Float64]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Float64] }
  }
}
