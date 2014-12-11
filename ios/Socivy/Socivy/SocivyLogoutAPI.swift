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
    
    init() {
        super.init(path: "/logout")
    }
    
    func logout() {
        self.log("login()")
        self.makeGETAuth()
    }
    
    override func requestFailWithError(errorCode: NetworkLibraryErrorCode, error: NSError?) {
        if let err = error {
            self.delegate?.logoutDidFailWithError(self, error: err)
        }
        else {
            self.log("errorCode:\(errorCode.rawValue)")
        }
    }
    
      override func requestDidFinish(response: NSMutableData) {
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