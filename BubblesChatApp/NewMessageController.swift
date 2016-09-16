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
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        // Default image view inside UITableView cells - replaced with custom cell & image view below
//        cell.imageView?.image = UIImage(named: "Wayne")
//        cell.imageView?.contentMode = .ScaleAspectFill
        
        if let profileImageUrl = user.profileImageUrl {
            
            cell.profileImageView.loadImageUsingCache(profileImageUrl)
            
//            let url = NSURL(string: profileImageUrl)
//            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//                // Download gives an error
//                if error != nil {
//                    print(error)
//                    return
//                }
//                // Download successful
//                
//                // Run image setter on the main queue
//                dispatch_async(dispatch_get_main_queue(), {
//                    cell.profileImageView.image = UIImage(data: data!)
//                })
//            }).resume()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

}

// MARK: Custom Cell
// Register a cell
class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Change text label frame
        textLabel?.frame = CGRectMake(66, textLabel!.frame.origin.y-2, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.frame = CGRectMake(66, detailTextLabel!.frame.origin.y+2, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Wayne")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Corner radius
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        // iOS 9 constraint anchors
        // need x, y, width, height anchors
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(50).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Extension UIImageView for Cache
// Cache profile images
let imageCache = NSCache()

extension UIImageView {
    func loadImageUsingCache(urlString: String) {
        
        self.image = nil
        
        // check cache for image
        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = NSURL(string: urlString)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            // Download gives an error
            if error != nil {
                print(error)
                return
            }
            // Download successful
            
            // Run image setter on the main queue
            dispatch_async(dispatch_get_main_queue(), {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString)
                    
                    self.image = downloadedImage
                }
                
            })
        }).resume()
    }
}