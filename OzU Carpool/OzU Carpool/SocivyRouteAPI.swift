//
//  SocivyRouteAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyIndexRouteAPIDelegate {
    func routesDidReturn(socivyRouteAPI:SocivyIndexRouteAPI, routes:JSON)
    func routesDidFailWithError(socivyRouteAPI:SocivyIndexRouteAPI, error:NSError)
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
