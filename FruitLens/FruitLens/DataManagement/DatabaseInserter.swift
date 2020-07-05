//
//  DatabaseInserter.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 05.07.20.
//  Copyright © 2020 Emre Can Bolat. All rights reserved.
//

import GRDB

struct DatabaseInserter {
    
    static func addFood(name: String, fructoseValue: Float64) {
        let food = Food(name: name, fructose_value: fructoseValue)
        do {
            try database.write { db in
                try food.save(db)
            }
        } catch let e {
            print("Could not save food! \(e.localizedDescription)")
        }
    }
    
}


