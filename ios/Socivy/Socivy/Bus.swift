//
//  Bus.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 13/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class Bus {
    var id:String
    var direction:String
    var hours:[String]
    
    init (id:String, direction:String, hours:[String]){
        self.id = id
        self.direction = direction
        self.hours = hours
    }
    
}