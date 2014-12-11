//
//  MeViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 05/11/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class MeViewController: UITableViewController, SocivyRouteSelfAPIDelegate,  SocivyRouteEnrolledAPIDelegate {
    var segmentedControl: UISegmentedControl?

    
    let upperBoundary = CGFloat(60)
    
    
    var selfRouteAPI = SocivyRouteSelfAPI()
    var enrolledRouteAPI = SocivyRouteEnrolledAPI()
    
    var routes:[Route] = []
    var tableRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var helpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
        
        self.selfRouteAPI.delegate = self
        self.enrolledRouteAPI.delegate = self
        
        
        self.loadTab()
    }
    
    
    func loadTab () {

        self.segmentedControl = UISegmentedControl(items: ["Joined Routes", "My Routes"])
        self.segmentedControl?.selectedSegmentIndex = 0
        
        self.segmentedControl?.addTarget(self, action:"tabTapped", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = self.segmentedControl
    }
    
    func tabTapped () {
        println(self.segmentedControl?.selectedSegmentIndex)

        self.tableRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        self.refreshControlRequest()
        
        

        
        if segmentedControl?.selectedSegmentIndex == 0 {
            self.helpLabel.text = "You are not currently joined to a route."
        }
        else if segmentedControl?.selectedSegmentIndex == 1{
            self.helpLabel.text = "You don't have a route at the moment."
        }
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidDisappear(animated)
        
 

        self.tableRefreshControl.beginRefreshing()
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        self.refreshControlRequest()

        

        self.tableView.reloadData()
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            var route = sender as Route
            if identifier == "leaveDetail"{

                var nextViewController: LeaveViewController = segue.destinationViewController as LeaveViewController

                nextViewController.route = route
                
            }
            else if identifier == "cancelDetail"{
                var nextViewController: DetailViewController = segue.destinationViewController as DetailViewController
                nextViewController.route = route
            }
        }
        
    }
    
    
    
    func fetchDidFinish(routeEnrolledAPI:SocivyRouteEnrolledAPI, routes:JSON){
        let routeArray = routes.asArray! as [JSON]
        var index:Int = 0
        for route in routeArray {
            var route: Route = Route(routeJson: route)
            self.routes.append(route)
            index += 1
        }
        if self.routes.count == 0 {
            helpLabel.hidden = false
        }
        else {
            helpLabel.hidden = true
        }
        
        
        self.tableView.reloadData()
        self.tableRefreshControl.endRefreshing()
    }
    
    func fetchDidFail(routeEnrolledAPI:SocivyRouteEnrolledAPI, error:NSError){
        
    }

    func fetchDidFinish(storeRouteApi:SocivyRouteSelfAPI, routes:JSON){

        let routeArray = routes.asArray! as [JSON]
        var index:Int = 0
        for route in routeArray {
            var route: Route = Route(routeJson: route)
            self.routes.append(route)
            index += 1
        }
        if self.routes.count == 0 {
            helpLabel.hidden = false
        }
        else {
            helpLabel.hidden = true
        }
        
        
        self.tableView.reloadData()
        self.tableRefreshControl.endRefreshing()
    }
    
    func fetchDidFail(storeRouteApi:SocivyRouteSelfAPI, error:NSError){
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func authDidFail() {
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Your session is expired."
        alert.addButtonWithTitle("OK")
        alert.show()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshControlRequest(){
        self.routes = []
        self.tableView.reloadData()
        helpLabel.hidden = true
        
        if segmentedControl?.selectedSegmentIndex == 0 {
            self.enrolledRouteAPI.fetch()
        }
        else if segmentedControl?.selectedSegmentIndex == 1{
            self.selfRouteAPI.fetch()
        }
        
//        self.selfRouteAPI?.fetch()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RouteCell = tableView.dequeueReusableCellWithIdentifier("RouteCell", forIndexPath:indexPath) as RouteCell
        
        
        Logger.sharedInstance.log(self, message: "section:\(indexPath.section) row:\(indexPath.row)")

        
        var route = routes[indexPath.section]
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.masksToBounds = true
        cell.route = route
        
        cell.configureCell()
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var route = routes[indexPath.section]
        
        if segmentedControl?.selectedSegmentIndex == 0 {
            self.performSegueWithIdentifier("leaveDetail", sender: route)
        }
        else if segmentedControl?.selectedSegmentIndex == 1{
            self.performSegueWithIdentifier("cancelDetail", sender: route)
        }
        

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.routes.count
    }
    
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var route = routes[indexPath.section]
        
        let height:CGFloat =  CGFloat(126+route.stops.count*45)
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