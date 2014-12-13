//
//  SocivyAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit


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
}







class SocivyBaseAPI: NetworkLibraryDelegate {
    var networkLibrary:NetworkLibrary?
  
    unowned var api: SocivyAPI
    
    var url:String {
        get{
            return api.url + path
        }
    }
    
    let path:String
    
    init(path:String){
        self.path = path
        self.api = SocivyAPI.sharedInstance
    }
    
    // MARK: - NetworkLibrary Delegate
    func requestFailWithError(errorCode:NetworkLibraryErrorCode, error:NSError?){
        fatalError("requestFailWithError(asyncHTTPRequest:, error:) has not been implemented")
    }
    func requestDidFinish(response:NSMutableData){
        fatalError("requestDidFinish(asyncHTTPRequest:, _ response:) has not been implemented")
    }
    
    func log(string:String){
        Logger.sharedInstance.log(self.path, message: string)
    }
    

    
    func makePOST(payload:[String:String]){
        self.log("makePOST:")
        
        let postData = JSON(payload).toString(pretty: false)
        self.networkLibrary = NetworkLibrary(url: self.url, headers:["Content-Type":"application/json"], postData:postData, httpMethod:HTTPMethod.POST)
        self.networkLibrary?.delegate = self
        self.networkLibrary?.request()
    }
    

    
    func generateError() -> NSError{
        let description:String = "Something terrible happened! \nFailed to login."
        let reason: String = "The operation timed out."
        let suggestion: String = "Have you tried turning it off and on again?"
        
        let userInfo: NSDictionary = [ NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason,NSLocalizedRecoverySuggestionErrorKey: suggestion]
        let error = NSError(domain:"com.tdg.dilixiri", code:-57, userInfo:userInfo)
        return error
    }
    func showError(error:NSError){
        self.api.showError(error)
    }

}
protocol SocivyBaseLoginAPIDelegate {
    func authDidFail()
}

class SocivyBaseLoginAPI: SocivyBaseAPI, SocivyLoginAPIDelegate{

    var loginAPI:SocivyLoginAPI?
    
    override init(path:String){
        super.init(path: path)
        self.loginAPI = SocivyLoginAPI()
        self.loginAPI?.delegate = self
    }
    
    
    func makeGETAuth(customURL:String){
        self.log("makeGETPOST:")
        self.networkLibrary = NetworkLibrary(url: customURL, headers: ["Access-token":self.api.access_token!], postData: nil, httpMethod: .GET)
        self.networkLibrary?.delegate = self
        self.networkLibrary?.request()
    }
    
    func makeGETAuth(){
        self.log("makeGETPOST:")
        self.networkLibrary = NetworkLibrary(url: self.url, headers: ["Access-token":self.api.access_token!], postData: nil, httpMethod: .GET)
        self.networkLibrary?.delegate = self
        self.networkLibrary?.request()
    }
    
    func makePOSTAuth(payload:[String:AnyObject]){
        self.log("makeAuthPOST:")
        let postData = JSON(payload).toString(pretty: false)
        self.networkLibrary = NetworkLibrary(url: self.url, headers:["Content-Type":"application/json","Access-token":self.api.access_token!], postData:postData, httpMethod:.POST)
        self.networkLibrary?.delegate = self
        self.networkLibrary?.request()
    }
    
    func makePOSTAuth(payload:[String:AnyObject], customURL:String){
        self.log("makeAuthPOST:")
        let postData = JSON(payload).toString(pretty: false)
        self.networkLibrary = NetworkLibrary(url: customURL, headers:["Content-Type":"application/json","Access-token":self.api.access_token!], postData:postData, httpMethod:.POST)
        self.networkLibrary?.delegate = self
        self.networkLibrary?.request()
    }
    
    func makeDELETEAuth(customURL:String){
        self.networkLibrary = NetworkLibrary(url: customURL, headers: ["Access-token":self.api.access_token!], postData: nil, httpMethod: .DELETE)
        self.networkLibrary?.delegate = self
        self.networkLibrary?.request()
    }

    func loginDidFinish(socivyAPI:SocivyLoginAPI){
        fatalError("loginDidFinish(socivyAPI:) has not been implemented")
    }
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        fatalError("loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:) has not been implemented")
    }
    func showSessionExpired(){
        self.api.showSessionExpired()
    }

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
            domain = "http://development.socivy.com"
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
