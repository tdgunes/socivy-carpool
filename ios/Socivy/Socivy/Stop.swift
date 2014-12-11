//
//  Stop.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 10/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import MapKit




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
