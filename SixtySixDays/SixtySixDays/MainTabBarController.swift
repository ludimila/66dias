//
//  MainTabBarController.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 22/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var profileSB = UIViewController()
    var habitsSB = UINavigationController()
    var infoSB = UIViewController()
    var habitsArray = Array<Habit>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileSB = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! UIViewController
        
        habitsSB = UIStoryboard(name: "HabitsList", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        infoSB = UIStoryboard(name: "Info", bundle: nil).instantiateInitialViewController() as! UIViewController
        
        checkIfHasHabit()
        
        self.viewControllers = [profileSB, habitsSB, infoSB]
        
        self.selectedIndex = 1
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
        if item.title! == "Hábitos" {
            checkIfHasHabit()
        }
    }

    func checkIfHasHabit() {
        habitsArray = HabitDAO.sharedInstance().allHabits
        
        if habitsArray.count == 0 {
            var vc = UIStoryboard(name: "HabitsList", bundle: nil).instantiateViewControllerWithIdentifier("InitViewController") as! UIViewController
            habitsSB.pushViewController(vc, animated: false)
        }
    }

}
