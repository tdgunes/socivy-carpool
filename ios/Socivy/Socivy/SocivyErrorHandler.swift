//
//  SocivyErrorHandler.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 20/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


enum SocivyAPIStatusCode: Int {
    case Error = 0
    case Success = 1
}

enum SocivyAPIErrorCode: Int {
    case InputError = 0
    case InvalidUserSecret = 1
    case InvalidAccessToken = 2
    case MethodNotAllowed = 3
}

enum SocivyJSONCode: Int {
    case ParseError = 0
    case ParseSuccessful = 1
}

enum SocivyErrorCode: Int {
    case JSONParseError = 0
    case InputError = 1
    case InvalidUserSecret = 2
    case InvalidAccessToken = 3
    case MethodNotAllowed = 4
    case Success = 5
    case NoStatusCode = 6
    case NoErrorCode = 7
    case NoInfo = 8

}

class SocivyErrorFactory{
    func create(error:SocivyErrorCode)->NSError{
        
        var description:String = "Something terrible happened! \nFailed to login."
        var reason: String = "The operation timed out."
        var suggestion: String = "Have you tried turning it off and on again?"

        
        switch error {
        case .JSONParseError:
            description = "Our server is dizzy today!, \n Why don't you try it later?"
        break
        default:
            description = "Something terrible happened. \n Error code: 0x000\(error.toRaw())"
        break
        }
        
        let userInfo: NSDictionary = [ NSLocalizedDescriptionKey: description, NSLocalizedFailureReasonErrorKey: reason,NSLocalizedRecoverySuggestionErrorKey: suggestion]
        return NSError(domain:"com.tdg.Socivy", code:0, userInfo:userInfo)
    }
}

class SocivyErrorHandler{
    
    var json:JSON
    
    init(json:JSON){
        self.json = json
        println(self.json.toString(pretty: true))
    }
    
    func validate()->SocivyErrorCode{
        let jsonCode = self.validateJSON()
        
        switch jsonCode {
        case .ParseSuccessful:
            if let errorCode = self.handleInfo() {
                return errorCode
            }
            else {
                return SocivyErrorCode.Success
            }
        case .ParseError:
            return SocivyErrorCode.JSONParseError
        }
    }
    
    func handleInfo()->SocivyErrorCode? {
        if let info = self.json["info"].asDictionary{
            if let status_code  = self.json["info"]["status_code"].asInt{
                
                let statusCode = SocivyAPIStatusCode.fromRaw(status_code)!
                switch statusCode {
                case .Error:
                    return self.identifyError()
                case .Success:
                    return nil
                }
            }
            else {
                return SocivyErrorCode.NoStatusCode
            }
        }
        else {
            return SocivyErrorCode.NoInfo
        }
    }
    
    func identifyError()->SocivyErrorCode{
        if let error_code = self.json["info"]["error_code"].asInt {
            let errorCode = SocivyAPIErrorCode.fromRaw(error_code)!
            
            switch errorCode{
            case .InputError:
                return SocivyErrorCode.InputError
            case .InvalidUserSecret:
                return SocivyErrorCode.InvalidUserSecret
            case .InvalidAccessToken:
                return SocivyErrorCode.InvalidAccessToken
            case .MethodNotAllowed:
                return SocivyErrorCode.MethodNotAllowed
            }

        }
        else {
            return SocivyErrorCode.NoErrorCode
        }
    }
    
    func validateJSON()->SocivyJSONCode{
        if json.isNull == false && json.isError == false {
            return SocivyJSONCode.ParseSuccessful
        }
        return SocivyJSONCode.ParseError
    }
    
}