//
//  FireCodable.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import UIKit

protocol BaseCodable: class {
  
  var id: String { get set }
  
}

protocol FireCodable: BaseCodable, Codable {
  
  var id: String { get set }
  
}

protocol FireStorageCodable: FireCodable {
  
  var profilePic: UIImage? { get set }
  var profilePicLink: String? { get set }
  
}
