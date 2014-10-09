//
//  SocivyRouteAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyIndexRouteAPIDelegate {
    func routesDidReturn(indexRouteAPI:SocivyIndexRouteAPI, routes:JSON)
    func routesDidFailWithError(indexRouteAPI:SocivyIndexRouteAPI, error:NSError)
}

protocol SocivyStoreRouteAPIDelegate {
    func storeDidFinish(storeRouteApi:SocivyStoreRouteAPI)
    func storeDidFail(storeRouteApi:SocivyStoreRouteAPI)
}

class SocivyStoreRouteAPI: AsyncHTTPRequestDelegate, SocivyLoginAPIDelegate {
    unowned var api: SocivyAPI
    
    
    var delegate: SocivyStoreRouteAPIDelegate?
    var asyncRequest:AsyncHTTPRequest?
    var loginAPI:SocivyLoginAPI?
    
    let path = "/route"

    var rawPayload:[String:AnyObject] = [:]
    
    var url:String {
        get{
            return api.url + path
        }
    }
    
    
    init(api:SocivyAPI) {
        self.api = api
        self.loginAPI = SocivyLoginAPI(api:self.api)
        self.loginAPI?.delegate = self
    }
    
    func requestStoreRoute(routeObject:[String:AnyObject]){
        println("[store-route] storeIndex")
        self.rawPayload = routeObject
        let json = JSON(routeObject).toString(pretty: false)

        
        self.asyncRequest = AsyncHTTPRequest(url: self.url,
            headerDictionary:["Access-token":self.api.access_token!],
            postData:json,
            httpType:"POST")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        println("[store-route] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        println("[store-route] info: \(info)")
        
        println("[store-route] raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 {
                println("[store-route] self.loginAPI?.login()")
                self.loginAPI?.login()
            }
            else{
                var routes = json["result"]
                self.delegate?.storeDidFinish(self)
            }
        }
        else {
            println("parse err")
        }
        
        
    }
    
    func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.requestStoreRoute(self.rawPayload)
    }
    
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        println("[route] loginDidFailWithError")
    }
    

}

class SocivyIndexRouteAPI: AsyncHTTPRequestDelegate, SocivyLoginAPIDelegate{
    
    unowned var api: SocivyAPI
    
    
    var delegate: SocivyIndexRouteAPIDelegate?
    var asyncRequest:AsyncHTTPRequest?
    var loginAPI:SocivyLoginAPI?
    
    let path = "/route"
    

    var url:String {
        get{
            return api.url + path
        }
    }
    
    
    init(api:SocivyAPI) {
        self.api = api
        self.loginAPI = SocivyLoginAPI(api:self.api)
        self.loginAPI?.delegate = self
    }
    
    func requestIndexRoutes(){
        println("[route] requestIndexRoutes")
        self.asyncRequest = AsyncHTTPRequest(url: self.url,
                                             headerDictionary:["Access-token":self.api.access_token!],
                                             postData:"",
                                             httpType:"GET")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        println("[route] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        println("[route] info: \(info)")
        
        println("[route] raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 {
                println("[route] self.loginAPI?.login()")
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
    
    func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.requestIndexRoutes()
    }
    
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        println("[route] loginDidFailWithError")
    }
    
}
