//
//  LoginController+handlers.swift
//  BubblesChatApp
//
//  Created by Ravideep Dhupia on 2016-09-06.
//  Copyright © 2016 Ravideep Dhupia. All rights reserved.
//

import UIKit
import Firebase

extension LoginController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Registration
    // Register button clicked
    func handleRegister() {
        // guard stmt useful for forms and validations
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        // Call Firebase Auth authentication function
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // Save Successfully authenticated user
            
            // Firabase requires name for image to store
            let imageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().referenceForURL("gs://bubbleschat-c19a3.appspot.com").child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    // metadata cotains url
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        // Create dictionary of values
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid, values: values)
                    }
                })
                
            }
            
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().referenceFromURL("https://bubbleschat-c19a3.firebaseio.com/")
        // Create child reference - users node
        let usersRef = ref.child("users").child(uid)

        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
            // Slide scene down if registration successful
            self.dismissViewControllerAnimated(true, completion: nil)
            print("Saved user successfully added into Firebase db")
        })  // specify a dictionary
    }

    // MARK: Profile Image
    func handleSelectProfileImageView() {
        // Bring up the image picker
        let picker = UIImagePickerController()
        
        picker.delegate = self
        // Allow cropping and choosing of images selected
        picker.allowsEditing = true
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // Handle selection of an image
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Capture selected image
        var selectedImage: UIImage?
        print(info)
        // Use print(info) to figure out what's inside info. Breakpoint at print(info). Right click info in debugger, Print description. Find OriginalImageValue
        // If edited image available, give priority, else select original image
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImage = editedImage as? UIImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImage = originalImage as? UIImage
        }
        
        if (selectedImage != nil) {
           profileImageView.image = selectedImage
        }
        
        // Dismiss controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Handle cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print(123)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}