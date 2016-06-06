//
//  ProfileView.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        userLabel.text = "@" + (FIRAuth.auth()?.currentUser?.displayName)!
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = storyboard.instantiateViewControllerWithIdentifier("MainPage")
        self.presentViewController(homePage, animated: true, completion: nil)
    }
    @IBAction func addPhoto(sender: AnyObject) {
        //choose profile image
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //profileImageView.contentMode = .ScaleAspectFit
            profileImageView.image = pickedImage
            profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
            
            //save photo as current users' profile pic to database
            var data = UIImageJPEGRepresentation(pickedImage, 0.1)!
            let base64String = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) //encodes image to a string
            //let user: NSDictionary = ["photoBase64":base64String]
            let user = FIRAuth.auth()?.currentUser
            if let user = user {
                let changeRequest = user.profileChangeRequest()
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
