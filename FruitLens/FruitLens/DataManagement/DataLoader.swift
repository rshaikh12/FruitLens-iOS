//
//  DataLoader.swift
//  FruitLens
//
//  Created by admin on 11.07.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import Foundation

public class DataLoader {
    @Published var fruitsData = [FruitsData]()
    
    
    init() {
        load()
    }
    
    func load(){
        if let fileLocation = Bundle.main.url(forResource: "fructose", withExtension: "json"){
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([FruitsData].self, from: data)
                
                self.fruitsData = dataFromJson
            }
            catch {
                print(error)
            }
        }
    }
    
}
