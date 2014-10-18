//
//  SocivyAvailableRouteAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyAvailableRouteAPIDelegate {
    func routesDidReturn(indexRouteAPI:SocivyAvailableRouteAPI, routes:JSON)
    func routesDidFailWithError(indexRouteAPI:SocivyAvailableRouteAPI, error:NSError)
}

class SocivyAvailableRouteAPI: SocivyBaseLoginAPI{
    
    var delegate: SocivyAvailableRouteAPIDelegate?
    
    
    init(api:SocivyAPI) {
        super.init(path: "/me/route/available", api: api)
    }
    
    func request(){
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
        self.request()
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.log("loginDidFailWithError")
    }
    
    
    
}
