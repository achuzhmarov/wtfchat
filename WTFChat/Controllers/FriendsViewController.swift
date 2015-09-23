//
//  FriendsViewController.swift
//  wttc
//
//  Created by Artem Chuzhmarov on 05/09/15.
//  Copyright (c) 2015 Artem Chuzhmarov. All rights reserved.
//

import UIKit

class FriendsViewController: UITableViewController {

    var friends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let talk = Talk(id: "0")
        
        let singleModeUser = User(id: "0", login: "Single Mode", password: "", email: "", suggestions: 3, rating: 0, timestamp: NSDate(), talk: talk)
        
        talk.users.append(singleModeUser)
        talk.users.append(userService.getCurrentUser())
        
        friends.append(singleModeUser)
        
        friends.appendContentsOf(userService.getAllFriends("User")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendCell

        let friend = friends[indexPath.row]
        
        cell.friendName.text = friend.login
        
        if (friend.talk != nil && friend.talk!.lastMessage != nil) {
            let message = friend.talk!.lastMessage!
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            
            cell.lastMessageTime.text = formatter.stringFromDate(message.timestamp)
            cell.lastMessage.text = message.text()
        } else {
            cell.lastMessage.text = ""
            cell.lastMessageTime.text = ""
        }

        //cell.friendImage =
        
        return cell
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMessages" {
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! MessagesViewController
            
            if let rowIndex = tableView.indexPathForSelectedRow?.row {
                let friend = friends[rowIndex]
                
                if (friend.talk != nil) {
                    targetController.talk = friend.talk
                } else {
                    let newTalk = talkService.createTalkForUsers(userService.getCurrentUser(), user2: friend)
                    friend.talk = newTalk
                    targetController.talk = friend.talk
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
}
