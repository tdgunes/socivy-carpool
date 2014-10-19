//
//  SocıvySettingAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


protocol SocivySettingIndexAPIDelegate {
    func fetchDidFinish(settingIndexAPI:SocivySettingIndexAPI, user:JSON)
    func fetchDidFail(settingIndexAPI:SocivySettingIndexAPI, error:NSError)
}

class SocivySettingIndexAPI: SocivyBaseLoginAPI {
    
    var delegate: SocivySettingIndexAPIDelegate?
    
    init(api:SocivyAPI){
        super.init(path: "/me/setting", api: api)
    }
    
    func fetch() {
        self.log("fetch")
        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary: ["Access-token":self.api.access_token!], postData: "", httpType: "GET")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        
        self.log(" raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 && json["info"]["error_code"].asInt == 4{
                println("[route] self.loginAPI?.login()")
                self.loginAPI?.login()
            }
            else if json["info"]["status_code"].asInt == 1 {
                var user = json["result"]
                self.delegate?.fetchDidFinish(self,user: user)
            }
        }
        else {
            self.log("parse error")
        }
    }
    
    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.fetch()
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.log("loginDidFailWithError")
    }
    
}




protocol SocivySettingStoreAPIDelegate {
    func storeDidFinish(ettingStoreAPI:SocivySettingStoreAPI)
    func storeDidFail(settingStoreAPI:SocivySettingStoreAPI, error:NSError)
}

class SocivySettingStoreAPI: SocivyBaseLoginAPI {
    
    var delegate: SocivySettingStoreAPIDelegate?
    var storedPost:String?
    
    init(api:SocivyAPI){
        super.init(path: "/me/setting", api: api)
    }
    
    func store(name:String, password:String, phone:String, showPhone:Bool) {
        self.log("fetch")
        var postData = ["name":name, "information":["phone":phone],
            "route_settings":["show_phone":showPhone] ]
            
        if password != ""{
           postData.setValue(password, forKey: "password")
        }
        
        self.storedPost = JSON(postData).toString(pretty: false)
        self.request()
    }
    
    func request(){
        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary: ["Access-token":self.api.access_token!,"Content-Type":"application/json"], postData:self.storedPost!, httpType: "POST")

        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        
        self.log(" raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 && json["info"]["error_code"].asInt == 4{
                println("[route] self.loginAPI?.login()")
                self.loginAPI?.login()
            }
            else if json["info"]["status_code"].asInt == 1 {
                var user = json["result"]
                self.delegate?.storeDidFinish(self)
            }
        }
        else {
            self.log("parse error")
        }
    }
    
    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request()
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.log("loginDidFailWithError")
    }
    
}










