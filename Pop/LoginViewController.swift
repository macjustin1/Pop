//
//  LoginViewController.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //if we have the uid stored, the user is already logged in
        /*if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil {
            self.performSegueWithIdentifier("HomePage", sender: nil)
        }*/
    }
    
    @IBAction func tryLogin(sender: AnyObject) {
        
        let email = emailField.text
        let password = passwordField.text
        
        if email != "" && password != "" {
            
            // Login with the Firebase's authUser method
            FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { authData, error in
                
                if error != nil {
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                } else {
                    
                    // Be sure the correct uid is stored.
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData!.uid, forKey: "uid")
                    
                    // Enter the app!
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homePage = storyboard.instantiateViewControllerWithIdentifier("Home")
                    self.presentViewController(homePage, animated: true, completion: nil)
                }
            })
            
        } else {
            
            // There was a problem
            
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
        }
    }
    
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
