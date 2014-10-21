//
//  RouteEnrolledAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyRouteEnrolledAPIDelegate: SocivyBaseLoginAPIDelegate {
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
        self.makeGETAuth()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.fetchDidFail(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            var routes = json["result"]
            self.delegate?.fetchDidFinish(self, routes: routes)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.fetchDidFail(self, error: error)
        }
    }
    
    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.fetch()
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
}




