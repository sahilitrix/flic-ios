//
//  WelcomeViewController.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/11/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // if user is logged in, then dismiss the screen
                self.dismiss(animated: false, completion: nil)
            } else {
                
            }
        })
    }
    
    // hides the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
