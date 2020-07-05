//
//  ObjectUser.swift
//  FruitLense
//
//  Created by Christoph Weber on 24.05.20.
//  Copyright © 2020 Christoph. All rights reserved.
//


import UIKit

class ObjectUser: NSObject, FireStorageCodable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
  
    var id = UUID().uuidString
    var name: String?
    var email: String?
    var profilePicLink: String?
    var profilePic: UIImage?
    var password: String?
  
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(profilePicLink, forKey: .profilePicLink)
    }
  
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: CodingKeys.id.rawValue) as! String
        self.name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        self.email = aDecoder.decodeObject(forKey: CodingKeys.email.rawValue) as? String
        self.profilePicLink = aDecoder.decodeObject(forKey: CodingKeys.profilePicLink.rawValue) as? String
    }
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: CodingKeys.id.rawValue)
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(email, forKey: CodingKeys.email.rawValue)
        aCoder.encode(profilePicLink, forKey: CodingKeys.profilePicLink.rawValue)
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        profilePicLink = try container.decodeIfPresent(String.self, forKey: .profilePicLink)
    }
}

extension ObjectUser {
  private enum CodingKeys: String, CodingKey {
    case id
    case email
    case name
    case profilePicLink
  }
}
