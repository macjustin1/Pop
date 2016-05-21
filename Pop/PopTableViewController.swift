//
//  PopTableViewController.swift
//  Pop
//
//  Created by Justin Mac on 5/19/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import UIKit
import CloudKit

class PopTableViewController: UITableViewController {
    var messages = [CKRecord]()
    
    var refresh : UIRefreshControl!
    var timer : NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to load pops")
        refresh.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refresh)
        
        loadData()
        timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
        
    }
    
    
    func loadData() {
        messages = [CKRecord]()
        let publicData = CKContainer.defaultContainer().publicCloudDatabase
        let query = CKQuery(recordType: "Message", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil)) //NSPredicate looks at every message type
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)] //sort so most recent message will appear first
        publicData.performQuery(query, inZoneWithID: nil, completionHandler: { (results:[CKRecord]?, error:NSError?) -> Void in
            if let messages = results {
                self.messages = messages
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                })
            }
            
        })
    }
    
    @IBAction func sendPop(sender: AnyObject) { //UIAlert to add a message
        let alert = UIAlertController(title: "New Message", message: "Enter a message", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler {
            (textField:UITextField) -> Void in
            textField.placeholder = "Pop a message"
        }
        alert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first!
            if textField != "" {
                let newMessage = CKRecord(recordType: "Message")
                newMessage["content"] = textField.text
                let publicData = CKContainer.defaultContainer().publicCloudDatabase
                print("Created default container")
                publicData.saveRecord(newMessage, completionHandler: {
                    (record:CKRecord?, error:NSError?) -> Void in
                    if error == nil {
                        print("Message saved")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.beginUpdates() //add new message to tableView
                            self.messages.insert(newMessage,atIndex: 0)
                            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                            self.tableView.endUpdates()
                            
                        })
                        
                    }
                    else {
                        print(error)
                        print("Possibly not logged into iCloud")
                    }
                })
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        let publicData = CKContainer.defaultContainer().publicCloudDatabase
        publicData.fetchAllSubscriptionsWithCompletionHandler() {
            [unowned self] (subscriptions,error) -> Void in
            if error == nil {
                let subscription = CKSubscription(recordType: "Message", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil), options: .FiresOnRecordCreation) //when there's a new record added to Message, send a push notification
                let notification = CKNotificationInfo()
                notification.alertBody = "There's a new pop!"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.shouldBadge = true
                print("maybe pushed")
                subscription.notificationInfo = notification
                publicData.saveSubscription(subscription, completionHandler: { (result,error) -> Void in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                })
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if messages.count == 0 {
            return cell
        }
        
        let message = messages[indexPath.row]
        if let messageContent = message["content"] as? String { //outputs date of message creation
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormat.stringFromDate(message.creationDate!)
            
            cell.textLabel?.text = messageContent
            cell.detailTextLabel?.text = dateString
        }
        return cell
    }
}
