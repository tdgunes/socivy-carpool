//
//  SocivyAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

protocol SocivyBaseLoginAPIDelegate {
    func authDidFail()
}

enum SocivyAPIMethod: String {
    
    //route API
    case selfURL = "/me/route/self"
    case availableURL = "/me/route/available"
    case destroyURL = "/route/{id}"
    case storeURL = "/route"
    case enrolledURL = "/me/route/enrolled"
    case requestURL = "/route/{id}/request"
    case cancelURL = "/route/{id}/cancel"
    
    
    //user API
    case login = "/login"
    case logout = "/logout"
    case authenticate = "/authenticate"
    case register = "/register"
    
    //settings API
    case setting = "/me/setting"
    
    //tool API
    case place = "/place"
    case device = "/device"
    case bus = "/bus"
    
}


class SocivyAPI {
    let public_key:String = "$2y$10$EABJx.UPPrTRCbn.nR34geK6HJOZWvEQFRFVQzCV2hW7aI13jn16G"

    var domain = "https://socivy.com"
    let forgotPassword:String
    let url:String
    let key = "user_secret"

    
    var user_secret:String?
    var access_token:String?
    
 
    
    var expireTime:Int?
    
    class var sharedInstance : SocivyAPI {
        return _SingletonSocivyAPI
    }
    
    init(){
        if Logger.sharedInstance.DEBUG {
            Logger.sharedInstance.log("api", message: "Development Mode")
//            domain = "http://development.socivy.com"
        }
        
        self.forgotPassword =  "\(domain)/forgot-password"
        url = "\(domain)/api/v1"

    }

    func clearUserSecret(){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject("", forKey: "user_secret")
        userDefaults.synchronize()
        self.user_secret = ""
    }
    func saveUserSecret(){
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(user_secret!, forKey: "user_secret")
        userDefaults.synchronize()
    }
    
    func log(string:String){
        Logger.sharedInstance.log("api", message: string)
    }
    

    func isUserSecretSaved()->Bool{
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        
        if let value:String = userDefaults.objectForKey("user_secret") as String? {
            if !value.isEmpty {
                self.log("isUserSecretSaved() -> true")
                return true
            }
            self.log("isUserSecretSaved() -> false")
            return false
        }
        self.log("isUserSecretSaved() -> false")
        return  false
    }
    
    func loadUserSecret(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.synchronize()
        
        self.user_secret = userDefaults.objectForKey("user_secret") as String?
    }
    
    func showError(error:NSError){
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func showSessionExpired(){
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Your session is expired."
        alert.addButtonWithTitle("OK")
        alert.show()
    }
}

let _SingletonSocivyAPI = SocivyAPI()
