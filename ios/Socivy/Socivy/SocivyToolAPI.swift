//
//  SocivyToolAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 13/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//


import Foundation

class SocivyToolAPI {
    var networkLibraryFactory = APINetworkLibraryFactory()
    
    var delegate:SocivyBaseLoginAPIDelegate?
    
    init(){
        self.networkLibraryFactory.delegate = delegate
    }
    
    func getPlaces(completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){
        var networkLibrary = self.networkLibraryFactory.generate(.place, APINetworkLibraryHeader.withAccessToken, nil, .GET, completionHandler ,errorHandler)
        networkLibrary.request()
        
    }
    
    func storeDevice(deviceToken:String, completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){

        let payload:[String:AnyObject] = ["device_token":deviceToken,"device_type":"ios"]
        let postData = JSON(payload).toString(pretty: false)
        
        var networkLibrary = self.networkLibraryFactory.generate(.device, APINetworkLibraryHeader.withAccessTokenContentType, postData, .POST, completionHandler ,errorHandler)
        networkLibrary.request()
    }
    
    func getBuses(completionHandler:((json:JSON)->()),errorHandler:(error:NSError, errorCode:NetworkLibraryErrorCode)->()){
        var networkLibrary = self.networkLibraryFactory.generate(.bus, APINetworkLibraryHeader.withAccessToken, nil, .GET, completionHandler ,errorHandler)
        networkLibrary.request()
        
    }
}
