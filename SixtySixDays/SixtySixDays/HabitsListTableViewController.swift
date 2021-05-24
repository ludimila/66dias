//
//  HabitsListTableViewController.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 21/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class HabitsListTableViewController: UITableViewController {

    var habitsArray = Array<Habit>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        habitsArray = HabitDAO.sharedInstance().allHabits        
        self.tableView.reloadData()
    }
    
    @IBAction func addClick(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "HabitCreation", bundle: nil).instantiateInitialViewController() as! UIViewController
        
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return habitsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        var currentHabit = habitsArray[indexPath.row]
        
        cell.textLabel?.text = currentHabit.name
        cell.detailTextLabel?.text = NSLocalizedString("DAY", comment: "Day") + " " + (currentHabit.currentDay as NSNumber).stringValue
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            showDeleteAlert(indexPath)
        }
    }
    
    func showDeleteAlert(indexPath: NSIndexPath) {

        var habitToBeDeleted = self.habitsArray[indexPath.row]
        
        var title = NSLocalizedString("DELETE", comment: "DELETE")
        title += " \(habitToBeDeleted.name)"
        var message = NSLocalizedString("DELETE_CONFIRMATION", comment: "DELETE CONFIRMATION")
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        var confirmAction = UIAlertAction(title: NSLocalizedString("CONFIRM", comment: "CONFIRM"), style: UIAlertActionStyle.Default) {
            UIAlertAction in
            HabitDAO.sharedInstance().deleteById(habitToBeDeleted.id, index: indexPath.row)
            self.habitsArray.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        var cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "CANCEL"), style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            self.tableView.setEditing(false, animated: true)
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    

}
