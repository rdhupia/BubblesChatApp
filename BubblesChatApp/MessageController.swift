//
//  ViewController.swift
//  BubblesChatApp
//
//  Created by Ravideep Dhupia on 2016-08-27.
//  Copyright © 2016 Ravideep Dhupia. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Top left corner button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(handleLogout))
        
        // Top right corner button
        let image = UIImage(named: "Speech Bubble-50")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Message Controller ViewDidAppear")
        checkIfUserIsLoggedIn()
    }
    
    // New message icon is clicked - right bar button
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        presentViewController(navController, animated: true, completion: nil)
    }
    
    // Check if user is logged in
    func checkIfUserIsLoggedIn() {
        // Get uid
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        // User is not currently logged in
        if uid == nil {
            // instead of "handleLogout()"
            // Present controller after its been loaded 0 sec. Prevents "Unbalanced calls" warning.
            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
        } else  {
            // Fetch value, be referencing Firebase database
            FIRDatabase.database().reference().child("users").child(uid!).observeEventType(.Value, withBlock: { (snapshot) in
                
                print(snapshot)
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
                }, withCancelBlock: nil)
        }
    }
    
    // Launch LoginController when logout button is pressed
    func handleLogout() {
        
        do {
            // Sign out
            try FIRAuth.auth()?.signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        presentViewController(loginController, animated: true, completion: nil)
    }

    


}

