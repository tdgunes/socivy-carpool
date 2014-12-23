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
    func messageFromNewRoom(message:Message, room:Room)
    
    func connectionEstablished()
    func connectionFailed()
    
}

class ChatCommunicator{
    
    var communicator: Communicator?
    var delegate: ChatCommunicatorDelegate?
    var rooms: [Int:Room] = [:]
    
    init(){

    }
    
    func start(){
        self.communicator =  Communicator(onRecieve: self.onReceive,
                                          onInterrupt: self.onInterrupt)
        communicator?.startConnection()
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
        if json["status"].asString! == "connectionEstablished" {
            self.delegate?.connectionEstablished()
            return
        }
        
        let roomIdentifier = json["room"].asInt!
        
        if let room = rooms[roomIdentifier] {
            var message = Message(json: json)
            room.addMessage(message)
            self.delegate?.messageRecieved(message, room: room)
            return
        }
        else{
            var room = Room(json: json)
            var message = Message(json: json)
            room.addMessage(message)
            self.delegate?.messageFromNewRoom(message, room: room)
            return
        }
        
        
    }
    
    func onInterrupt(){
        self.delegate?.connectionFailed()
    }
}