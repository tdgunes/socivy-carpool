//
//  SocivyDeviceStore.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


protocol SocivyDeviceStoreAPIDelegate {
    func storeDidFinish(deviceStoreAPI:SocivyDeviceStoreAPI)
    func storeDidFail(deviceStoreAPI:SocivyDeviceStoreAPI)
}

class SocivyDeviceStoreAPI: SocivyBaseLoginAPI {
    var deviceToken:String = ""
    var delegate: SocivyDeviceStoreAPIDelegate?

    init(api:SocivyAPI) {
        super.init(path: "/device", api:api)
    }
    
    func request(deviceToken:String){
        self.log("[store] storeIndex")
        
        self.deviceToken = deviceToken
        let json = JSON(["device_token":deviceToken,"device_type":"ios"]).toString(pretty: false)
        
        self.asyncRequest = AsyncHTTPRequest(url: self.url,
            headerDictionary:["Access-token":self.api.access_token!,"Content-Type":"application/json"],
            postData:json,
            httpType:"POST")
        
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("[store] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        self.log("[store] info: \(info)")
        
        self.log("[store] raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 && json["info"]["error_code"].asInt  == 4 {
                self.log("[store] self.loginAPI?.login()")
                self.loginAPI?.login()
            }
            else if json["info"]["status_code"].asInt == 1 {
                var routes = json["result"]
                self.delegate?.storeDidFinish(self)
            }
            else {
                self.delegate?.storeDidFail(self)
            }
        }
        else {
            self.log("parse error")
        }
        
        
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request(self.deviceToken)
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        println("[route] loginDidFailWithError")
    }
    
    
}



