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
    var headerDictionary:[String:String]
    
    
    init(url:String, headerDictionary:[String:String]){
        self.url = NSURL(string: url)
        self.headerDictionary = headerDictionary
    }
    
    func start(){
        var urlRequest = NSMutableURLRequest(URL:self.url)
        self.prepareHTTPRequest(urlRequest)
        let conn = NSURLConnection(request:urlRequest, delegate: self, startImmediately: true)
    }
    
    func prepareHTTPRequest(urlRequest:NSMutableURLRequest) {
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.HTTPMethod = "POST"
        for (key,value) in self.headerDictionary {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let _responseData = responseData {
            self.delegate?.requestDidFinish(self,_responseData)
        }
        else {
            self.reportUnknownError()
        }
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
        let headerDictionary = ["email":email, "password":password, "publicKey": api.publicKey] as [String:String]
        self.asyncRequest = AsyncHTTPRequest(url: self.path, headerDictionary: headerDictionary)
        
    }
    
    func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        
        
    }

    func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        println(response)
    }
    
    
}


class SocivyAPI {
    let publicKey = 1234
    let url = "https://socivy.com/api/v1"
    var loginAPI:SocivyLoginAPI?

    
    init(){
        self.loginAPI = SocivyLoginAPI(api: self)
    }
    
}
