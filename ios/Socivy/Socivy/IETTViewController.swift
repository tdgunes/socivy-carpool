//
//  IETTViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 21/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class IETTViewController : UITableViewController, SocivyBaseLoginAPIDelegate {
    
    var toolAPI = SocivyToolAPI()
    var busList:[Bus] = []
    var tableRefreshControl = UIRefreshControl()
    
    
    override func viewWillAppear(animated: Bool) {
        self.updateTableView()
    }
    
    override func viewDidLoad() {
        self.toolAPI.delegate = self
        
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
    

    }

    func refreshControlRequest(){
        self.toolAPI.getBuses(self.busesDidReturn, errorHandler: self.busesDidFailWithError)

    }
    
    
    func updateTableView(){
        self.tableRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        self.toolAPI.getBuses(self.busesDidReturn, errorHandler: self.busesDidFailWithError)
    }
    
    
    func busesDidFailWithError( error: NSError, errorCode:NetworkLibraryErrorCode) {
        SocivyAPI.sharedInstance.showError(error)
    }
    
    func busesDidReturn( json: JSON) {
        self.busList = []
        
        var busArray = json["result"].asArray!
        for bus in busArray {
            
            let id = bus["id"].asString!
            let direction = bus["direction"].asString!
            let hours:[String] = bus["hours"].asStringArray!
            
            var busObject = Bus(id: id, direction: direction, hours: hours)
            
            self.busList.append(busObject)
        }
        
        self.tableView.reloadData()
        self.tableRefreshControl.endRefreshing()
    }
    
    func authDidFail(){
        SocivyAPI.sharedInstance.showSessionExpired()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("busCell", forIndexPath:indexPath) as UITableViewCell
        


        cell.textLabel?.text = self.busList[indexPath.section].hours[indexPath.row]
        return cell
        
    }
  
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let bus = self.busList[section]
        return  bus.id + " " + bus.direction
        
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.busList.count
    }
}
