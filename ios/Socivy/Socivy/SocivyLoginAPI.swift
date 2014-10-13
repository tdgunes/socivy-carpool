//
//  SocivyLoginAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyLoginAPIDelegate {
    func loginDidFinish(socivyAPI:SocivyLoginAPI)
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError)
}

class SocivyLoginAPI: SocivyBaseAPI {
    var delegate: SocivyLoginAPIDelegate?
    
    init(api:SocivyAPI) {
        super.init(path: "/login", api: api)

    }

    func login() {
        self.log("login()")
        let payload:[String:String] = ["user_secret":self.api.user_secret!]
        let postData = JSON(payload).toString(pretty: false)
        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary:["Content-Type":"application/json"], postData:postData, httpType:"POST")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.loginDidFailWithError(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        self.log("\n \( NSString(data: response, encoding: NSASCIIStringEncoding))")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        self.log("\n \(json.toString(pretty: true))")
       

        if json.isNull == false && json.isError == false {
            if json["info"]["status_code"].asInt == 2 {
                self.delegate?.loginDidFailWithError(self, error: self.generateError())
            }
            else {
                self.api.access_token = json["result"]["access_token"].asString
                self.api.expireTime = json["result"]["expire_time"].asInt
                self.delegate?.loginDidFinish(self)
            }
        }
        else {
            self.log("parse error")
        }
    }
}