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
            getUserAndSetNavBarTitle()
        }
    }
    
    // fetch user and set nav bar title
    func getUserAndSetNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        // Fetch value, be referencing Firebase database
        FIRDatabase.database().reference().child("users").child(uid).observeEventType(.Value, withBlock: { (snapshot) in
            
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                // self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.setValuesForKeysWithDictionary(dictionary)
                self.setNavBarWithUser(user)
            }
            
            }, withCancelBlock: nil)
    }
    
    // Set up nav bar with username and profile pic
    func setNavBarWithUser(user: User) {
        
        // Include three views in the title
        let titleV = UIView()
        titleV.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleV.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set aspect ratio
        profileImageView.contentMode = .ScaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCache(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        // iOS 9 contstaints: x, y, width, height
        profileImageView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(40).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(40).active = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)    // Always add before anchors, hierarchy issue
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for lable: x, y, width, height
        nameLabel.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor, constant: 8).active = true
        nameLabel.centerYAnchor.constraintEqualToAnchor(profileImageView.centerYAnchor).active = true
        nameLabel.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        nameLabel.heightAnchor.constraintEqualToAnchor(profileImageView.heightAnchor).active = true
        
        // Center container view inside TitleV
        containerView.centerXAnchor.constraintEqualToAnchor(titleV.centerXAnchor).active = true
        containerView.centerYAnchor.constraintEqualToAnchor(titleV.centerYAnchor).active = true
        
        self.navigationItem.titleView = titleV
        
        // Gesture Recognizer
        titleV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    // Launch Controller
    func showChatController() {
        let chatController = ChatController()
        navigationController?.pushViewController(chatController, animated: true)
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
        loginController.messageController = self
        presentViewController(loginController, animated: true, completion: nil)
    }

    


}

