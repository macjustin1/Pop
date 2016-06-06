//
//  InitialViewController.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitialViewController: UIViewController {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && FIRAuth.auth()?.currentUser?.uid != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = storyboard.instantiateViewControllerWithIdentifier("Home")
            self.presentViewController(homePage, animated: true, completion: nil)
        }
    }
}
