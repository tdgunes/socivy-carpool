//
//  LeaveViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 13/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class LeaveViewController: UITableViewController, UIActionSheetDelegate, SocivyRouteCancelAPIDelegate {
    
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    let lightFont =  UIFont(name:"FontAwesome",size:17)
    let boldFont = UIFont(name:"HelveticaNeue-Bold",size:17)
    
    var details = [ ["Driver:","Taha Dogan Gunes"], ["Time:","12.05.2014"], ["Seat Left:","1"], ["Description:","Arabamiz tupludur"], ["Contact",""], ["Leave",""]]
    
    var stops = ["Istanbul", "Izmir", "Antalya"]
    var route: Route? {
        didSet {
            self.configureTableView()
        }
    }
    
    weak var cancelRouteAPI = SocivyAPI.sharedInstance.cancelRouteAPI
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)
        
        self.cancelRouteAPI?.delegate = self
    }
    
    func requestDidFinish(routeCancelAPI:SocivyRouteCancelAPI){
        
        self.applyBackgroundProcessMode(false)

        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func requestDidFail(routeCancelAPI:SocivyRouteCancelAPI, error:NSError){
        self.applyBackgroundProcessMode(false)
    }
    
    func configureTableView() {
        
        self.details[0][1] = self.route!.driver.name
        self.details[1][1] = "\(self.route!.getTime()!)"
        self.details[2][1] = "\(self.route!.seatLeft)"
        
        self.details[3][1] = "\(self.route!.details)"
        
        if self.route!.details == "" {
            self.details.removeAtIndex(3)
        }
        
        self.stops = []
        
        var stopArray = self.route!.stops
        for stop in stopArray {
            self.stops.append(stop.name)
        }
        
        if self.route!.toOzu {
            self.navigationItem.title = "Goes To ÖzÜ"
        }
        else {
            self.navigationItem.title = "Departs From ÖzÜ"
        }
        
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func applyBackgroundProcessMode(mode:Bool){
        if mode == true {
            self.view.alpha = 0.4
            self.navigationController?.navigationBar.alpha = 0.3
            self.activityIndicator.startAnimating()
            self.tableView.userInteractionEnabled = false
        }
        else {
            self.view.alpha = 1.0
            self.navigationController?.navigationBar.alpha = 1.0
            self.activityIndicator.stopAnimating()
            self.tableView.userInteractionEnabled = true
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        
        if indexPath.section == 0 {
            
            let values:Array = self.details[indexPath.row] as Array
            
            
            switch values[0] {
                
            case "Contact":
                var actionSheet = UIActionSheet(title: "Contact the Driver", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Message","Send Mail","Call", "SMS" )
                
                actionSheet.showInView(self.view)
                
            case "Leave":
                self.cancelRouteAPI?.request(route!.id)
                self.applyBackgroundProcessMode(true)
            default:
                println("Another cell pressed, s:\(indexPath.section) r:\(indexPath.row)")
            }
            
            
        }
        
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath:indexPath) as UITableViewCell
        if indexPath.section == 0{
            
            
            let values:Array = self.details[indexPath.row] as Array
            
            
            switch values[0] {
                
            case "Contact":
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath:indexPath) as UITableViewCell
            case "Leave":
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("LeaveCell", forIndexPath:indexPath) as UITableViewCell
            default:
                cell.detailTextLabel?.text = values[1]
                cell.textLabel?.text = values[0]
            }
            
            
            
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath:indexPath) as UITableViewCell
            var string:NSMutableAttributedString = NSMutableAttributedString(string: "  \(self.stops[indexPath.row])")
            
            string.addAttribute(NSFontAttributeName, value: self.lightFont, range: NSMakeRange(0, string.length))
            cell.textLabel?.attributedText = string
            cell.backgroundColor = UIColor.grayColor()
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.details.count
        }
        else if section == 1{
            return self.stops.count
        }
        else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Details"
        }
        else if section == 1{
            return "Stops"
        }
        else {
            return ""
        }
    }
    
    
    //
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //
    //        if indexPath.section == 0 {
    //
    //        }
    //
    //        let height:CGFloat =  CGFloat(44)
    //        return height
    //    }
    //
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("Done");
            break;
        case 1:
            NSLog("Cancel");
            break;
        case 2:
            NSLog("Yes");
            break;
        case 3:
            NSLog("No");
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    
    
}