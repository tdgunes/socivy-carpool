//
//  SocivyStoreRouteAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyStoreRouteAPIDelegate : SocivyBaseLoginAPIDelegate {
    func storeDidFinish(storeRouteApi:SocivyStoreRouteAPI)
    func storeDidFail(storeRouteApi:SocivyStoreRouteAPI, error:NSError)
}

class SocivyStoreRouteAPI: SocivyBaseLoginAPI {
    var rawPayload:[String:AnyObject] = [:]
    var delegate: SocivyStoreRouteAPIDelegate?
    
    init() {
        super.init(path: "/route")
    }
    
    func requestStoreRoute(routeObject:[String:AnyObject]){
        self.log("[store] storeIndex")
        self.rawPayload = routeObject
        self.makePOSTAuth(self.rawPayload)
    }
    

    override func requestFailWithError(errorCode: NetworkLibraryErrorCode, error: NSError?) {
        if let err = error {
            self.delegate?.storeDidFail(self, error: err)
        }
        else {
            self.log("errorCode:\(errorCode.rawValue)")
        }
    }
    
    override func requestDidFinish(response: NSMutableData) {
        self.log("[store] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding)!)
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            self.delegate?.storeDidFinish(self)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.storeDidFail(self, error: error)
        }
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.requestStoreRoute(self.rawPayload)
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
    
}



