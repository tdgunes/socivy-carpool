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


class MyRoutesViewController: UITableViewController {
    
    var routes:[Route] = []
    var tableRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var helpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
        

    }
    
    func refreshControlRequest(){
        helpLabel.hidden = true
        self.updateTableView()
    }
    
    func updateTableView(){
        //        var formatter = NSDateFormatter()
        //        formatter.dateFormat = "MMM-d, h,:mm:ss-a"
        //        let lastUpdated = "Last updated on \(formatter.stringFromDate(NSDate()))"
        //        self.tableRefreshControl.attributedTitle = NSAttributedString(string: lastUpdated)
        
        helpLabel.hidden = false
        self.tableRefreshControl.endRefreshing()
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
        //        if route.toOzu == true{
        //            cell.detailTextLabel?.text = "\(route.selectedStop!.name!) -> ÖzÜ, \(route.driver!.name)"
        //        }
        //        else if route.toOzu == false {
        //            cell.detailTextLabel?.text = "ÖzÜ -> \(route.selectedStop!.name!) \(route.driver!.name)"
        //
        //        }
        //        cell.textLabel?.text = "\(route.getTime()!)"
        
        
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