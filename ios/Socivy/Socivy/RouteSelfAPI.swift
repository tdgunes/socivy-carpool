//
//  RouteSelfAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyRouteSelfAPIDelegate:SocivyBaseLoginAPIDelegate{
    func fetchDidFinish(routeSelfAPI:SocivyRouteSelfAPI, routes:JSON)
    func fetchDidFail(routeSelfAPI:SocivyRouteSelfAPI, error:NSError)
}


class SocivyRouteSelfAPI: SocivyBaseLoginAPI  {
    var delegate: SocivyRouteSelfAPIDelegate?
    
    init(){
        super.init(path: "/me/route/self")
    }
    
    func fetch(){
        self.log("fetch")
        self.makeGETAuth()
    }
    
    
    
    override func requestFailWithError(errorCode: NetworkLibraryErrorCode, error: NSError?) {
        if let err = error {
            self.delegate?.fetchDidFail(self, error: err)
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