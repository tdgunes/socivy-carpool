//
//  SocivyAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


class SocivyAPI {
    let public_key:String = "$2y$10$9sI0wpjalK9B1tdDrdWyPe9PGvJquJ08l0UwSfgNgf3Aa6hvVJRmW"

    let url = "http://development.socivy.com/api/v1"
    
    
    var user_secret:String?
    var access_token:String?
    
    var authenticateAPI:SocivyAuthenticateAPI?
    var indexRouteAPI:SocivyIndexRouteAPI?


    var expireTime:Int?
    
    class var sharedInstance : SocivyAPI {
        return _SingletonSocivyAPI
    }
    
    init(){
        self.authenticateAPI = SocivyAuthenticateAPI(api: self)
        self.indexRouteAPI = SocivyIndexRouteAPI(api: self)


    }
    
}

let _SingletonSocivyAPI = SocivyAPI()
