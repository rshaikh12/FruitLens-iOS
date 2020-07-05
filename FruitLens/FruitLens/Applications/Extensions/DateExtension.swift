//
//  DateExtension.swift
//  FruitLens
//
//  Created by Emre Can Bolat on 07.06.20.
//  Copyright © 2020 ChristophWeber. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    var endOfWeek: Date {
        let sunday = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        return Calendar.current.date(byAdding: .day, value: 7, to: sunday!)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfYear: Date {
        let year = Calendar.current.component(.year, from: startOfDay)
        return Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
    }
    
    var endOfYear: Date {
        let year = Calendar.current.component(.year, from: Date())
        let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))
        
        return Calendar.current.date(byAdding: .nanosecond, value: -1, to: firstOfNextYear!)!
    }
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func toSeconds() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
    
}
