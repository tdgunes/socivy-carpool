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
    
    func generateError() -> NSError{
        let description:String = "Something terrible happened! \nFailed to login."
        let reason: String = "The operation timed out."
        let suggestion: String = "Have you tried turning it off and on again?"
        
        let userInfo: NSDictionary = [ NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason,NSLocalizedRecoverySuggestionErrorKey: suggestion]
        let error = NSError(domain:"com.tdg.dilixiri", code:-57, userInfo:userInfo)
        return error
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

    let domain = "http://development.socivy.com"
    let url:String

    
    var user_secret:String?
    var access_token:String?
    
    var authenticateAPI:SocivyAuthenticateAPI?
    var availableRouteAPI:SocivyAvailableRouteAPI?
    var storeRouteAPI:SocivyStoreRouteAPI?
    var selfRouteAPI:SocivyRouteSelfAPI?
    var placeAPI: SocivyPlaceAPI?
    var enrolledRouteAPI:SocivyRouteEnrolledAPI?
    var requestRouteAPI:SocivyRouteRequestAPI?
    var cancelRouteAPI:SocivyRouteCancelAPI?
    var loginAPI:SocivyLoginAPI?
    var logoutAPI:SocivyLogoutAPI?
    var deviceStoreAPI:SocivyDeviceStoreAPI?
    
    var expireTime:Int?
    
    class var sharedInstance : SocivyAPI {
        return _SingletonSocivyAPI
    }
    
    init(){
        url = "\(domain)/api/v1"
        self.authenticateAPI = SocivyAuthenticateAPI(api: self)
        self.loginAPI = SocivyLoginAPI(api: self)
            
        //route related
        self.availableRouteAPI = SocivyAvailableRouteAPI(api: self)
        self.storeRouteAPI = SocivyStoreRouteAPI(api: self)
        self.enrolledRouteAPI = SocivyRouteEnrolledAPI(api: self)
        self.requestRouteAPI = SocivyRouteRequestAPI(api: self)
        self.cancelRouteAPI = SocivyRouteCancelAPI(api:self)
        
        self.selfRouteAPI = SocivyRouteSelfAPI(api:self)
        self.placeAPI = SocivyPlaceAPI(api: self)

        self.deviceStoreAPI = SocivyDeviceStoreAPI(api:self)
        self.logoutAPI = SocivyLogoutAPI(api:self)
    }


    func clearUserSecret(){
        KeychainService.setString("", forKey: "user_secret")
    }
    func saveUserSecret(){
        KeychainService.setString(user_secret!, forKey: "user_secret")
    }
    func isUserSecretSaved()->Bool{
        if let value = KeychainService.stringForKey("user_secret"){
            if value.isEqualToString("") == false {
                return true
            }
        }
        return  false
    }
    
    func loadUserSecret(){
        self.user_secret = KeychainService.stringForKey("user_secret")
    }
}

let _SingletonSocivyAPI = SocivyAPI()
