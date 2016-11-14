//
//  NewsfeedTableViewController.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/11/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import UIKit
import Firebase

class NewsfeedTableViewController: UITableViewController {
    
    struct Storyboard {
        static let showWelcome = "ShowWelcomeViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //check if the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // signed in
            } else {
                // not signed in
                // so show welcome screen
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
        
        
    }

    
}
