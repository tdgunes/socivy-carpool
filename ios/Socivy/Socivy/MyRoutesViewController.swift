//
//  MyRoutesViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 08/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MyRoutesViewController: UITableViewController, SocivyRouteSelfAPIDelegate  {
    
    weak var selfRouteAPI = SocivyAPI.sharedInstance.selfRouteAPI
    var routes:[Route] = []
    var tableRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var helpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
        
        self.selfRouteAPI?.delegate = self
        self.tableRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        self.selfRouteAPI?.fetch()
        
    }
    
    func fetchDidFinish(storeRouteApi:SocivyRouteSelfAPI, routes:JSON){
        self.routes = []
        let routeArray = routes.asArray! as [JSON]
        var index:Int = 0
        for route in routeArray {
            let placeArray = route["places"].asArray! as [JSON]
            
            var stops:[Stop] = []
            for place in placeArray{
                var stop = Stop(id:"ad", name: place["name"].asString!, location: CLLocationCoordinate2D(latitude:12.0 , longitude: 12.0))
                stops.append(stop)
            }
            let driverName = route["user"]["name"].asString
            var driver:User = User(name: driverName, cellphone: nil)
            
            var toOzu:Bool = false
            
            if route["plan"].asString! == "toSchool" {
                toOzu = true
            }
            
            let timestampStr = route["action_time"].asString!
            let timestamp: Double = (timestampStr as NSString).doubleValue as Double
            
            var route: Route = Route(id: route["id"].asString!, stops: stops, timestamp: timestamp, description: route["description"].asString!, toOzu: toOzu, driver: driver, seatLeft:route["seats"].asInt!)
            
            self.routes.append(route)
            println("\(index). \(route)")
            
            for stop in stops{
                println("  - \(stop.name)")
            }
            index += 1
            
        }
        
        if self.routes.count == 0 {
            helpLabel.hidden = false
        }
        else {
            helpLabel.hidden = true
        }
        
        println("[MyRoutesVC] self.routes.count = \(self.routes.count) ")
        self.tableView.reloadData()
        self.tableRefreshControl.endRefreshing()
    }
    func fetchDidFail(storeRouteApi:SocivyRouteSelfAPI, error:NSError){
        
    }
    
    func refreshControlRequest(){
        helpLabel.hidden = true
        self.selfRouteAPI?.fetch()
        self.updateTableView()
    }
    
    func updateTableView(){
        //        var formatter = NSDateFormatter()
        //        formatter.dateFormat = "MMM-d, h,:mm:ss-a"
        //        let lastUpdated = "Last updated on \(formatter.stringFromDate(NSDate()))"
        //        self.tableRefreshControl.attributedTitle = NSAttributedString(string: lastUpdated)
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var route = routes[indexPath.row]
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("RouteDetail") as RouteDetailViewController
        main.route = route
        self.navigationController?.pushViewController(main, animated: true)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RouteCell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath:indexPath) as RouteCell
        
        println("section:\(indexPath.section) row:\(indexPath.row)")
        var route = routes[indexPath.section]
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        cell.route = route
        
        cell.configureCell()
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.routes.count
    }
    
    
    @IBAction func showCategoryView(){
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var route = routes[indexPath.section]
        
        let height:CGFloat =  CGFloat(140+route.stops.count*45)
        return height
    }
    
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("tintColor") {
            if tableView == self.tableView {
                var cornerRadius:CGFloat = 5.0
                cell.backgroundColor = UIColor.clearColor()
                var layer:CAShapeLayer = CAShapeLayer()
                var pathRef = CGPathCreateMutable()
                var bounds = CGRectInset(cell.bounds, 10, 0)
                var addLine = false
                
                if indexPath.row == 0 && indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1 {
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius)
                }
                else if indexPath.row == 0 {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius)
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
                }
                else if indexPath.row == tableView.numberOfRowsInSection(indexPath.section)-1 {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius)
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius)
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
                }
                else {
                    CGPathAddRect(pathRef, nil, bounds);
                    addLine = true
                }
                
                layer.path = pathRef
                layer.fillColor = UIColor(white: 1.0, alpha: 0.8).CGColor
                
                if addLine == true {
                    var lineLayer = CALayer()
                    var lineHeight = (1.0/UIScreen.mainScreen().scale)
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight)
                    lineLayer.backgroundColor = tableView.separatorColor.CGColor
                    layer.addSublayer(lineLayer)
                }
                
                var testView = UIView(frame: bounds)
                testView.layer.insertSublayer(layer, atIndex: 0)
                testView.backgroundColor = UIColor.clearColor()
                cell.backgroundView = testView
            }
        }
        
    }
    
}