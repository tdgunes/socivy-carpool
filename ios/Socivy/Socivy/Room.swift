//
//  Room.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 23/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Room:Printable{
    var identifier:Int
    var messages:[Message]
    var peer:Peer
    var description: String {
        return "Room: \(self.identifier)"
    }
    
    
    init (identifier:Int, peer:Peer){
        self.identifier = identifier
        self.messages = []
        self.peer = peer
    }
    
    convenience init(json:JSON){
        self.init(identifier: json["room"].asInt!, peer:(Peer(json:json["peer"])))
    }
    
    func addMessage(message:Message){
        message.room = self
        self.messages.append(message)
    }
    
}