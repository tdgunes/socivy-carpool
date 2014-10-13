//
//  SocivyAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

let DEBUG:Bool = true

class SocivyBaseAPI: AsyncHTTPRequestDelegate {
    var asyncRequest:AsyncHTTPRequest?
  
    unowned var api: SocivyAPI
    
    var url:String {
        get{
            return api.url + path
        }
    }
    
    let path:String
    
    init(path:String, api:SocivyAPI){
        self.path = path
        self.api = api
    }
    func log(string:String){
        if DEBUG {
            println("[\(self.path)] \(string)")
        }
    }
    

    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        fatalError("requestFailWithError(asyncHTTPRequest:, error:) has not been implemented")
    }
    func requestDidFinish(asyncHTTPRequest:AsyncHTTPRequest, _ response:NSMutableData){
        fatalError("requestDidFinish(asyncHTTPRequest:, _ response:) has not been implemented")
    }
}

class SocivyBaseLoginAPI: SocivyBaseAPI, SocivyLoginAPIDelegate{

    var loginAPI:SocivyLoginAPI?
    
    override init(path:String, api:SocivyAPI){
        super.init(path: path , api: api)
        self.loginAPI = SocivyLoginAPI(api:self.api)
        self.loginAPI?.delegate = self
    }

    func loginDidFinish(socivyAPI:SocivyLoginAPI){
        fatalError("loginDidFinish(socivyAPI:) has not been implemented")
    }
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        fatalError("loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:) has not been implemented")
    }
}

class SocivyAPI {
    let public_key:String = "$2y$10$EABJx.UPPrTRCbn.nR34geK6HJOZWvEQFRFVQzCV2hW7aI13jn16G"

    let url = "http://development.socivy.com/api/v1"
    
    var user_secret:String?
    var access_token:String?
    
    var authenticateAPI:SocivyAuthenticateAPI?
    var indexRouteAPI:SocivyIndexRouteAPI?
    var storeRouteAPI:SocivyStoreRouteAPI?
    var selfRouteAPI:SocivyRouteSelfAPI?
    var placeAPI: SocivyPlaceAPI?
    var enrolledRouteAPI:SocivyRouteEnrolledAPI?
    

    var expireTime:Int?
    
    class var sharedInstance : SocivyAPI {
        return _SingletonSocivyAPI
    }
    
    init(){
        self.authenticateAPI = SocivyAuthenticateAPI(api: self)

        //route related
        self.indexRouteAPI = SocivyIndexRouteAPI(api: self)
        self.storeRouteAPI = SocivyStoreRouteAPI(api: self)
        self.enrolledRouteAPI = SocivyRouteEnrolledAPI(api: self)
        
        self.selfRouteAPI = SocivyRouteSelfAPI(api:self)
        self.placeAPI = SocivyPlaceAPI(api: self)

        
    }

}

let _SingletonSocivyAPI = SocivyAPI()
