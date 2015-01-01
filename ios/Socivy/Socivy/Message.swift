//
//  Message.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 23/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Message {

    var text: String
    var timestamp: Int
    var peer: Peer
    weak var room: Room?
    
    init (text:String, timestamp:Int, peer:Peer) {
        self.text = text
        self.timestamp = timestamp
        self.peer = peer
    }
    
}