//
//  ProfileViewController.swift
//  SixtySixDays
//
//  Created by Matheus Godinho on 7/22/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var navItemLogout = UIBarButtonItem()
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgProfilePicture: UIImageView!

    @IBOutlet weak var friendsTableView: UITableView!
    var friendsArray = Array<NSDictionary>()
    
    let FBLoginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        self.friendsTableView.separatorStyle = .None
        self.friendsTableView.layoutMargins = UIEdgeInsetsZero
        self.friendsTableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.nameLabel.textColor = UIColor(netHex:0x30FDE0)
        
        navItemLogout = UIBarButtonItem(title: "LogOut", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logOutClick"))
        
        UserDAO.sharedInstance().currentUser = User(name: "Seu nome")
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            UserDAO.sharedInstance().selectUser()
            self.nameLabel.text = UserDAO.sharedInstance().currentUser.name
            self.hideUserInfo(false)
            
            //Lembrar de pegar a foto da pasta documents, nao pelo link
            var pictureURL : NSURL = NSURL(string: UserDAO.sharedInstance().currentUser.photoName)!
            self.imgProfilePicture.image = UIImage(data: NSData(contentsOfURL: pictureURL)!)
            
            //Se a internet estiver ativada...
            self.getFBUserFriends()
            
        } else {
            self.hideUserInfo(true)
        }
        self.activityIndicator.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.hideUserInfo(false)
        } else {
            self.hideUserInfo(true)
        }
    }
    
    @IBAction func loginClick(sender: AnyObject) {
        FBLoginManager.logInWithReadPermissions(["public_profile","user_friends"], handler: { (response:FBSDKLoginManagerLoginResult!, error: NSError!) in
            if error != nil{
                let alert = UIAlertView(title: "Erro", message: "\(error.description)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else if response.isCancelled{
                let alert = UIAlertView(title: "Login cancelado", message: "O seu Login foi cancelado", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else {
                self.getFBUserData()
            }
        })
    }
    
    func logOutClick() {
        FBLoginManager.logOut()
        self.hideUserInfo(true)
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, friends"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    
                    println("Usuario: \(result)")
                    
                    self.nameLabel.text = result.valueForKey("name") as? String
                    
                    // Get the user's profile picture.
                    var picture = result.objectForKey("picture") as! NSDictionary
                    var data = picture.objectForKey("data") as! NSDictionary
                    var url = data.objectForKey("url") as! String
                    
                    var pictureURL : NSURL = NSURL(string: url)!
                    
                    self.imgProfilePicture.image = UIImage(data: NSData(contentsOfURL: pictureURL)!)
                    
                    var user = User(name: (result.valueForKey("name") as! String), photoName: url)
                    
                    UserDAO.sharedInstance().insert(user)
                    
                    var friends: NSDictionary = result.valueForKey("friends") as! NSDictionary
                    println("amigos:\n \(friends)")
                    
                    var dataFriends: Array<NSDictionary> = friends.valueForKey("data") as! Array<NSDictionary>
                    UserDAO.sharedInstance().currentUser.friends = dataFriends
                    
                    var friend: AnyObject? = dataFriends[0]
                    
                    var id = friend!.valueForKey("id") as! String
                    var name = friend!.valueForKey("name") as! String
                    
                    println(" user 1\n \(id) \(name)")
                    
                    self.hideUserInfo(false)
                    self.activityIndicator.hidden = true
                    self.activityIndicator.stopAnimating()
                    
                } else {
                    println("\(error)")
                }
            })
        }
    }
    
    func getFBUserFriends() {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if error == nil {
                
                var friends: NSDictionary = result.valueForKey("friends") as! NSDictionary

                var dataFriends: Array<NSDictionary> = friends.valueForKey("data") as! Array<NSDictionary>
                
                self.friendsArray = dataFriends
                var friend: AnyObject? = dataFriends[0]
                self.friendsTableView.reloadData()
            } else {
                println("\(error)")
            }
        })
    }
    
    func hideUserInfo(shouldHide : Bool) {
        self.imgProfilePicture.hidden = shouldHide
        self.nameLabel.hidden = shouldHide
        self.btnLogin.hidden = !shouldHide
        self.navigationItem.rightBarButtonItem = shouldHide ? nil : navItemLogout
        self.friendsTableView.hidden = shouldHide
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.friendsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomCell
        
        var currentFriend : NSDictionary = self.friendsArray[indexPath.row]
        
        cell.friendName.text = currentFriend.objectForKey("name") as? String
        
        var idFriend = currentFriend.objectForKey("id") as? String
        
        var urlPhoto = "http://graph.facebook.com/\(idFriend!)/picture?type=large"
        
        var pictureURL : NSURL = NSURL(string: urlPhoto)!
        cell.friendImage.image = UIImage(data: NSData(contentsOfURL: pictureURL)!)
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    /*func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
    }*/
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFriend" {
            var friendVC : FriendProfileViewController = segue.destinationViewController as! FriendProfileViewController
            var index = self.friendsTableView.indexPathForSelectedRow()
            var currentFriend = self.friendsArray[index!.row]
            friendVC.friendName = currentFriend.objectForKey("name") as! String
            friendVC.friendPhoto = (self.friendsTableView.cellForRowAtIndexPath(index!) as! CustomCell).friendImage.image!
        }
    }
}
