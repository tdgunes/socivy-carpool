//
//  RoomsViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 22/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit




class RoomsViewController: UITableViewController, ChatCommunicatorDelegate {
    
//    var communicator:Communicator?
    weak var communicator = ChatCommunicator.sharedInstance
    var player = AudioPlayer()
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationController?.navigationBar.hidden = true
        self.tabBarController?.navigationController?.navigationBarHidden = true
    }
    override func viewDidLoad() {
//        self.communicator = Communicator(onRecieve: self.messageRecieved, onInterrupt: self.connectionFailed)
//        self.communicator?.startConnection()
//        self.communicator?.send("hello")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("openNewRoom:"), name: "openNewRoom", object: nil)
        
        communicator?.delegate = self
        communicator?.start()
        
        
        
    }
    func openNewRoom(notice:NSNotification){
        //perfom seque end stuff
        var peer = notice.object as Peer
        println("New Room: \(peer)")
        
        self.communicator?.startRoom(peer.email)
    }
    
    func messageRecieved(message:Message, room:Room){
        println("\(message.peer.name) said '\(message.text)'")
        
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPathOfYourCell] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
        
        self.tableView.reloadData()
    }
    
    func newRoomRecieved(room:Room){
        self.player.play(ChatSound.NewMessage)
        println("newRoomRecieved \(room)")
        self.tableView.reloadData()
        self.messageReceived()
    }
    
    func connectionEstablished(){
        var tabBarItem = self.tabBarController?.tabBar.items![2] as UITabBarItem
        if tabBarItem.badgeValue == nil {
            tabBarItem.badgeValue = "1"
        }
        else {
            tabBarItem.badgeValue = "\(tabBarItem.badgeValue!.toInt()! + 1)"
        }
        
        player.play(.ConnectionEstablished)
    
    }
    
    func connectionFailed(){
        
    }
    
    
    func messageReceived(){
        var tabBarItem = self.tabBarController?.tabBar.items![2] as UITabBarItem
        if tabBarItem.badgeValue == nil {
            tabBarItem.badgeValue = "1"
        }
        else {
            tabBarItem.badgeValue = "\(tabBarItem.badgeValue!.toInt()! + 1)"
        }
        
        
        player.play(.NewMessage)

    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var room = self.communicator?.rooms[indexPath.row]

        var messageVC = self.storyboard?.instantiateViewControllerWithIdentifier("messageView") as MessagesViewController
        
        messageVC.room = room!
        
        self.tabBarController?.navigationController?.pushViewController(messageVC, animated: true)
        
        
        

        
        
        //self.setTabBarVisible(false, animated: true)
        
        println(room)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("roomCell", forIndexPath:indexPath) as UITableViewCell
        
        var room = self.communicator!.rooms[indexPath.row]
        
        var contactLabel = cell.viewWithTag(99) as UILabel
        var messageLabel = cell.viewWithTag(100) as UILabel
        var timeLabel = cell.viewWithTag(101) as UILabel
        
        contactLabel.text = room.messages.last!.peer.name
        messageLabel.text = room.messages.last!.text
        
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.communicator!.rooms.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 69
    }
    
    
    
    // http://stackoverflow.com/questions/27008737/how-do-i-hide-show-tabbar-when-tapped-using-swift-in-ios8
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    // Call the function from tap gesture recognizer added to your view (or button)
    
    @IBAction func tapped(sender: AnyObject) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    

}
