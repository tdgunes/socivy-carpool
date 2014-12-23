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
    var communicator:ChatCommunicator?
    var player = AudioPlayer()
    
    override func viewDidLoad() {
//        self.communicator = Communicator(onRecieve: self.messageRecieved, onInterrupt: self.connectionFailed)
//        self.communicator?.startConnection()
//        self.communicator?.send("hello")
        communicator = ChatCommunicator()
        communicator?.delegate = self
        communicator?.start()
        
    }
    
    func messageRecieved(message:Message, room:Room){
        
    }
    func messageFromNewRoom(message:Message, room:Room){
        
    }
    
    func connectionEstablished(){
        player.play(.ConnectionEstablished)
    }
    func connectionFailed(){
        
    }
    
    
    func messageRecieved(string:String){
        var tabBarItem = self.tabBarController?.tabBar.items![2] as UITabBarItem
        if tabBarItem.badgeValue == nil {
            tabBarItem.badgeValue = "1"
        }
        else {
            tabBarItem.badgeValue = "\(tabBarItem.badgeValue!.toInt()! + 1)"
        }
        
        
        player.play(.NewMessage)

    }

}
