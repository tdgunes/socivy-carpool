//
//  SocivyStoreRouteAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
protocol SocivyStoreRouteAPIDelegate {
    func storeDidFinish(storeRouteApi:SocivyStoreRouteAPI)
    func storeDidFail(storeRouteApi:SocivyStoreRouteAPI)
}

class SocivyStoreRouteAPI: SocivyBaseLoginAPI {
    
    var rawPayload:[String:AnyObject] = [:]
    var delegate: SocivyStoreRouteAPIDelegate?
    
    init(api:SocivyAPI) {
        super.init(path: "/route", api:api)
    }
    
    func requestStoreRoute(routeObject:[String:AnyObject]){
        self.log("[store] storeIndex")
        self.rawPayload = routeObject
        let json = JSON(routeObject).toString(pretty: false)
        
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
        self.requestStoreRoute(self.rawPayload)
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        println("[route] loginDidFailWithError")
    }
    
    
}



