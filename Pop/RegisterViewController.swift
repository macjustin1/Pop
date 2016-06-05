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

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
                        let user = ["email": email!, "password": password!]
                        PopDatabase.dataService.createNewAccount(authData!.uid, user: user)
                        self.setDisplayName(authData!, username: username!)
                    })
                    
                    // Store the uid for future access - handy!
                    NSUserDefaults.standardUserDefaults().setValue(result?.uid, forKey: "uid")
                    
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
            //self.signedIn(FIRAuth.auth()?.currentUser) //error here
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
