//
//  NewMessageController.swift
//  BubblesChatApp
//
//  Created by Ravideep Dhupia on 2016-09-05.
//  Copyright © 2016 Ravideep Dhupia. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    var  users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cancel button top left
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    // Firebase Fetching
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            // Each snapshot contains dictionary values, to get to the values:
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                
                // Must ensure that the dictionary keys are exactly the same as properties
                user.setValuesForKeysWithDictionary(dictionary)
                self.users.append(user)
                
                // Use dispatch_async or else reloadData() will crash app because of the background thread
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                
                print(user.name, user.email)
            }
            
            }, withCancelBlock: nil)
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Configure Table View
    
    // For table view controller, need to provide:
    // Gives us as many rows as the number of users in our table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // hack for now. Actually need to dequeue our cells for memory efficiency
        // let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }

}

// MARK: Custom Cell
// Register a cell
class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}