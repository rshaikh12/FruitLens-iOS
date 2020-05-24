//
//  FirebaseEnums.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import Foundation

public enum FirestoreCollectionReference: String {
  case users = "Users"
  case conversations = "Conversations"
  //case messages = "Messages"
}

public enum FirestoreResponse {
  case success
  case failure
}
