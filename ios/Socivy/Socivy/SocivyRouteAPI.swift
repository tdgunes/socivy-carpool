//
//  SocivyRouteAPI.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


class SocivyRouteAPI {

    var networkLibraryFactory = APINetworkLibraryFactory()
    
    var delegate:SocivyBaseLoginAPIDelegate?
    
    init(){
        self.networkLibraryFactory.delegate = delegate
    }
    
    func fetchSelf(completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
        var networkLibrary = self.networkLibraryFactory.generate(.selfURL, .withAccessToken, nil, .GET, completionHandler, errorHandler)
        networkLibrary.request()
    }
    
    func fetchEnrolled(completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
        var networkLibrary = self.networkLibraryFactory.generate(.enrolledURL, .withAccessToken, nil, .GET, completionHandler, errorHandler)
        networkLibrary.request()
    }
    
    func fetchAvailable(completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
        var networkLibrary = self.networkLibraryFactory.generate(.availableURL, .withAccessToken, nil, .GET, completionHandler, errorHandler)
        networkLibrary.request()
    }
    
    func destroy(id:String, completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
        var networkLibrary = self.networkLibraryFactory.generate(.destroyURL, .withAccessToken, nil, .DELETE, completionHandler, errorHandler, withReplacement: id)
        networkLibrary.request()
    }
    
    func store(routeObject:[String:AnyObject], completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
        let postData = JSON(routeObject).toString(pretty: false)
        var networkLibrary = self.networkLibraryFactory.generate(.storeURL, .withAccessTokenContentType, postData, .POST, completionHandler, errorHandler)
        networkLibrary.request()
    }
    
    func request(id:String, completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
        var networkLibrary = self.networkLibraryFactory.generate(.requestURL, .withAccessToken, nil, .GET, completionHandler, errorHandler, withReplacement:id)
        networkLibrary.request()
    }
    
    
//    func cancel(id:String,completionHandler:(json:JSON)->(),errorHandler:(error:NSError, errocode:NetworkLibraryErrorCode)->() ){
//        var networkLibrary = self.networkLibraryFactory.generate(.requestURL, .withAccessToken, nil, .GET, completionHandler, errorHandler, withReplacement:id)
//        networkLibrary.request()
//    }
    

}



