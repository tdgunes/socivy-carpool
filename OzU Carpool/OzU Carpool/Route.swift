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
    
    var name:String?
    var cellphone:String?
    
    init(name:String?, cellphone:String?){
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

class Route: Printable {

    var stops:[Stop]
    var selectedStop:Stop?
    var timestamp:Int
    var details: String
    var toOzu:Bool
    var driver:User
    var seatLeft: Int
    var id: String
    
    var description: String {
        return "Route: \(self.driver.name!) - stops: \(self.stops.count)"
    }
    
    init(id:String, stops:[Stop], timestamp:Int, description:String, toOzu:Bool, driver:User, seatLeft:Int){
        self.id = id
        self.stops = stops
        self.timestamp = timestamp
        self.details = description
        self.toOzu = toOzu
        self.driver = driver
        self.seatLeft = seatLeft
    }
    
    
    func getTime()->String?{
        let date:NSDate = NSDate(timeIntervalSince1970: NSTimeInterval(self.timestamp))
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(date)
    }
    
    func getFancyTime()->String{
        return "fancy"
    }
    

        

}