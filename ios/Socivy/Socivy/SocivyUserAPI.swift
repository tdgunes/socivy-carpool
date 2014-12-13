//
//  SocivyUserAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation





class SocivyUserAPI {
    var networkLibraryFactory = APINetworkLibraryFactory()
    
    var delegate:SocivyBaseLoginAPIDelegate?
    
    init(){
        self.networkLibraryFactory.delegate = delegate
    }
    
    func fetchLogin(completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->(), networkLibrary:NetworkLibrary?){

        var onLogin = {
            (json:JSON) -> () in
            SocivyAPI.sharedInstance.access_token = json["result"]["access_token"].asString
            SocivyAPI.sharedInstance.expireTime = json["result"]["expire_time"].asInt
            Logger.sharedInstance.log("fetchlogin", message: "onLogin")
            
            if let library = networkLibrary{
                library.updateAccessToken()
                library.request()
            }

        }
        
        var onError = {
             (error:NSError, errorCode:NetworkLibraryErrorCode)->()  in
             SocivyAPI.sharedInstance.clearUserSecret()
             errorHandler(error: error, errorCode: errorCode)
        }
        
        
        let payload = ["user_secret":SocivyAPI.sharedInstance.user_secret!]
        let postData = JSON(payload).toString(pretty: false)
        
        var networkLibrary = self.networkLibraryFactory.generate(.login, APINetworkLibraryHeader.withContentType, postData, .POST, onLogin, onError)
        
        networkLibrary.request()
    }

}
