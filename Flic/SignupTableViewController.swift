//
//  SignupTableViewController.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/11/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import UIKit
import Firebase

class SignupTableViewController: UITableViewController  {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePickerHelper: ImagePickerHelper!
    var profileImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create New Account"
        
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        // to allow user to proceed to next text field by hitting return on keyboard *Built in on Android*
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func createNewAccountDidTap() {
        // create a new account
        // save the user data, take a photo
        // login the user
        
        if emailTextField.text != ""
            && (passwordTextField.text?.characters.count)! > 8 // min password length is 8
            && (usernameTextField.text?.characters.count)! > 6 // min username length is 6
            && fullNameTextField.text != ""
            && profileImage != nil // requires user to put profile image, for now
        {
            let username = usernameTextField.text!
            let fullName = fullNameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            // create user in Firebase -> only for authentification, doesn't SAVE email, password, etc.
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firUser, error) in
                if error != nil {
                    
                    // report error to user
                    self.createUIAlertView(message: (error?.localizedDescription)!)
                    
                } else if let firUser = firUser {
                   // save the user details // can get unique id from firebase user that is created
                    let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", follows: [], followedBy: [], profileImage: self.profileImage)
                    newUser.save(completion: { (error) in
                        if error != nil {
                            //report
                            self.createUIAlertView(message: (error?.localizedDescription)!)
                        } else
                        {
                            //login user
                            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                                if let error = error {
                                    // report error
                                    self.createUIAlertView(message: error.localizedDescription)
                                } else {
                                    self.dismiss(animated: true, completion: nil) //dismiss screen and show newsfeed
                                }
                            })
                        }
                    })
                }
            })
        } else
        {
            self.createUIAlertView(message: "Invalid information");
        }
        
    }

    @IBAction func backDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ChangeProfilePhotoDidTap(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
    }
    
    func createUIAlertView (message: String) {
        let alert = UIAlertController(title: "Sign up failed!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



// equivalent to 'extends' in class header in java
extension SignupTableViewController : UITextFieldDelegate
{
    // method to transition to next text field when return is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField
        {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            createNewAccountDidTap() // if user hits return on last textfield, sign up
        }
        return true
    }
}
