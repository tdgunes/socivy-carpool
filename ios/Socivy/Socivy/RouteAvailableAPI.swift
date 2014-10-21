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
    func authDidFail()
}

class SocivyAvailableRouteAPI: SocivyBaseLoginAPI{
    
    var delegate: SocivyAvailableRouteAPIDelegate?
    
    
    init(api:SocivyAPI) {
        super.init(path: "/me/route/available", api: api)
    }
    
    func request(){
        self.log("requestIndexRoutes")
        self.makeGETAuth()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult {
        case .Success:
            var routes = json["result"]
            self.delegate?.routesDidReturn(self, routes: routes)
        break
        case .InvalidAccessToken:
            self.loginAPI?.login()
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
        break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.routesDidFailWithError(self, error: error)
        }
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request()
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
    
    
}
