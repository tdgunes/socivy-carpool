//
//  LocationStorage.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 26/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import MapKit

class Location: MKPointAnnotation {

    var color:MKPinAnnotationColor
    
    init(_ title:String,_ coordinate:CLLocationCoordinate2D){
        self.color = MKPinAnnotationColor.Purple
        
        super.init()
        self.title = title
        self.coordinate = coordinate
    }
}

class LocationStorage {
    
    var locations: [Location]
    
    class var sharedInstance : LocationStorage {
        return _SingletonLocationStorage
    }
    
    init() {
        locations = []
        
        //Özyeğin University
        let ozyegin = Location("Özyeğin Üniversitesi",self.giveLoc(41.029547, 29.260404))
        
        //Altunizade Cookshop
        let cookshop = Location("Altunizade Cookshop",self.giveLoc(41.021954, 29.044544))
        
        //Merkez Ataşehir McDonalds
        let atasehir = Location("Merkez Ataşehir McDonalds",self.giveLoc( 40.99269, 29.127781))
        
        //Taşdelen Kardiyum
        let kardiyum = Location("Taşdelen Kardiyum",self.giveLoc(41.031689, 29.227221))
        
        locations.append(ozyegin)
        locations.append(cookshop)
        locations.append(atasehir)
        locations.append(kardiyum)
    }
    
    func getAll()->[Location]{
        return self.locations
    }
    
    func giveLoc(lat:Double, _ lon:Double)->CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude:  lat, longitude: lon)
    }
}

let _SingletonLocationStorage = LocationStorage()