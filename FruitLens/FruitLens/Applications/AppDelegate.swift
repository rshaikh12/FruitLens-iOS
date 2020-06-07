//
//  AppDelegate.swift
//  FruitLens
//
//  Created by Christoph Weber on 18.05.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GRDB

var database: DatabaseQueue!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        try! setupDatabase(application)
        FirebaseApp.configure()
        Config.readConfig()
        return true
    }
    
    private func setupDatabase(_ application: UIApplication) throws {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        database = try Database.openDatabase(atPath: databaseURL.path)
        database.setupMemoryManagement(in: application)
    }

}
