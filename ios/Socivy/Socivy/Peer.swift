//
//  Peer.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 24/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Peer: Printable {
    var email:String
    var name:String
    
    var description: String {
        return "Name: \(self.name) \(self.email)"
    }
    
    init(email:String, name:String){
        self.email = email
        self.name = name
    }


}