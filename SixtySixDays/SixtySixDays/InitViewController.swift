//
//  InitViewController.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 23/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bem-vindo"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)

    }
    
    @IBAction func addClick(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "HabitCreation", bundle: nil).instantiateInitialViewController() as! UIViewController
        self.navigationController?.pushViewController(storyboard, animated: false)
    }

}
