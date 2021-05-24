//
//  Habit.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 20/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class Habit: NSObject {
 
    let CREATION_DAY = 1
    
    var id = NSInteger()
    var name = String()
    var totalFailure : NSInteger = 0
    var criationDate = NSDate()
    var lastFailureDate = NSDate()
    var privacy : NSInteger = 0

    var currentDay : NSInteger {
        get {
            return getCurrentDay()
        }
    }
    
    init(name: String, privacy: NSInteger) {
        self.name = name
        self.privacy = privacy
    }
    
    init (id: NSInteger, name: String, totalFailure: NSInteger, criationDate: NSDate, lastFailureDate: NSDate, privacy: NSInteger){
        self.id = id
        self.name = name
        self.totalFailure = totalFailure
        self.criationDate = criationDate
        self.lastFailureDate = lastFailureDate
        self.privacy = privacy
    }
    
    func getCurrentDay() -> NSInteger {
        let formatter = NSDateFormatter()
        formatter.timeStyle =  NSDateFormatterStyle.MediumStyle
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        
        let calendar = NSCalendar.currentCalendar()
        let unit : NSCalendarUnit = .CalendarUnitDay
        
        var today = NSDate()
        
        // Linhas para testes com a data, serão removidas
        let end = "25-07-2015"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let endDate: NSDate = dateFormatter.dateFromString(end)!
        // Fim linha para testes
        
        let components = calendar.components(unit, fromDate: self.criationDate, toDate: today, options: nil)
        return components.day + CREATION_DAY
    }
    
}
