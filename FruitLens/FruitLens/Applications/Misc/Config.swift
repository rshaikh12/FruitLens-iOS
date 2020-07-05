//
//  Config.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 Emre Can Bolat. All rights reserved.
//

import UIKit

class Config {

    static let preferences = UserDefaults.standard
    static var currentUser: ObjectUser?
    static var dailyLimitSet: Bool = false
    static var dailyLimit: Int = 0
    
    static func synced(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    static func syncedR<T>(_ lock: Any, closure: ()->T) -> T {
        objc_sync_enter(lock)
        let retVal: T = closure()
        objc_sync_exit(lock)
        return retVal
    }
    
    static func clearConfig() {
        for key in preferences.dictionaryRepresentation().keys {
            preferences.removeObject(forKey: key.description)
        }
        self.currentUser = nil
    }
    
    static func save() {
        do {
            try preferences.set(NSKeyedArchiver.archivedData(withRootObject: currentUser, requiringSecureCoding: false), forKey: "currentUser")
        } catch let error {
            print(error.localizedDescription)
        }
        
        preferences.set(dailyLimitSet, forKey: "dailyLimitSet")
        preferences.set(dailyLimit, forKey: "dailyLimit")
        
        preferences.synchronize()
    }
    
    static func readConfig() {
        
        do {
            if let currentUserObject = preferences.value(forKey: "currentUser") as? NSData {
                currentUser = try NSKeyedUnarchiver.unarchivedObject(ofClass: ObjectUser.self, from: currentUserObject as Data)
            }
            dailyLimitSet = preferences.value(forKey: "dailyLimitSet") as? Bool ?? false
            dailyLimit = preferences.value(forKey: "dailyLimit") as? Int ?? 0
            
        } catch let error {
            print(error.localizedDescription)
        }
        

    }
    
    static func getCurrentUser() -> ObjectUser? {
        return currentUser ?? nil
    }
    
    static func setCurrentUser(user: ObjectUser) {
        self.currentUser = user
        self.save()
    }
    
    static func isLoggedIn() -> Bool {
        return (Config.getCurrentUser() != nil)
    }
    
    static func hasDailyLimitSet() -> Bool {
        return dailyLimitSet 
    }
    
    static func getDailyLimit() -> Int {
        return dailyLimit 
    }
    
    static func setDailyLimit(_ limit: Int) {
        self.dailyLimit = limit
    }
    
    static func setHasDailyLimit(_ hasLimit: Bool) {
        self.dailyLimitSet = hasLimit
        }
}
