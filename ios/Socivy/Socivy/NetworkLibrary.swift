//
//  NetworkLibrary.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 10/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case POST = "POST"
    case DELETE = "DELETE"
    case GET = "GET"
}



protocol LowLevelLayerDelegate {
    func requestFailWithError(error:NSError)
    func requestDidFinish(response:NSMutableData)
}


class LowLevelLayer: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var responseData : NSMutableData = NSMutableData()
    var delegate: LowLevelLayerDelegate?
    
    func request(urlRequest:NSMutableURLRequest){
        let conn = NSURLConnection(request:urlRequest, delegate: self, startImmediately: true)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.delegate?.requestDidFinish(responseData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.delegate?.requestFailWithError(error)
    }
    
}

protocol NetworkLibraryDelegate {
    func requestFailWithError(errorCode:NetworkLibraryErrorCode, error:NSError?)
    func requestDidFinish(response:NSMutableData)
}
enum NetworkLibraryErrorCode: Int {
    case MalformedURL = 0
    case HasNSError = 1
}


class NetworkLibrary : LowLevelLayerDelegate{
    // configuration
    let tag = "nlib"
    let timeoutInterval = 20.0 // seconds
    var delegate : NetworkLibraryDelegate?

    // request details
    var url:String
    var httpMethod:HTTPMethod
    var responseData : NSMutableData? = NSMutableData()
    var headers:[String:String]
    var postData:String?

    
    // handlers
    var completionHandler:((response:NSMutableData)->())?
    var errorHandler:((error:NSError, errorCode:NetworkLibraryErrorCode)->Void)?
    
    init(url:String, headers:[String:String], postData:String?, httpMethod:HTTPMethod){
        self.url = url
        self.headers = headers
        self.postData = postData
        self.httpMethod = httpMethod
    }
    
    func request(){
        var lowLevelLayer = LowLevelLayer()
        lowLevelLayer.delegate = self
        if let urlRequest = self.generateHTTPRequest(){
            lowLevelLayer.request(urlRequest)
        }
    }
    
    func requestDidFinish(response: NSMutableData) {
        self.delegate?.requestDidFinish(response)
        if let handler = self.completionHandler {
            handler(response: response)
        }
    }
    
    func requestFailWithError(error: NSError) {
        self.delegate?.requestFailWithError(.HasNSError, error:error)
        if let handler = self.errorHandler {
            handler(error: error, errorCode: .HasNSError)
        }
    }
    
    func generateHTTPRequest() -> NSMutableURLRequest? {
        Logger.sharedInstance.log(tag, message: url)
        
        if let url = NSURL(string:self.url){
            var urlRequest = NSMutableURLRequest(URL: url)
            
            Logger.sharedInstance.log(tag, message: "HTTP Body: '\(self.postData)'")
            Logger.sharedInstance.log(tag, message: "HTTP Method: '\(self.httpMethod.rawValue)'")
            
            urlRequest.timeoutInterval = timeoutInterval
            urlRequest.HTTPMethod = self.httpMethod.rawValue
            if let data = self.postData{
                urlRequest.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            }

            
            for (key,value) in self.headers {
                Logger.sharedInstance.log(tag, message: "$POST['\(self.httpMethod.rawValue)'] = '\(value)'")
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            
            return urlRequest
        }
        
        self.delegate?.requestFailWithError(NetworkLibraryErrorCode.MalformedURL, error:nil)
        return nil
    }
    
    
}