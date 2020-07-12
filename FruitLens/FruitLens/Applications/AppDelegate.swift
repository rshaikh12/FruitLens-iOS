//
//  AppDelegate.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 18.05.20.
//  Copyright © 2020 Emre Can Bolat. All rights reserved.
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


    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // fatalError() causes the application to generate a crash log and terminate.
                // Should be replaced 

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
