//
//  Message.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 23/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Message {

    var sender: String
    var text: String
    var timestamp: Int
    weak var room: Room?
    
    init (sender:String, text:String, timestamp:Int) {
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
    
    convenience init(json:JSON){
        self.init(sender:json["sender"].asString!, text:json["text"].asString!, timestamp:json["timestamp"].asInt!)
    }
}