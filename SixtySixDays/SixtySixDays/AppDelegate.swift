//
//  AppDelegate.swift
//  SixtySixDays
//
//  Created by Beatriz Rezener Dourado Matos on 18/07/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let DATABASE_RESOURCE_NAME = "ssd"
    let DATABASE_RESOURCE_TYPE = "sqlite"
    let DATABASE_FILE_NAME = "ssd.sqlite"
    
    var window: UIWindow?
    var dbFilePath: String = String()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.customizeNavBar()
        
        if !self.initializeDB() {
            println("Falha ao copiar o Banco de Dados.")
        }
        
        println(dbFilePath)
        
        FBSDKLoginButton.classForCoder()
        FBSDKProfilePictureView.classForCoder()
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func customizeNavBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().translucent = true
        UINavigationBar.appearance().tintColor = UIColor(netHex:0x30FDE0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(netHex:0x30FDE0)]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
    }
    
    func initializeDB() -> Bool {
        let documentFolderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let dbfile = "/" + DATABASE_FILE_NAME;
        
        self.dbFilePath = documentFolderPath.stringByAppendingString(dbfile)
        
        let filemanager = NSFileManager.defaultManager()
        if (!filemanager.fileExistsAtPath(dbFilePath) ) {
            
            let backupDbPath = NSBundle.mainBundle().pathForResource(DATABASE_RESOURCE_NAME, ofType: DATABASE_RESOURCE_TYPE)
            
            if (backupDbPath == nil) {
                return false
            } else {
                var error: NSError?
                let copySuccessful = filemanager.copyItemAtPath(backupDbPath!, toPath:dbFilePath, error: &error)
                if !copySuccessful {
                    println("copy failed: \(error?.localizedDescription)")
                    return false
                }
            }
            println("Banco de dados criado com sucesso.")
        }
        return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}