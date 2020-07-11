//
//  UserManager.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//
//user authetification in firebase
import FirebaseAuth

//UserManager for ObjectUser
class UserManager {
  
  private let service = FirestoreService()
  
  func currentUserID() -> String? {
    return Auth.auth().currentUser?.uid
  }
  
  func currentUserData(_ completion: @escaping CompletionObject<ObjectUser?>) {
    guard let id = Auth.auth().currentUser?.uid else { completion(nil); return }
    let query = FirestoreService.DataQuery(key: "id", value: id, mode: .equal)
    service.objectWithListener(ObjectUser.self, parameter: query, reference: .init(location: .users), completion: { users in
      completion(users.first)
    })
  }
  //firebase login
  func login(user: ObjectUser, completion: @escaping CompletionObject<(AuthDataResult?, FirestoreResponse)>) {
    guard let email = user.email, let password = user.password else { completion((nil, .failure)); return }
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if error.isNone {
        completion((result, .success))
        return
      }
      completion((nil, .failure))
    }
  }
  //firebase register
  func register(user: ObjectUser, completion: @escaping CompletionObject<FirestoreResponse>) {
    guard let email = user.email, let password = user.password else { completion(.failure); return }
    Auth.auth().createUser(withEmail: email, password: password) {[weak self] (reponse, error) in
      guard error.isNone else { completion(.failure); return }
      user.id = reponse?.user.uid ?? UUID().uuidString
      self?.update(user: user, completion: { result in
        completion(result)
      })
    }
  }
  
  func update(user: ObjectUser, completion: @escaping CompletionObject<FirestoreResponse>) {
    FirestorageService().update(user, reference: .users) { response in
      switch response {
      case .failure: completion(.failure)
      case .success:
        FirestoreService().update(user, reference: .init(location: .users), completion: { result in
          completion(result)
        })
      }
    }
  }

  //userData in firebase
  func userData(for id: String, _ completion: @escaping CompletionObject<ObjectUser?>) {
    let query = FirestoreService.DataQuery(key: "id", value: id, mode: .equal)
    FirestoreService().objects(ObjectUser.self, reference: .init(location: .users), parameter: query) { users in
      completion(users.first)
    }
  }
  
  @discardableResult static func logout() -> Bool {
    do {
      try Auth.auth().signOut()
      return true
    } catch {
      return false
    }
  }
}
