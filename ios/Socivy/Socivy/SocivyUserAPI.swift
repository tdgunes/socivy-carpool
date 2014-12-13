//
//  SocivyUserAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class SocivyUserAPI {
    var networkLibraryFactory = APINetworkLibraryFactory()
    
    var delegate:SocivyBaseLoginAPIDelegate? {
        didSet {
            self.networkLibraryFactory.delegate = self.delegate
        }
    }
    
    init(){
        
    }
    func login(completionHandler:((json:JSON)->())?,errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->(), networkLibrary:NetworkLibrary?){

        var onLogin = {
            (json:JSON) -> () in
            SocivyAPI.sharedInstance.access_token = json["result"]["access_token"].asString
            SocivyAPI.sharedInstance.expireTime = json["result"]["expire_time"].asInt
            Logger.sharedInstance.log("login", message: "onLogin")

            if let library = networkLibrary{
                library.updateAccessToken()
                library.request()
            }
            
            if let handler = completionHandler{
                handler(json: json)
            }

        }
        
        var onError = {
             (error:NSError, errorCode:NetworkLibraryErrorCode)->()  in
             SocivyAPI.sharedInstance.clearUserSecret()
            Logger.sharedInstance.log("login", message: "onError")
             errorHandler(error: error, errorCode: errorCode)
        }
        
        
        let payload = ["user_secret":SocivyAPI.sharedInstance.user_secret!]
        let postData = JSON(payload).toString(pretty: false)
        
        var networkLibrary = self.networkLibraryFactory.generate(.login, APINetworkLibraryHeader.withAccessTokenContentType, postData, .POST, onLogin, onError)
        
        networkLibrary.request()
    }
    
    func logout(completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){
        var networkLibrary = self.networkLibraryFactory.generate(.logout, APINetworkLibraryHeader.withAccessToken, nil, .GET, completionHandler,errorHandler)
        networkLibrary.request()
    }
    
    func authenticate(email:String, password:String, completionHandler:((json:JSON)->())?,errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()) {
        let payload:[String:String] = ["email":email, "password":password, "public_key": SocivyAPI.sharedInstance.public_key]
        let postData = JSON(payload).toString(pretty: false)
        
        var onLogin = {
            (json:JSON) -> () in

            Logger.sharedInstance.log("authenticate", message: "authenticate")
            
            SocivyAPI.sharedInstance.user_secret = json["result"]["user_secret"].asString
            SocivyAPI.sharedInstance.access_token = json["result"]["access_token"].asString
            SocivyAPI.sharedInstance.expireTime = json["result"]["expire_time"].asInt
            if let handler = completionHandler{
                handler(json: json)
            }
        }
        
        var networkLibrary = self.networkLibraryFactory.generate(.authenticate, APINetworkLibraryHeader.withContentType, postData, .POST, onLogin, errorHandler)
        
        networkLibrary.request()
    }

    
    func register(name:String, email:String, password:String, phone:String,completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){

        var payload = ["name":name, "email":email, "password":password, "phone":phone,"public_key":SocivyAPI.sharedInstance.public_key]
        let postData = JSON(payload).toString(pretty: false)
        
        var networkLibrary = self.networkLibraryFactory.generate(.register, APINetworkLibraryHeader.withAccessTokenContentType, postData, .POST, completionHandler, errorHandler)
        
        networkLibrary.request()
    }
}

