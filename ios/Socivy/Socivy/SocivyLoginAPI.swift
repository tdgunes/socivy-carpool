//
//  SocivyLoginAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyLoginAPIDelegate {
    func loginDidFinish(socivyAPI:SocivyLoginAPI)
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError)
}

class SocivyLoginAPI: SocivyBaseAPI {
    var delegate: SocivyLoginAPIDelegate?
    
    init(api:SocivyAPI) {
        super.init(path: "/login", api: api)
    }

    func login() {
        self.log("login()")
        let payload:[String:String] = ["user_secret":self.api.user_secret!]
        self.makePOST(payload)
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.loginDidFailWithError(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding)!)
        let validationResult = SocivyErrorHandler(json:json).validate()

        switch validationResult{
        case .Success:
            self.api.access_token = json["result"]["access_token"].asString
            self.api.expireTime = json["result"]["expire_time"].asInt
            self.delegate?.loginDidFinish(self)
        break
        default:
            self.api.clearUserSecret()
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.loginDidFailWithError(self, error: error)
        break
        }

    }
}