//
//  SocivyAuthenticateAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


protocol SocivyAuthenticateAPIDelegate {
    func authenticateDidFinish(socivyAPI:SocivyAuthenticateAPI)
    func authenticateDidFailWithError(socivyAPI:SocivyAuthenticateAPI, error:NSError)
}

class SocivyAuthenticateAPI: SocivyBaseAPI{
    
    var delegate: SocivyAuthenticateAPIDelegate?

    init(api: SocivyAPI) {
        super.init(path: "/authenticate", api:api)
    }
    
    func authenticate(email:String, password:String) {
        let payload:[String:String] = ["email":email, "password":password, "public_key": api.public_key]
        let postData = JSON(payload).toString(pretty: false)
        
        
        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary:["Content-Type":"application/json"], postData:postData, httpType:"POST")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.authenticateDidFailWithError(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        self.log("\n \(json.toString(pretty: true))")
        
        
        if json.isNull == false && json.isError == false {
            if json["info"]["status_code"].asInt == 1 {
                self.api.user_secret = json["result"]["user_secret"].asString
                self.api.access_token = json["result"]["access_token"].asString
                self.api.expireTime = json["result"]["expire_time"].asInt
                
                self.delegate?.authenticateDidFinish(self)
            }
            else if json["info"]["status_code"].asInt == 2 {
                let description:String = "Something terrible happened! \nFailed to login."
                let reason: String = "The operation timed out."
                let suggestion: String = "Have you tried turning it off and on again?"
                
                let userInfo: NSDictionary = [ NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason,NSLocalizedRecoverySuggestionErrorKey: suggestion]
                let error = NSError(domain:"com.tdg.dilixiri", code:-57, userInfo:userInfo)
                
                self.delegate?.authenticateDidFailWithError(self, error: error)
            }
        }
        else {
            self.log("parse error")
        }
        
   
        
    }
    
    
}
