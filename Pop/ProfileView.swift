//
//  ProfileView.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage


class ProfileView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        if let url = FIRAuth.auth()?.currentUser?.photoURL?.absoluteString {
            let picRef = FIRStorage.storage().referenceForURL(url)
            picRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    print("Could not download picture")
                }
                else {
                    print("Successfully downloaded picture")
                    let profileImage: UIImage! = UIImage(data: data!)
                    self.profileImageView.image = profileImage
                    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
                    self.profileImageView.clipsToBounds = true
                }
            }
        }
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
            //let base64String = data.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) //encodes image to a string
            //let user: NSDictionary = ["photoBase64":base64String]
            let storageRef = FIRStorage.storage().reference()
            let imageRef = storageRef.child("images/profile.jpg")
            let uploadTask = imageRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    print(error)
                }
                else {
                    let downloadURL = metadata!.downloadURL()
                    let user = FIRAuth.auth()?.currentUser
                    if let user = user {
                        let changeRequest = user.profileChangeRequest()
                        changeRequest.photoURL = downloadURL
                        changeRequest.commitChangesWithCompletion { error in
                            if let error = error {
                                print("Error changing profile picture")
                            } else {
                                print("Profile updated")
                            }
                        }
                    }
                }
            }
            uploadTask.resume()
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
