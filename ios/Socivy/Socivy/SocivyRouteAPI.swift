//
//  SocivyRouteAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyRouteSelfAPIDelegate {
    func fetchDidFinish(storeRouteApi:SocivyRouteSelfAPI, routes:JSON)
    func fetchDidFail(storeRouteApi:SocivyRouteSelfAPI, error:NSError)
}

class SocivyRouteSelfAPI: SocivyBaseLoginAPI  {
    var delegate: SocivyRouteSelfAPIDelegate?
    
    init(api:SocivyAPI){
        super.init(path: "/me/route/self", api: api)
    }
    
    func fetch(){
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
                var routes = json["result"]
                self.delegate?.fetchDidFinish(self,routes: routes)
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



protocol SocivyIndexRouteAPIDelegate {
    func routesDidReturn(indexRouteAPI:SocivyIndexRouteAPI, routes:JSON)
    func routesDidFailWithError(indexRouteAPI:SocivyIndexRouteAPI, error:NSError)
}

class SocivyIndexRouteAPI: SocivyBaseLoginAPI{
    

    
    
    var delegate: SocivyIndexRouteAPIDelegate?

    
    init(api:SocivyAPI) {
        super.init(path: "/route", api: api)
    }
    
    func requestIndexRoutes(){
        self.log("requestIndexRoutes")
        self.asyncRequest = AsyncHTTPRequest(url: self.url,
                                             headerDictionary:["Access-token":self.api.access_token!],
                                             postData:"",
                                             httpType:"GET")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("[index] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        self.log("[index] info: \(info)")
        
//        self.log("[index] raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 {
                self.log("[index] self.loginAPI?.login()")
                self.loginAPI?.login()
            }
            else{
                var routes = json["result"]
                self.delegate?.routesDidReturn(self, routes: routes)
            }
        }
        else {
            println("parse err")
        }

        
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.requestIndexRoutes()
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.log("loginDidFailWithError")
    }
    
    
    
}
