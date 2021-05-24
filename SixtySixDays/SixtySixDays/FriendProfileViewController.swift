//
//  FriendProfileViewController.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 25/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var goalsArray = Array<Habit>()
    var friendName = String()
    var friendPhoto = UIImage()
    
    @IBOutlet weak var labelFriendName: UILabel!
    @IBOutlet weak var imageViewFriendPhoto: UIImageView!
     @IBOutlet weak var goalsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        self.goalsTableView.separatorStyle = .None
        self.goalsTableView.layoutMargins = UIEdgeInsetsZero
        self.goalsTableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.labelFriendName.textColor = UIColor(netHex:0x30FDE0)
        self.labelFriendName.text = self.friendName
        self.imageViewFriendPhoto.image = friendPhoto
        
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goalsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var currentGoal : Habit = self.goalsArray[indexPath.row]
        
        cell.textLabel?.text = currentGoal.name
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
