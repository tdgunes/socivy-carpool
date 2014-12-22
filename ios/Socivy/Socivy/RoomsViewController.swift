//
//  RoomsViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 22/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class RoomsViewController: UITableViewController {
    
    var communicator:Communicator?
    
    override func viewDidLoad() {
        self.communicator = Communicator(onRecieve: self.messageRecieved, onInterrupt: self.connectionFailed)
        self.communicator?.startConnection()
        self.communicator?.send("hello")
        
    }
    
    func messageRecieved(string:String){
        
    }
    func connectionFailed(){
        
    }
}
