//
//  SocivyPlaceAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 10/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation



protocol SocivyPlaceAPIDelegate: SocivyBaseLoginAPIDelegate {
    func placesDidReturn(indexRouteAPI:SocivyPlaceAPI, places:JSON)
    func placesDidFailWithError(indexRouteAPI:SocivyPlaceAPI, error:NSError)
}


class SocivyPlaceAPI: SocivyBaseLoginAPI{
    
    var delegate: SocivyPlaceAPIDelegate?
    
    init(api:SocivyAPI) {
        super.init(path:"/place", api:api)
    }
    
    func requestPlaces(){
        self.log("requestPlaces")
        self.makeGETAuth()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.placesDidFailWithError(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding)!)
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            var places = json["result"]
            self.delegate?.placesDidReturn(self, places: places)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.placesDidFailWithError(self, error: error)
        }
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.requestPlaces()
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
}
