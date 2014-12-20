//
//  SocıvySettingsAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.


import Foundation

class SocivySettingsAPI {
    var networkLibraryFactory = APINetworkLibraryFactory()
    
    var delegate:SocivyBaseLoginAPIDelegate?
    
    init(){
        self.networkLibraryFactory.delegate = delegate
    }
    
    func fetchIndex(completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){
        var networkLibrary = self.networkLibraryFactory.generate(.setting, APINetworkLibraryHeader.withAccessToken, nil, .GET, completionHandler ,errorHandler)
        networkLibrary.request()
        
    }
    
    func store(name:String, password:String, phone:String, showPhone:Bool, completionHandler:((json:JSON)->()) ,errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){
        var payload:[String:AnyObject] = ["name":name, "information":["phone":phone], "route_settings":["show_phone":showPhone] ]
        if password != ""{ payload["password"] = password }
        let postData = JSON(payload).toString(pretty: false)
        
        var networkLibrary = self.networkLibraryFactory.generate(.setting, APINetworkLibraryHeader.withAccessTokenContentType, postData, .POST, completionHandler ,errorHandler)
        networkLibrary.request()
    }
}











