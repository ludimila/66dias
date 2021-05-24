//
//  HabitDAO.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 21/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class HabitDAO: NSObject {
    
    var dataBase : FMDatabase?
    static private var instance: HabitDAO?
    
    private var habitsArray = Array<Habit>()
    
    var allHabits : Array<Habit> {
        get {
            return Array<Habit>(self.habitsArray)
        }
    }
   
    override init () {
        NSException(name: "Singleton", reason: "Use HabitDAO.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var pathDB = appDelegate.dbFilePath
        dataBase = FMDatabase(path: pathDB)

        self.loadAllHabits()
    }
    
    static func sharedInstance() -> HabitDAO {
        if instance == nil {
            instance = HabitDAO(singleton: true)
        }
        return instance!
    }
    
    func insert(habit : Habit) {
        
        self.dataBase?.open()
        
        var currentDate = currentDateToString()
        
        var success = self.dataBase?.executeUpdate( "INSERT INTO Habito (nomeHabito, dataCriacaoHabito, privacidade) VALUES (?,?,?)", withArgumentsInArray: [habit.name, currentDate, (habit.privacy as NSNumber).stringValue ])
        if success == false {
            println("Insert Error: \(self.dataBase!.lastErrorMessage)");
            println("Habito: nome: \(habit.name) data:\(currentDate) privacidade: \(habit.privacy)")
        } else {
            println("Salvou Habito: nome:\(habit.name) data:\(currentDate) privacidade: \(habit.privacy)")
            self.habitsArray.append(habit)
        }
        self.dataBase?.close()
        
    }
    
    func deleteById(id : NSInteger, index : NSInteger) {
        
        self.dataBase?.open()
        
        var currentDate = currentDateToString()
        
        var success = self.dataBase?.executeUpdate( "DELETE FROM Habito WHERE idHabito = ?", withArgumentsInArray: [(id as NSNumber).stringValue])
        if success == false {
            println("Delete Error: \(self.dataBase!.lastErrorMessage)");
        } else {
            self.habitsArray.removeAtIndex(index)
        }
        self.dataBase?.close()
        
    }
    
    func currentDateToString() -> String {
        return dateToString(NSDate())
    }
    
    func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return formatter.stringFromDate(date)
    }
    
    func stringToDate(stringDate : String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.locale = NSLocale(localeIdentifier: "pt_BR")
        return formatter.dateFromString(stringDate)!
    }
    
    func loadAllHabits() {
        
        self.dataBase?.open()
        
        var result : FMResultSet = self.dataBase!.executeQuery("SELECT * FROM Habito ORDER BY idHabito", withArgumentsInArray: nil)
        
        self.habitsArray = Array<Habit>()
        while(result.next()) {
            var idHabit = NSInteger(result.intForColumn("idHabito"))
            var name = result.stringForColumn("nomeHabito")!
            var totalFailure = NSInteger(result.intForColumn("totalFalhas"))
            var criationDate = stringToDate(result.stringForColumn("dataCriacaoHabito"))
            var lastFailureDate = stringToDate(result.stringForColumn("dataCriacaoHabito"))
            var privacy = NSInteger(result.intForColumn("privacidade"))
            
            var habit = Habit(id: idHabit, name: name, totalFailure: totalFailure, criationDate: criationDate, lastFailureDate: lastFailureDate, privacy: privacy)
            
            self.habitsArray.append(habit)
        }
    }
    
}
