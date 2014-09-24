//
//  Route.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import MapKit

class Stop {
    var location:CLLocation?
    var name:String?
    
    init (name:String?, location:CLLocation?){
        self.location = location
        self.name = name
    }
}

class Route {

    var stop:Stop?;
    var timestamp:Int?
    var description: String?
    var toOzu:Bool?
    
    init(stop:Stop?, timestamp:Int?, description:String?, toOzu:Bool){
        self.stop = stop
        self.timestamp = timestamp
        self.description = description
        self.toOzu = toOzu
    }
    
    
}