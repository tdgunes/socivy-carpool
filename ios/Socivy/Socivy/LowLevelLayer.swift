//
//  LowLevelLayer.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 22/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


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
