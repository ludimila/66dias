//
//  PreRegisterHabitsTableViewController.swift
//  SixtySixDays
//
//  Created by Ludimila da Bela Cruz on 22/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class PreRegisterHabitsTableViewController: UITableViewController {
    
    
    var habits:[String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.habits.count
    }

   override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.habits[indexPath.row]
        
        return cell
    }

    
}
