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
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var PopLabel: UILabel!
    override func viewDidLoad() {
        /*let file = NSBundle.mainBundle().pathForResource("fireworks", ofType: "gif")
        let gif = NSData(contentsOfFile: file!)
        let frame = CGRect(x: -60, y: 0, width: self.view.frame.size.width*2, height: self.view.frame.size.height*150)
        let webViewBG = UIWebView(frame: frame)
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false
        webViewBG.scalesPageToFit = true
        self.view.addSubview(webViewBG)
        
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        self.view.addSubview(filter)
        
        
        /*loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 2
        
        registerButton.layer.borderColor = UIColor.whiteColor().CGColor
        registerButton.layer.borderWidth = 2*/
        
        self.view.addSubview(PopLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)*/
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && FIRAuth.auth()?.currentUser?.uid != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = storyboard.instantiateViewControllerWithIdentifier("Home")
            self.presentViewController(homePage, animated: true, completion: nil)
        }
    }
}
