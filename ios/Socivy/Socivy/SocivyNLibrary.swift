//
//  SocivyNLibrary.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


enum APINetworkLibraryHeader {
    case withAccessToken
    case withContentType
    case withAccessTokenContentType
}



class APINetworkLibraryFactory {
    var url: String = ""
    var headers: [String:String] = [:]
    var delegate: SocivyBaseLoginAPIDelegate?
    var replacement:String?
    init(){
        
    }
    
    func generate(apiMethod:SocivyAPIMethod,
        _ header:APINetworkLibraryHeader,
        _ postData:String?, _ method:HTTPMethod,
        _ completionHandler:(json:JSON)->(),
        _ errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->(),withReplacement replacement:String? = nil)->NetworkLibrary{
            self.replacement = replacement
            self.finalizeHeader(header)
            self.finalizeURL(apiMethod)
            
            var networkLibrary = NetworkLibrary(url: self.url, headers: self.headers, postData: postData, httpMethod: method)
            
            self.finalizeCompletionHandler(networkLibrary, completionHandler: completionHandler, errorHandler: errorHandler)

            
            return networkLibrary
    }
    
    
    func finalizeCompletionHandler(networkLibrary:NetworkLibrary, completionHandler:(json:JSON)->(),
        errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->()){
            
            var finalHandler = { (response:NSMutableData)->() in
                Logger.sharedInstance.log("finalhandler", message: "Got Response")
                var responseAsText = NSString(data: response, encoding: NSASCIIStringEncoding)!
                Logger.sharedInstance.log("finalhandler", message: responseAsText)
                let json = JSON.parse(responseAsText)
                let validationResult = SocivyErrorHandler(json:json).validate()
                Logger.sharedInstance.log("finalhandler", message: "validationResult: \(validationResult.rawValue)")
                switch validationResult{
                case .Success:
                    completionHandler(json: json)
                    break
                case .InvalidAccessToken:
                    var userAPI = SocivyUserAPI()
                    Logger.sharedInstance.log("finalhandler", message: "invalidAccessToken")
                    userAPI.login(nil, errorHandler: errorHandler, networkLibrary:networkLibrary)
                    // self.loginAPI?.login() <- give completionHandler
                    break
                case .InvalidUserSecret:
                    Logger.sharedInstance.log("finalhandler", message: "invalidUserSecret")
                    self.delegate?.authDidFail()
                    break
                default:

                    var error = SocivyErrorFactory().create(validationResult)
                    errorHandler(error: error, errocode: NetworkLibraryErrorCode.HasNSError)
                }
                
            }
            networkLibrary.errorHandler = errorHandler
            networkLibrary.completionHandler = finalHandler
    }
    
    
    func finalizeURL(method:SocivyAPIMethod){
        self.url =  "\(SocivyAPI.sharedInstance.url)\(method.rawValue)"
        if let replacementString = self.replacement {
            self.url = self.url.stringByReplacingOccurrencesOfString("{id}", withString: replacementString, options: nil, range: nil)
        }
    }
    
    
    func finalizeHeader(header:APINetworkLibraryHeader){
        switch (header) {
        case .withAccessToken:
            self.includeAccessToken()
            break
        case .withContentType:
            self.includeContentType()
            break
        case .withAccessTokenContentType:
            self.includeContentType()
            self.includeAccessToken()
            break
        }
    }
    
    func includeAccessToken(){
        if let token = SocivyAPI.sharedInstance.access_token {
            headers["Access-token"] = token
        }

    }
    
    func includeContentType(){
        headers["Content-Type"] = "application/json"
    }
    
    
}