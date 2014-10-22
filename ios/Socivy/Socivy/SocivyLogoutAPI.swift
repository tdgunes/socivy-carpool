//
//  SocivyLogoutAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyLogoutAPIDelegate: SocivyBaseLoginAPIDelegate {
    func logoutDidFinish(socivyAPI:SocivyLogoutAPI)
    func logoutDidFailWithError(socivyAPI:SocivyLogoutAPI, error:NSError)
}

class SocivyLogoutAPI: SocivyBaseLoginAPI {
    var delegate: SocivyLogoutAPIDelegate?
    
    init(api:SocivyAPI) {
        super.init(path: "/logout", api: api)
    }
    
    func logout() {
        self.log("login()")
        self.makeGETAuth()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.logoutDidFailWithError(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")

        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding)!)
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            self.api.clearUserSecret()
            self.delegate?.logoutDidFinish(self)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.logoutDidFailWithError(self, error: error)
        }

    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.logout()
    
    }
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
}