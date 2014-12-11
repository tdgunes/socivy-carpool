//
//  SocivyDeviceStore.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 18/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//
//  error-handling: done

import Foundation


protocol SocivyDeviceStoreAPIDelegate: SocivyBaseLoginAPIDelegate {
    func storeDidFinish(deviceStoreAPI:SocivyDeviceStoreAPI)
    func storeDidFail(deviceStoreAPI:SocivyDeviceStoreAPI)

}

class SocivyDeviceStoreAPI: SocivyBaseLoginAPI {
    var deviceToken:String = ""
    var delegate: SocivyDeviceStoreAPIDelegate?

    init() {
        super.init(path: "/device")
    }
    
    func request(deviceToken:String){
        self.log("[store] device_token")
        self.deviceToken = deviceToken
        let postData:[String:AnyObject] = ["device_token":deviceToken,"device_type":"ios"]
        self.makePOSTAuth(postData)
    }
    
    override func requestDidFinish(response: NSMutableData) {
        self.log("[store] requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding)!)
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            self.delegate?.storeDidFinish(self)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
        }
    }
    
    override func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request(self.deviceToken)
    }
}



