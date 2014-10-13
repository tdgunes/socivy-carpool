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
    var location:CLLocationCoordinate2D
    var name:String
    var id:String
    
    init (id:String, name:String, location:CLLocationCoordinate2D){
        self.location = location
        self.name = name
        self.id = id
    }
}

class Route: Printable {

    var stops:[Stop]
    var selectedStop:Stop?
    var timestamp:Double
    var details: String
    var toOzu:Bool
    var driver:User
    var seatLeft: Int
    var id: String
    
    var description: String {
        return "Route: \(self.driver.name!) - stops: \(self.stops.count)"
    }
    
    init(id:String, stops:[Stop], timestamp:Double, description:String, toOzu:Bool, driver:User, seatLeft:Int){
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
    
     func getLeft()->String{
        let now = NSDate()
//        println("Now: \(now) - \(now.timeIntervalSince1970)")
        let then = NSDate(timeIntervalSince1970: NSTimeInterval(self.timestamp))
//        println("Then: \(then) - \(self.timestamp)")
        
        let interval = self.timestamp - now.timeIntervalSince1970
        
        let diffMinute = Int(floor(interval/60))
//        println("diffMinute: \(diffMinute)")
        let diffHour:Int =  Int( floor(interval/3600) )
//        println("diffHour: \(diffHour)")
        
        var text = ""
        if diffMinute <= 0 {
            text = "On road"
        }
        else if diffHour > 0 {
            text = "\(diffHour) hours left"
            if diffHour == 1 {
                text = "\(diffHour) hour left"
            }
        }
        else {
            text = "\(diffMinute) minutes left"
        }
        
        return text
    }
    
    func getRight()->String{
        let now = NSDate()
        let then = NSDate(timeIntervalSince1970: NSTimeInterval(self.timestamp))
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let interval = self.timestamp - now.timeIntervalSince1970

        var text = ""
        
        let diffDay = Int(floor(interval/(3600*24)))
//        println(diffDay)
        if(diffDay == 1)
        {
            text = "Tom. ";
        }
        
        text = text + dateFormatter.stringFromDate(then)
        
        return text
        
    }

}