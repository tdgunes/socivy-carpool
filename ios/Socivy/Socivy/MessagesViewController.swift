//
//  MessagesViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 24/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var messageBarView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var room: Room?

    
    override func viewDidLoad() {
        self.tabBarController?.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        
        
        self.navigationItem.title = self.room!.messages[0].peer.name
        
        self.addUpperBorder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.sendMessage()
        return true
    }
    
    
    // http://stackoverflow.com/questions/17355280/how-to-add-a-border-just-on-the-top-side-of-a-uiview
    func addUpperBorder() {
        var upperBorder = CALayer()
        upperBorder.backgroundColor = UIColor.blackColor().CGColor
        upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.messageBarView.frame), 1.0)
        upperBorder.borderWidth = 0.1
        upperBorder.opacity = 0.1
        messageBarView.layer.addSublayer(upperBorder)
    }
    @IBAction func sendButtonTouched(sender: AnyObject) {
        self.sendMessage()
    }
    
    func sendMessage(){
        var peer = Peer(email: "taha.gunes@ozu.edu.tr", name: "Taha Dogan Gunes")
        self.room?.messages.append(Message(text: self.textField.text, timestamp: 123123123, peer: peer))
        
        var newIndexPath = NSIndexPath(forRow: self.room!.messages.count-1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        self.tableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Top , animated: true)
        
        self.textField.text = ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room!.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message = room!.messages[indexPath.row]
        
        var cell: UITableViewCell?
        if message.peer.email == SocivyAPI.sharedInstance.email!{
            cell = (self.tableView.dequeueReusableCellWithIdentifier("messageRightCell", forIndexPath:indexPath) as UITableViewCell)
        }
        else {
            cell = (self.tableView.dequeueReusableCellWithIdentifier("messageLeftCell", forIndexPath:indexPath) as UITableViewCell)

        }
        var senderLabel = cell?.viewWithTag(100) as UILabel
        var messageLabel = cell?.viewWithTag(99) as UILabel

        var timeLabel = cell?.viewWithTag(101) as UILabel
        
        messageLabel.text = message.text
        senderLabel.text = message.peer.name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    


}