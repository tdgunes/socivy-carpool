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

class SocivyLoginAPI: AsyncHTTPRequestDelegate {
    
    var delegate: SocivyLoginAPIDelegate?
    var asyncRequest:AsyncHTTPRequest?
    let path = "/login"
    
    
    unowned var api: SocivyAPI
    var url:String {
        get{
            return api.url + path
        }
    }
    
    
    
    init(api:SocivyAPI) {
        self.api = api
    }
    

    func login() {
        let payload:[String:String] = ["user_secret":self.api.user_secret!]
        let postData = JSON(payload).toString(pretty: false)
        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary:["Content-Type":"application/json"], postData:postData, httpType:"POST")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.loginDidFailWithError(self, error: error)
    }
    
    func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        println("[login] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        println("[login] \n \(json.toString(pretty: true))")
        
        
        if json.isNull == false && json.isError == false {
            self.api.access_token = json["result"]["access_token"].asString
            self.api.expireTime = json["result"]["expire_time"].asInt
            self.delegate?.loginDidFinish(self)
        }
        else {
            println("parse err")
        }
        

        
    }
    


    
}