//
//  Peer.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 24/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Peer {
    var email:String
    var name:String
    
    init(email:String, name:String){
        println(email)
        println(name)
        self.email = email
        self.name = name
    }
    
    convenience init(json:JSON){
        println(json)
        
        self.init(email: json["email"].asString!, name:json["name"].asString!)
    }
}