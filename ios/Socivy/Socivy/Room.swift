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
    var description: String {
        return "Room: \(self.identifier)"
    }
    
    
    init (identifier:Int){
        self.identifier = identifier
        self.messages = []
    }
    
    
    func addMessage(message:Message){
        message.room = self
        self.messages.append(message)
    }
    
}