//
//  SocıvySettingAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//
//  error-handling: done

import Foundation


protocol SocivySettingIndexAPIDelegate : SocivyBaseLoginAPIDelegate {
    func fetchDidFinish(settingIndexAPI:SocivySettingIndexAPI, user:JSON)
    func fetchDidFail(settingIndexAPI:SocivySettingIndexAPI, error:NSError)
}

class SocivySettingIndexAPI: SocivyBaseLoginAPI {
    var delegate: SocivySettingIndexAPIDelegate?
    
    init(api:SocivyAPI){
        super.init(path: "/me/setting", api: api)
    }
    
    func fetch() {
        self.log("fetch")
        self.makeGETAuth()
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.fetchDidFail(self, error: error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
        let validationResult = SocivyErrorHandler(json:json).validate()
        
        switch validationResult{
        case .Success:
            var user = json["result"]
            self.delegate?.fetchDidFinish(self,user: user)
            break
        case .InvalidAccessToken:
            self.loginAPI?.login()
            break
        case .InvalidUserSecret:
            self.delegate?.authDidFail()
            break
        default:
            var error = SocivyErrorFactory().create(validationResult)
            self.delegate?.fetchDidFail(self, error: error)
        }

    }

    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.fetch()
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
}

protocol SocivySettingStoreAPIDelegate  : SocivyBaseLoginAPIDelegate{
    func storeDidFinish(ettingStoreAPI:SocivySettingStoreAPI)
    func storeDidFail(settingStoreAPI:SocivySettingStoreAPI, error:NSError)
}

class SocivySettingStoreAPI: SocivyBaseLoginAPI {
    
    var delegate: SocivySettingStoreAPIDelegate?
    var storedPost:[String:AnyObject]?
    
    init(api:SocivyAPI){
        super.init(path: "/me/setting", api: api)

    }
    
    func store(name:String, password:String, phone:String, showPhone:Bool) {
        self.log("fetch")
        var postData:[String:AnyObject] = ["name":name, "information":["phone":phone],
            "route_settings":["show_phone":showPhone] ]
            
        if password != ""{
           postData["password"] = password
        }
        self.storedPost = postData
        
        self.request()
    }
    
    func request(){
        self.makePOSTAuth(self.storedPost!)
    }
    
    override func requestFailWithError(asyncHTTPRequest:AsyncHTTPRequest, error:NSError){
        self.delegate?.storeDidFail(self, error:error)
    }
    
    override func requestDidFinish(asyncHTTPRequest: AsyncHTTPRequest, _ response: NSMutableData) {
        self.log("requestDidFinish")
        
        let json = JSON.parse(NSString(data: response, encoding: NSASCIIStringEncoding))
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
            self.delegate?.storeDidFail(self, error: error)
        }
        
    }
    
    override  func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.request()
    }
    
    override  func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.delegate?.authDidFail()
    }
    
}










