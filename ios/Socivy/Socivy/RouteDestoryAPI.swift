//
//  SocivyRouteAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyRouteDestoryAPIDelegate: SocivyBaseLoginAPIDelegate {
    func requestDidFinish(routeDestroyAPI:SocivyRouteDestoryAPI)
    func requestDidFail(routeDestoryAPI:SocivyRouteDestoryAPI, error:NSError)
}

class SocivyRouteDestoryAPI: SocivyBaseLoginAPI {
    var delegate: SocivyRouteDestoryAPIDelegate?
    var id: String?
    
    init(api:SocivyAPI){
        super.init(path: "/route/{id}", api: api)
    }
    
    func request(id:String){
        self.log("request")
        self.id = id
        let finalURL = self.url.stringByReplacingOccurrencesOfString("{id}", withString: self.id!, options: nil, range: nil)
        self.makeDELETEAuth(finalURL)
    }
    
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.requestDidFail(self, error: error)
    }

    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult {
        case .Success:
            self.delegate?.requestDidFinish(self)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.requestDidFail(self, error: error)
        }
    }
    
    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request(self.id!)
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }


}

