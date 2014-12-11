//
//  User.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 10/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class User {
    
    var id:String
    var email:String
    var name:String
    var isPhoneVisible:Bool
    var phone:String
    
    init(id:String, name:String, email:String,  showPhone:Bool, phone:String){
        self.id = id
        self.name = name
        self.isPhoneVisible = showPhone
        self.phone = phone
        self.email = email
    }
    
    convenience init(jsonUser:JSON){
        let driverID = jsonUser["id"].asString!
        let driverName = jsonUser["name"].asString!
        let driverEmail = jsonUser["email"].asString!
        let driverPhone = jsonUser["information"]["phone"].asString!
        let driverShowPhone = jsonUser["information"]["showPhone"].asBool!
        self.init(id: driverID, name: driverName, email: driverEmail, showPhone: driverShowPhone, phone: driverPhone)
    }
}
