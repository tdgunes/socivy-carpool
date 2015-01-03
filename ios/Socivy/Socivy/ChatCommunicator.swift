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
        
        var payload:NSMutableDictionary = ["method":"acknowledge"]
        payload.setObject(["name":SocivyAPI.sharedInstance.email!, "email":SocivyAPI.sharedInstance.email!], forKey: "peer")
        self.communicator?.send(JSON(payload).toString(pretty: false))
        
    }
    
    func startRoom(recipient:String){
        var payload:NSMutableDictionary = ["method":"room","sender":SocivyAPI.sharedInstance.email!, "recipient":recipient]
        
        payload.setObject(["name":SocivyAPI.sharedInstance.email!, "email":SocivyAPI.sharedInstance.email!], forKey: "peer")
            
        let postData = JSON(payload).toString(pretty: false)
        
        self.communicator?.send(postData)
        
    }
    

    
    func onReceive(string:String){


        let json = JSON.parse(string)
        //println("Received: \n \(json.toString(pretty: true))")
        
        if let status = json["status"].asString {
            if status == "connectionEstablished"{
                self.delegate?.connectionEstablished()


   
            }
            return
        }
        
        let roomIdentifier = json["room"].asInt!
        
        if let room = roomsDictionary[roomIdentifier] {
            var peer = Peer(email: json["email"].asString!, name: json["name"].asString!)
            
            var message = Message(text: json["text"].asString!, timestamp: json["timestamp"].asInt!, peer: peer )
            room.addMessage(message)
            
            self.delegate?.messageRecieved(message, room: room)
            return
        }
        else{
            var room = Room(identifier: roomIdentifier)
            var peer = Peer(email: json["peer"]["email"].asString!, name: json["peer"]["name"].asString!)
            
            roomsDictionary[room.identifier] = room
            rooms.append(room)
            
            var message = Message(text: json["text"].asString!, timestamp: json["timestamp"].asInt!, peer: peer )
            room.addMessage(message)
            
            self.delegate?.newRoomRecieved(room)
            return
        }
        
        
    }
    
    func onInterrupt(){
        self.delegate?.connectionFailed()
    }
    class var sharedInstance : ChatCommunicator {
        return _SingletonChatCommunicator
    }
    

}
let _SingletonChatCommunicator = ChatCommunicator()
