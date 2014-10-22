//
//  SocivyRegisterAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 20/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//
//  error-handling: done

import Foundation

protocol SocivyRegisterAPIDelegate {
    func registerDidFinish()
    func registerDidFail(error:NSError)
}

class SocivyRegisterAPI: SocivyBaseAPI {
    
    var delegate: SocivyRegisterAPIDelegate?
    
    init(api: SocivyAPI){
        super.init(path: "/register", api: api)
    }
    
    func register(name:String, email:String, password:String, phone:String){
        var payload = ["name":name, "email":email, "password":password, "phone":phone,"public_key":self.api.public_key]
        self.makePOST(payload)
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){

    }
    override func requestDidFinish(asyncHTTPRequest:AsyncHTTPRequest, _ response:NSMutableData){
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding)!)
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            self.delegate?.registerDidFinish()
        break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.registerDidFail(error)
        }
    }
    
}