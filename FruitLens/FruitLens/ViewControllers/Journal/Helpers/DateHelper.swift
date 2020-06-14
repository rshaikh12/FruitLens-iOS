//
//  DateHelper.swift
//  FruitLens
//
//  Created by admin on 13.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            //let myString = formatter.string(from: Date()) // string purpose I add here
        let myString = formatter.string(from: date) // string purpose I add here
            // convert your string to date
        let yourDate = formatter.date(from: myString)
            //then again set the date format which type of output you need
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm:ss"
            // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
        
    }
    
}





