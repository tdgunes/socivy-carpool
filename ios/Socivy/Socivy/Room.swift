//
//  Room.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 23/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Room {
    var identifier:Int
    var messages:[Message]
    
    init (identifier:Int){
        self.identifier = identifier
        self.messages = []
    }
    
    convenience init(json:JSON){
        self.init(identifier: json["room"].asInt!)
    }
    
    func addMessage(message:Message){
        message.room = self
        self.messages.append(message)
    }
    
}