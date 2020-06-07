//
//  Database.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import GRDB

struct Database {
    
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        let dbQueue = try DatabaseQueue(path: path)
        try migrator.migrate(dbQueue)
        
        return dbQueue
    }
    
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1") { db in
            try db.create(table: "processed_foods") { t in
                t.column("id", .integer).primaryKey()
                t.column("name", .text)
                t.column("fructose_value", .integer)
                t.column("timestamp", .integer)
            }
        }
        
        return migrator
    }
    
    static func deleteTables() throws {
        try database.inTransaction { db in
            try Food.deleteAll(db)
            
            return .commit
        }
    }

}
