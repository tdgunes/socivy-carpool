//
//  SocivyRouteAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

protocol SocivyRouteDestoryAPIDelegate{
    func requestDidFinish(routeDestroyAPI:SocivyRouteDestoryAPI)
    func requestDidFail(routeDestoryAPI:SocivyRouteDestoryAPI, error:NSError)
}

class SocivyRouteDestoryAPI: SocivyBaseLoginAPI {
    var delegate: SocivyRouteDestoryAPIDelegate?
    var id: String?
    
    init(api:SocivyAPI){
        super.init(path: "/route/{id}", api: api)
    }
    
    func request(id:String){
        self.log("request")
        self.id = id
        let finalURL = self.url.stringByReplacingOccurrencesOfString("{id}", withString: self.id!, options: nil, range: nil)
        self.asyncRequest = AsyncHTTPRequest(url: finalURL, headerDictionary: ["Access-token":self.api.access_token!], postData: "", httpType: "DELETE")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }

    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let info = json["info"].toString(pretty: true)
        
        self.log(" raw: \(json.toString(pretty: true))")
        
        if json.isNull == false && json.isError == false {
            
            if json["info"]["status_code"].asInt == 2 && json["info"]["error_code"].asInt == 4{
                self.log("[route] self.loginAPI?.login()")
                self.loginAPI?.login()
            }
            else if json["info"]["status_code"].asInt == 1 {
                var routes = json["result"]
                self.delegate?.requestDidFinish(self)
            }
        }
        else {
            self.log("parse error")
        }
    }
    
    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request(self.id!)
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.log("loginDidFailWithError")
    }


}

