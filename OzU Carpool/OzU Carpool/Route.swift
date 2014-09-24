//
//  Route.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import MapKit


class User {
    
    var name:String
    var cellphone:String
    
    init(name:String, cellphone:String){
        self.name = name
        self.cellphone = cellphone
    }
    
}

class Stop {
    var location:CLLocationCoordinate2D?
    var name:String?

    
    init (name:String?, location:CLLocationCoordinate2D?){
        self.location = location
        self.name = name
    }
}

class Route {

    var stops:[Stop];
    var selectedStop:Stop?;
    var timestamp:Int?
    var description: String?
    var toOzu:Bool?
    var driver:User?
    
    init(stops:[Stop], timestamp:Int?, description:String?, toOzu:Bool, driver:User?){
        self.stops = stops
        self.timestamp = timestamp
        self.description = description
        self.toOzu = toOzu
        self.driver = driver
    }
    
    
    func getTime()->String?{
        let date:NSDate = NSDate(timeIntervalSince1970: NSTimeInterval(self.timestamp!))
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(date)
    }
}