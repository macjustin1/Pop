//
//  RegisterViewController.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        self.usernameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        usernameField.tintColor = UIColor.grayColor()
        emailField.tintColor = UIColor.grayColor()
        passwordField.tintColor = UIColor.grayColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        
        if username != "" && email != "" && password != "" {
            
            // Set Email and Password for the New User.
            FIRAuth.auth()!.createUserWithEmail(email!, password: password!, completion: { result, error in
                
                if error != nil {
                    
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                }
                else {
                    
                    // Create and Login the New User with authUser
                    FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { authData, error in
                        if error != nil {
                            self.signupErrorAlert("Try again", message: "Invalid username, email, or password")
                        }
                        let user = ["email": email!]
                        PopDatabase.dataService.createNewAccount(authData!.uid, user: user)
                        self.setDisplayName(authData!, username: username!)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result?.uid, forKey: "uid")
                    
                    //Send Email Verification
                    FIRAuth.auth()?.currentUser?.sendEmailVerificationWithCompletion(nil)
                    
                    // Enter the app.
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homePage = storyboard.instantiateViewControllerWithIdentifier("Home")
                    self.presentViewController(homePage, animated: true, completion: nil)
                }
            })
            
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
        
    }
    
    func setDisplayName(user: FIRUser, username: String) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = username
        changeRequest.commitChangesWithCompletion(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    /*func signedIn(user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
    }*/
    
    func signupErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
