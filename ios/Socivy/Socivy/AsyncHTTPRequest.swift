//
//  AsyncHTTPRequest.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

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
        if DEBUG {
            println("[async] \(url)")
        }
        self.url = NSURL(string: url)
        self.headerDictionary = headerDictionary
        self.postData = postData
        self.httpType = httpType
    }
    
    func start(){
        var urlRequest = NSMutableURLRequest(URL:self.url)
        urlRequest = self.prepareHTTPRequest(urlRequest)
        let conn = NSURLConnection(request:urlRequest, delegate: self, startImmediately: true)
        
        if DEBUG {
            println("[async] start()")
        }

        
    }
    
    func prepareHTTPRequest(urlRequest:NSMutableURLRequest) -> NSMutableURLRequest {
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.HTTPMethod = self.httpType
        
        if DEBUG {
            println("[async]  HTTPBody: '\(self.postData)'")
        }
        
        urlRequest.HTTPBody = self.postData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if DEBUG {
            println("[async] HTTPMethod: \(self.httpType)")
        }

        for (key,value) in self.headerDictionary {
            if DEBUG {
                println("[async] $POST['\(key)'] = '\(value)'")
            }
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
        if DEBUG {
            println("[async] didFinishLoading")
        }

        if let _responseData = responseData {
            
            self.delegate?.requestDidFinish(self,_responseData)
        }
        else {
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


