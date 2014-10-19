//
//  SocivyLogoutAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyLogoutAPIDelegate {
    func logoutDidFinish(socivyAPI:SocivyLogoutAPI)
    func logoutDidFailWithError(socivyAPI:SocivyLogoutAPI, error:NSError)
}

class SocivyLogoutAPI: SocivyBaseLoginAPI {
    var delegate: SocivyLogoutAPIDelegate?
    
    init(api:SocivyAPI) {
        super.init(path: "/logout", api: api)
        
    }
    
    func logout() {
        self.log("login()")

        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary:["Access-token":self.api.access_token!], postData:"", httpType:"GET")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.logoutDidFailWithError(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        self.log("\n \( NSString(data: response, encoding: NSASCIIStringEncoding))")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        self.log("\n \(json.toString(pretty: true))")
        
        
        if json.isNull == false && json.isError == false {
            if json["info"]["status_code"].asInt == 2  {
                if json["info"]["error_code"].asInt == 4 {
                    self.loginAPI?.login()
                }
                self.delegate?.logoutDidFailWithError(self, error: self.generateError())
            }
            else {
                self.api.clearUserSecret()
                self.delegate?.logoutDidFinish(self)
            }
        }
        else {
            self.log("parse error")
        }
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.logout()
    
    }
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
    
    }
}