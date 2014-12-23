//
//  ContactsViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 24/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//
// Passing a value when dismiss vc
// http://stackoverflow.com/questions/6606355/pass-value-to-parent-controller-when-dismiss-the-controller


import Foundation
import UIKit

class ContactsViewController: UITableViewController {
    
    var peers:[Peer] = []
    var chatAPI:SocivyChatAPI = SocivyChatAPI()
    var tableRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
        
        self.updateTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateTableView()
    }
    
    func updateTableView(){
        
        self.tableRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        self.chatAPI.getAllChatUser(self.allChatUsersReturned, errorHandler: self.onError)
    }

    
    
    func refreshControlRequest(){
        self.chatAPI.getAllChatUser(self.allChatUsersReturned, errorHandler: self.onError)
    }
    
    @IBAction func dissmissNewRoom(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func allChatUsersReturned(json:JSON){
        self.peers = []
        var jsonPeers = json["peers"].asArray!
        
        for peerObj in jsonPeers{

            let peer = Peer(json: peerObj)
            self.peers.append(peer)
        }
        
        self.tableView.reloadData()
        self.tableRefreshControl.endRefreshing()
    }
    func onError(error:NSError, errorCode:NetworkLibraryErrorCode){
        
        
        self.tableRefreshControl.endRefreshing()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath:indexPath) as UITableViewCell
        
        var peer = self.peers[indexPath.row]
        println(peer.name)
        cell.textLabel?.text = peer.name
        cell.detailTextLabel?.text = peer.email

        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peers.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}