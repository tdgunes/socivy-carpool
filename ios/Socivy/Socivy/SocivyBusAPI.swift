//
//  SocivyBusAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 27/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyBusAPIDelegate: SocivyBaseLoginAPIDelegate {
    func busesDidReturn(busAPI:SocivyBusAPI, buses:JSON)
    func busesDidFailWithError(busAPI:SocivyBusAPI, error:NSError)
}

class Bus {
    var id:String
    var direction:String
    var hours:[String]
    
    init (id:String, direction:String, hours:[String]){
        self.id = id
        self.direction = direction
        self.hours = hours
    }
    
}

class SocivyBusAPI: SocivyBaseLoginAPI{
    
    var delegate: SocivyBusAPIDelegate?
    
    init() {
        super.init(path:"/bus")
    }
    
    func request(){
        self.log("requestBuses")
        self.makeGETAuth()
    }
    
    override func requestFailWithError(errorCode: NetworkLibraryErrorCode, error: NSError?) {
        if let err = error {
            self.delegate?.busesDidFailWithError(self, error: err)
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
            var places = json["result"]
            self.delegate?.busesDidReturn(self, buses: places)
            break
        case .InvalidAccessToken: 
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.busesDidFailWithError(self, error: error)
        }
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request()
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
}