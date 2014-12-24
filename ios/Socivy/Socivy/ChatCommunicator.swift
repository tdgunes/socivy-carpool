//
//  ChatCommunicator.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 23/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol ChatCommunicatorDelegate {
    func messageRecieved(message:Message, room:Room)
    func newRoomRecieved(room:Room)
    
    func connectionEstablished()
    func connectionFailed()
    
}

class ChatCommunicator{
    
    var communicator: Communicator?
    var delegate: ChatCommunicatorDelegate?
    var roomsDictionary: [Int:Room] = [:]
    var rooms:[Room] = []
    
    init(){

    }
    
    func start(){
        self.communicator =  Communicator(onRecieve: self.onReceive,
                                          onInterrupt: self.onInterrupt)
        communicator?.startConnection()
    }
    
    func startRoom(recipient:String){
        var payload:[String:String] = ["method":"room","sender":SocivyAPI.sharedInstance.email!, "recipient":recipient]
        let postData = JSON(payload).toString(pretty: false)
        
        self.communicator?.send(postData)
        
    }
    
    
    func onReceive(string:String){
        /*
        json is excepted to be:
        {
            "room": roomid,
            "text": text,
            "sender": sender's email,
            "timestamp": timestamp
        }
        */
        let json = JSON.parse(string)
        if let status = json["status"].asString {
            if status == "connectionEstablished"{
                self.delegate?.connectionEstablished()
            }
            return
        }
        
        let roomIdentifier = json["room"].asInt!
        
        if let room = roomsDictionary[roomIdentifier] {
            var message = Message(json: json)
            room.addMessage(message)
            self.delegate?.messageRecieved(message, room: room)
            return
        }
        else{
            var room = Room(json: json)
            
            roomsDictionary[room.identifier] = room
            rooms.append(room)
            
            self.delegate?.newRoomRecieved(room)
            return
        }
        
        
    }
    
    func onInterrupt(){
        self.delegate?.connectionFailed()
    }
}