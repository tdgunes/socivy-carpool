//
//  SocivyChatAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 24/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

class SocivyChatAPI {
    // api/v1/chat/
    
    var networkLibraryFactory = APINetworkLibraryFactory()
    
    var delegate:SocivyBaseLoginAPIDelegate?
    
    init(){
        self.networkLibraryFactory.delegate = delegate
        self.networkLibraryFactory.doValidation = false
        networkLibraryFactory.rootURL = "http://localhost:8000/api/v1/chat"
    }
    
    func getAllChatUser(completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){
        
        
        var payload:[String:String] = [ "email":SocivyAPI.sharedInstance.email!]
        let postData = JSON(payload).toString(pretty: false)
        
        var networkLibrary = self.networkLibraryFactory.generate(.getAllChatUser, APINetworkLibraryHeader.withAccessToken, postData, .POST, completionHandler ,errorHandler)
        networkLibrary.request()
        
    }
    

    
}