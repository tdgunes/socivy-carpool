//
//  SocivyAPI.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


protocol SocivyAPILoginDelegate {
    func loginDidFinish(socivyAPI:SocivyLoginAPI)
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError)
}

protocol AsyncHTTPRequestDelegate {
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError)
    func requestDidFinish(asyncHTTPRequest:AsyncHTTPRequest, _ response:NSMutableData)
}



class AsyncHTTPRequest: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    let timeoutInterval = 20.0
    var delegate : AsyncHTTPRequestDelegate?
    var responseData : NSMutableData? = NSMutableData()
    var url:NSURL
    var httpType:String
    var headerDictionary:[String:String]
    var postData:String
    
    init(url:String, headerDictionary:[String:String], postData:String, httpType:String){
        println("[async] \(url)")
        self.url = NSURL(string: url)
        self.headerDictionary = headerDictionary
        self.postData = postData
        self.httpType = httpType
    }
    
    func start(){
        var urlRequest = NSMutableURLRequest(URL:self.url)
        urlRequest = self.prepareHTTPRequest(urlRequest)
        let conn = NSURLConnection(request:urlRequest, delegate: self, startImmediately: true)
        println("[async] start()")

    }
    
    func prepareHTTPRequest(urlRequest:NSMutableURLRequest) -> NSMutableURLRequest {
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.HTTPMethod = self.httpType
        println("HTTP BODY \(self.postData)")
        urlRequest.HTTPBody = self.postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        println("[async] HTTPMethod: POST")
        for (key,value) in self.headerDictionary {
            println("[async] $POST['\(key)'] = \(value)")
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        return urlRequest
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        println("[async] didFinishLoading")
        if let _responseData = responseData {

            self.delegate?.requestDidFinish(self,_responseData)
        }
        else {
            println("[async] unknownError :( ")
            self.reportUnknownError()
        }
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.delegate?.requestFailWithError(self, error: error)
    }
    
    func reportUnknownError(){
        let description:String = "Operation was unsuccessful."
        let reason: String = "The operation timed out."
        let suggestion: String = "Have you tried turning it off and on again?"
        
        let userInfo: NSDictionary = [ NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason,NSLocalizedRecoverySuggestionErrorKey: suggestion]
        let error = NSError(domain:"com.tdg.dilixiri", code:-57, userInfo:userInfo)
        self.delegate?.requestFailWithError(self, error: error)
    }
    
}

class SocivyRouteAPI: AsyncHTTPRequestDelegate{
    
    unowned var api: SocivyAPI
    
    
    init(api:SocivyAPI) {
        self.api = api
        
    }
    
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
    }
    
    func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {

        
    }

}

class SocivyLoginAPI: AsyncHTTPRequestDelegate{
    
    var delegate: SocivyAPILoginDelegate?
    var asyncRequest:AsyncHTTPRequest?
    let path = "/authenticate"
    
    var url:String {
        get{
            return api.url + path
        }
    }
    
    
    unowned var api: SocivyAPI
    
    
    init(api:SocivyAPI) {
        self.api = api

    }
    
    func authenticate(email:String, password:String) {
        let payload:[String:String] = ["email":email, "password":password, "public_key": api.public_key]
        let postData = JSON(payload).toString(pretty: false)


        self.asyncRequest = AsyncHTTPRequest(url: self.url, headerDictionary:["Content-Type":"application/json"], postData:postData, httpType:"POST")
        self.asyncRequest?.delegate = self
        self.asyncRequest?.start()
    }
    
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.loginDidFailWithError(self, error: error)
    }

    func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        println("[login] requestDidFinish")

        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        println("[login] \n \(json.toString(pretty: true))")
     
        
        if json.isNull == false && json.isError == false {
            if json["info"]["status_code"].asInt == 1 {
                self.api.user_secret = json["result"]["user_secret"].asString
                self.api.acess_token = json["result"]["access_token"].asString
                self.delegate?.loginDidFinish(self)
            }
        }

        println("parse err")

      

        
        
    }
    
    
}


class SocivyAPI {
    let public_key:String = "$2y$10$9sI0wpjalK9B1tdDrdWyPe9PGvJquJ08l0UwSfgNgf3Aa6hvVJRmW"

    let url = "http://development.socivy.com/api/v1"
    
    
    var user_secret:String?
    var acess_token:String?
    
    var loginAPI:SocivyLoginAPI?
    var routeAPI:SocivyRouteAPI?

    
    class var sharedInstance : SocivyAPI {
        return _SingletonSocivyAPI
    }
    
    init(){
        self.loginAPI = SocivyLoginAPI(api: self)
        self.routeAPI = SocivyRouteAPI(api: self)
    }
    
}

let _SingletonSocivyAPI = SocivyAPI()
