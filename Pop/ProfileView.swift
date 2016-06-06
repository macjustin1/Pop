//
//  ProfileView.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileView: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBAction func logoutPressed(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = storyboard.instantiateViewControllerWithIdentifier("MainPage")
        self.presentViewController(homePage, animated: true, completion: nil)
    }
}
