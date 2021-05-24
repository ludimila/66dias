//
//  PreRegisterGoalsViewController.swift
//  SixtySixDays
//
//  Created by Ludimila da Bela Cruz on 21/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit


class PreRegisterGoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    private var tableData = []
    private var habitArray = [String]()
    private var dictionaryCategories: NSDictionary!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let path: String!

        path = NSBundle.mainBundle().pathForResource("categories", ofType: "plist")
        self.tableData = NSArray(contentsOfFile:path)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell: PreRegisterGoalsCollectionViewCell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PreRegisterGoalsCollectionViewCell
        
        self.dictionaryCategories = self.tableData[indexPath.row] as! NSDictionary
        
        let categoryName: String? = self.dictionaryCategories["category"] as? String
        let imageCategory: String? = self.dictionaryCategories["imageCategory"] as? String
        
        println("\(habitArray)")
        
        let image = UIImage(named: imageCategory!)
        
        cell.nameCategory.text = categoryName
        cell.imageCategory.image = image
        
      // println("Eu sou da celula\(indexPath.row)")
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showHabits"{
            
            let habitsTableView = (segue.destinationViewController as! PreRegisterHabitsTableViewController)
            
                habitsTableView.habits = []
                habitsTableView.habits = self.habitArray
            
      }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.dictionaryCategories = self.tableData[indexPath.row] as! NSDictionary
        self.habitArray = (self.dictionaryCategories["arrayHabits"] as? Array<String>)!
       
        println("Eu sou o do did \(indexPath.row)")
        self.performSegueWithIdentifier("showHabits", sender: self)
    }
}