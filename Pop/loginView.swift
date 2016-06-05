//
//  loginView.swift
//  Pop
//
//  Created by Justin Mac on 5/31/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit

var username : String = ""

class loginView: UIViewController {

    
    @IBOutlet weak var textField: UITextField!
    @IBAction func enterPressed(sender: AnyObject) {
        print("Goes into function")
        username = textField.text!
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
