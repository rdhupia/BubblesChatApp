//
//  ChatController.swift
//  BubblesChatApp
//
//  Created by Ravideep Dhupia on 2016-09-17.
//  Copyright © 2016 Ravideep Dhupia. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UITextFieldDelegate {
    
    // Text field
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Log"
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        // Set iOS9 constraints x, y, width, height
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        // Send button
        let sendButton = UIButton(type: .System)   // gives down state, button more interactive
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        
        // Set iOS9 constraints x, y, width, height
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        // Text field
        containerView.addSubview(inputTextField)
        
        // Set iOS9 constraints x, y, width, height
        inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        // Seperator line above message input area
        let seperatorLiveView = UIView()
        seperatorLiveView.backgroundColor = UIColor(r: 20, g: 220, b: 20)
        seperatorLiveView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLiveView)
        
        // Set iOS9 constraints x, y, width, height
        seperatorLiveView.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        seperatorLiveView.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        seperatorLiveView.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        seperatorLiveView.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    // Handle Send
    func handleSend() {
        // Create reference to text field
        let ref = FIRDatabase.database().reference().child("messages")
        // For list of messages
        let childRef = ref.childByAutoId()
        
        let values = ["text": inputTextField.text!]
        childRef.updateChildValues(values)
        print(inputTextField.text)
    }
    
    // On pressing Enter key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}










