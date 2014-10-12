//
//  SocivyPlaceAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 10/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation



protocol SocivyPlaceAPIDelegate {
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
        self.asyncRequest = AsyncHTTPRequest(url: self.url,
            headerDictionary:["Access-token":self.api.access_token!],
            postData:"",
            httpType:"GET")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
        
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        
        self.log("info: \(info)")
        self.log("raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 {
                self.log("self.loginAPI?.login()")
                
                self.loginAPI?.login()
            }
            else{
                var places = json["result"]
                self.delegate?.placesDidReturn(self, places: places)
            }
        }
        else {
            self.log("parse error")
        }
        
        
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.requestPlaces()
    }
    
    override func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.log("loginDidFailWithError")
    }
    
}
