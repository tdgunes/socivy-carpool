//
//  Route.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import MapKit

class Route: Printable {

    var stops:[Stop]
    var selectedStop:Stop?
    var timestamp:Double
    var details: String
    var toOzu:Bool
    var driver:User
    var seatLeft: Int
    var id: String
    var passengers: [User]
    var description: String {
        return "Route: \(self.driver.name) - stops: \(self.stops.count)"
    }
    
    init(id:String, stops:[Stop], timestamp:Double, description:String, toOzu:Bool, driver:User, seatLeft:Int, passengers:[User]){
        self.id = id
        self.stops = stops
        self.timestamp = timestamp
        self.details = description
        self.toOzu = toOzu
        self.driver = driver
        self.seatLeft = seatLeft
        self.passengers = passengers
    }
    
    convenience init (routeJson:JSON){
        
        let placeArray = routeJson["places"].asArray! as [JSON]
        var places:[Stop] = []
        for place in placeArray{
            var stop = Stop(id:place["id"].asString!, name: place["name"].asString!, location: CLLocationCoordinate2D(latitude:12.0 , longitude: 12.0))
            places.append(stop)
        }
        
    
        var driver:User = User(jsonUser: routeJson["user"])
        
        let passengerArray = routeJson["companions"].asArray! as [JSON]
        var passengers:[User] = []
        for passenger in passengerArray{
            passengers.append(User(jsonUser: passenger))
        }
        
        var toOzu:Bool = false
        if routeJson["plan"].asString! == "toSchool" {
            toOzu = true
        }
        
        let timestampStr = routeJson["action_time"].asString!
        let timestamp: Double = (timestampStr as NSString).doubleValue as Double
        
        self.init(id: routeJson["id"].asString!, stops: places,
            timestamp: timestamp,
            description: routeJson["description"].asString!,
            toOzu: toOzu,
            driver: driver,
            seatLeft:routeJson["seats"].asInt!,
            passengers:passengers)

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
        let then = NSDate(timeIntervalSince1970: NSTimeInterval(self.timestamp))
        let interval = self.timestamp - now.timeIntervalSince1970
        let diffMinute = Int(floor(interval/60))
        let diffHour:Int =  Int( floor(interval/3600) )

        
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

        if(diffDay == 1)
        {
            text = "Tom. ";
        }
        
        text = text + dateFormatter.stringFromDate(then)
        
        return text
        
    }
    
    func getTweetDate()->String{
        let now = NSDate()
        let then = NSDate(timeIntervalSince1970: NSTimeInterval(self.timestamp))
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let interval = self.timestamp - now.timeIntervalSince1970
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        
        
        var text = formatter.stringFromDate(then)

        
        text = text + " " + dateFormatter.stringFromDate(then)
        
        return text
    }

}