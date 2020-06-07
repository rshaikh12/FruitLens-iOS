//
//  Food.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import GRDB

class Food: Record {

    var id: Int64
    var name: String
    var timestamp: Int64
    var fructose_value: Int64
    
    override class var databaseTableName: String {
        return "processed_foods"
    }
    
    enum Columns: String, ColumnExpression {
        case id, name, timestamp, fructose_value
    }
    
    required init(row: Row) {
        id = row[Columns.id]
        name = row[Columns.name]
        timestamp = row[Columns.timestamp]
        fructose_value = row[Columns.fructose_value]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.timestamp] = timestamp
        container[Columns.fructose_value] = fructose_value
    }
    
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    static func getAll() -> [Food] {
        do {
            return try database.read { db in
                return try Food.fetchAll(db)
            }
        } catch let error {
            print(error.localizedDescription)
            return []
        }

    }
}
