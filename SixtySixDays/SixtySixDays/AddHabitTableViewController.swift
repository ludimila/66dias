//
//  AddHabitTableViewController.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 21/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class AddHabitTableViewController: UITableViewController {

    @IBOutlet weak var nameTxtLabel: UITextField!
    @IBOutlet weak var privacySegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveClick(sender: AnyObject) {
        var newHabit = Habit(name: self.nameTxtLabel.text, privacy: self.privacySegmented.selectedSegmentIndex)
        HabitDAO.sharedInstance().insert(newHabit)
        setNotification(newHabit)
        self.back()
    }
    
    func back() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1
    }

    func setFireDate() -> NSDate{
        let calendar: NSCalendar = NSCalendar.autoupdatingCurrentCalendar()
        let componentsForFireDate = NSDateComponents()
        componentsForFireDate.minute = 1
        
        return calendar.dateByAddingComponents(componentsForFireDate, toDate: NSDate(), options: nil)!
    }
    
    func setNotification(habit: Habit){
        var notification: UILocalNotification = UILocalNotification()
        notification.alertBody = "Você se lembrou do seu hábito:\(habit.name) hoje?"
        notification.fireDate = self.setFireDate()
        notification.timeZone = NSTimeZone.localTimeZone()
        notification.repeatInterval = NSCalendarUnit.CalendarUnitDay
        notification.repeatCalendar = NSCalendar.currentCalendar()
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}