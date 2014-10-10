//
//  AddRouteSecondViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 27/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class AddRouteSecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SocivyPlaceAPIDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    
    let lightFont =  UIFont(name:"FontAwesome",size:17)
    let boldFont = UIFont(name:"HelveticaNeue-Bold",size:17)

    var tableRefreshControl = UIRefreshControl()

    weak var placeAPI = SocivyAPI.sharedInstance.placeAPI
    
    var places:[Stop] = []
    var selectedPlaces:[String:Stop] = [:]
    
    func placesDidReturn(indexRouteAPI:SocivyPlaceAPI, places:JSON){
        self.places = []
        self.selectedPlaces = [:]
        let placeArray = places.asArray! as [JSON]

        for place in placeArray {
            let id = place["id"].asString!
            let name = place["name"].asString!
            let latitude = NSString(string:place["latitude"].asString!)
            let longitude = NSString(string:place["longitude"].asString!)

            var stop = Stop(id: id, name: name, location: CLLocationCoordinate2D(latitude:latitude.doubleValue, longitude: longitude.doubleValue))
            
            self.places.append(stop)
        }
        self.tableView.reloadData()
        self.tableRefreshControl.endRefreshing()
    }
    func placesDidFailWithError(indexRouteAPI:SocivyPlaceAPI, error:NSError){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
        
        self.placeAPI?.delegate = self

        self.tableRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        
        
        self.placeAPI?.requestPlaces()
    }
    
    func refreshControlRequest(){
        self.placeAPI?.requestPlaces()
    }

    
    
    @IBAction func saveTouched(sender: UIBarButtonItem) {
        var selectedPlacesArray = Array(self.selectedPlaces.values)
        
        println("saveTouched")
        for place in selectedPlacesArray{
            println(place.name)
        }
        
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableView.cellForRowAtIndexPath(indexPath)
        var string:NSMutableAttributedString = NSMutableAttributedString(string: cell!.textLabel!.text!)
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark){
            // delete added record
            
            println("self.selectedPlaces.removeValueForKey(\(self.places[indexPath.row].id))")
            self.selectedPlaces.removeValueForKey(self.places[indexPath.row].id)
            
            cell?.accessoryType = UITableViewCellAccessoryType.None
            string.addAttribute(NSFontAttributeName, value: self.lightFont, range: NSMakeRange(0, string.length))
            cell?.backgroundColor = UIColor.lightGrayColor()
            cell?.textLabel?.attributedText = string

        }
        else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            // add record
            
            println("self.selectedPlaces[\(self.places[indexPath.row].id)] = \(self.places[indexPath.row].name)")
            self.selectedPlaces[self.places[indexPath.row].id] = self.places[indexPath.row]
            
            string.addAttribute(NSFontAttributeName, value: self.boldFont, range: NSMakeRange(0, string.length))
            string.addAttribute(NSFontAttributeName, value: self.lightFont, range: NSMakeRange(0, 2))
            cell?.backgroundColor = UIColor.grayColor()
            cell?.textLabel?.attributedText = string
        }
        
    }
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath:indexPath) as UITableViewCell
        
        var string:NSMutableAttributedString = NSMutableAttributedString(string: "  \(self.places[indexPath.row].name)")

        string.addAttribute(NSFontAttributeName, value: self.lightFont, range: NSMakeRange(0, string.length))
        cell.textLabel?.attributedText = string
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        var route = routes[indexPath.section]
//        
//        let height:CGFloat =  CGFloat(140+route.stops.count*45)
//        return height
//    }
    
    
    
}