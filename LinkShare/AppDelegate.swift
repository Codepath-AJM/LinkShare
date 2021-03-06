//
//  AppDelegate.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/8/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func authenticationComplete() {
        
        // set user from defaults and TRY to set currentUser - fail gracefully
        guard let data = UserDefaults.init(suiteName: "group.com.linkshare")!.object(forKey: "current_user") as? Data else { return }
        
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if  dictionary != nil {
            User.currentUser = User(dictionary: dictionary!)
        }
        
        // send user to app
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "mainTabBarController")
        window?.rootViewController = tabBarController
    }
    
    func returnToAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let authVC = storyboard.instantiateInitialViewController() {
            window?.rootViewController = authVC
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        
        // User is signed in, otherwise let Storyboard take user to the sign in screen
        if FIRAuth.auth()?.currentUser != nil {
            self.authenticationComplete()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

