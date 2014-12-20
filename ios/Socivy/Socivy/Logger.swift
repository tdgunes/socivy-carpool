//
//  Logger.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 10/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation


private let _LoggerInstance = Logger()

class Logger {
    let DEBUG:Bool = true
    
    func log(object:AnyObject, message:String){
        if DEBUG {
            println("[\(object)] \(message)")
        }
    }
    class var sharedInstance: Logger {
        return _LoggerInstance
    }
}