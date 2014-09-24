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
    var location:CLLocationCoordinate2D?
    var name:String?
    
    init (name:String?, location:CLLocationCoordinate2D?){
        self.location = location
        self.name = name
    }
}

class Route {

    var stop:Stop?;
    var timestamp:Int?
    var description: String?
    var toOzu:Bool?
    var driver:String?
    
    init(stop:Stop?, timestamp:Int?, description:String?, toOzu:Bool, driver:String?){
        self.stop = stop
        self.timestamp = timestamp
        self.description = description
        self.toOzu = toOzu
        self.driver = driver
    }
    
    
}