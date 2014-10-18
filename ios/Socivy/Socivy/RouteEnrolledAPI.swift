//
//  RouteEnrolledAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyRouteEnrolledAPIDelegate {
    func fetchDidFinish(routeEnrolledAPI:SocivyRouteEnrolledAPI, routes:JSON)
    func fetchDidFail(routeEnrolledAPI:SocivyRouteEnrolledAPI, error:NSError)
}

class SocivyRouteEnrolledAPI: SocivyBaseLoginAPI {
    
    var delegate: SocivyRouteEnrolledAPIDelegate?
    
    init(api:SocivyAPI){
        super.init(path: "/me/route/enrolled", api: api)
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




