//
//  AppDelegate.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/6/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import UIKit
//  installing FireBase
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // configuring Firebase
        FIRApp.configure()
        
        //let dummyUser = User(uid: "123", username: "myUserNameDummy", fullName: "My Dummy User", bio: "My Dummy User", website: "My Dummy User", follows: [], followedBy: [], profileImage: UIImage(named: "1")) //the image in assets named 1 is this
        
        //dummyUser.save { (error) in
           // print(error)
       // }
        

        return true
    }

    

}

