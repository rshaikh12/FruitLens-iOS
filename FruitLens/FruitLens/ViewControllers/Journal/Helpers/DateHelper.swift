//
//  DateHelper.swift
//  FruitLens
//
//  Created by admin on 13.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import Foundation

class DateHelper {
    //convert timestamp into desired format
    static func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
        let myString = formatter.string(from: date) 
        let yourDate = formatter.date(from: myString)
  
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm:ss"
        
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
        
    }
    
}





