//
//  SocivyAuthenticateAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


protocol SocivyAuthenticateAPIDelegate {
    func authenticateDidFinish(socivyAPI:SocivyAuthenticateAPI)
    func authenticateDidFailWithError(socivyAPI:SocivyAuthenticateAPI, error:NSError)
}

class SocivyAuthenticateAPI: SocivyBaseAPI{
    
    var delegate: SocivyAuthenticateAPIDelegate?

    init() {
        super.init(path: "/authenticate")
    }
    
    func authenticate(email:String, password:String) {
        let payload:[String:String] = ["email":email, "password":password, "public_key": api.public_key]
        self.makePOST(payload)
    }
    
    
    override func requestFailWithError(errorCode: NetworkLibraryErrorCode, error: NSError?) {
        if let err = error {
            self.delegate?.authenticateDidFailWithError(self, error: err)
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
            
            self.api.user_secret = json["result"]["user_secret"].asString
            self.api.access_token = json["result"]["access_token"].asString
            self.api.expireTime = json["result"]["expire_time"].asInt
            self.delegate?.authenticateDidFinish(self)
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.authenticateDidFailWithError(self, error:error)
        }

        
    }
    
    
}
