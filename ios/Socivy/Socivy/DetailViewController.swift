//
//  DetailViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 15/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UITableViewController, UIActionSheetDelegate, SocivyRouteDestoryAPIDelegate {
    
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    let lightFont =  UIFont(name:"FontAwesome",size:17)
    let boldFont = UIFont(name:"HelveticaNeue-Bold",size:17)
    
    var details = [ ["Driver:","Taha Dogan Gunes"], ["Time:","12.05.2014"], ["Seat Left:","1"], ["Description:","Arabamiz tupludur"], ["Destroy",""]]
    
    var passengers:[User] = []

    var stops = ["Istanbul", "Izmir", "Antalya"]
    var route: Route? {
        didSet {
            self.configureTableView()
        }
    }
    
    var destroyRouteAPI = SocivyRouteDestoryAPI(api:SocivyAPI.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)
        self.destroyRouteAPI.delegate = self

    }
    
    func requestDidFinish(routeDestroyAPI:SocivyRouteDestoryAPI){
        self.applyBackgroundProcessMode(false)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func requestDidFail(routeDestoryAPI:SocivyRouteDestoryAPI, error:NSError){
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
        self.passengers = self.route!.passengers
        
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
            
            
    
            case "Destroy":
                self.applyBackgroundProcessMode(false)
                self.destroyRouteAPI.request(self.route!.id)
//                self.requestRouteAPI?.request(route!.id)
//                self.applyBackgroundProcessMode(true)
            default:
                println("Another cell pressed, s:\(indexPath.section) r:\(indexPath.row)")
            }
            
            
        }
        
        
        else if indexPath.section == 1 {
            self.showContactSheet(indexPath)
        }
        
        
        
    }
    
    
    func showContactSheet(indexPath: NSIndexPath){
        let passenger:User = self.passengers[indexPath.row]
        
        var actionSheet = UIActionSheet(title: "Contact \(passenger.name)", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Message","Send Mail","Call", "SMS" )
        
        if passenger.isPhoneVisible == false {
            actionSheet = UIActionSheet(title: "Contact \(passenger.name)", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Message","Send Mail" )
        }
        
        println("\(passenger.isPhoneVisible)")
        
        actionSheet.showInView(self.view)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            self.showContactSheet(indexPath)
        }
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath:indexPath) as UITableViewCell
        if indexPath.section == 0{
            
            
            let values:Array = self.details[indexPath.row] as Array
            
            
            switch values[0] {
                

            case "Destroy":
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("DestroyCell", forIndexPath:indexPath) as UITableViewCell
            default:
                cell.detailTextLabel?.text = values[1]
                cell.textLabel?.text = values[0]
            }
            
            
            
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("PassengerCell", forIndexPath:indexPath) as UITableViewCell
            var string:NSMutableAttributedString = NSMutableAttributedString(string: "  \(self.passengers[indexPath.row].name)")
            
            string.addAttribute(NSFontAttributeName, value: self.lightFont, range: NSMakeRange(0, string.length))
            cell.textLabel?.attributedText = string

            
        }
        else if indexPath.section == 2 {
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath:indexPath) as UITableViewCell
            var string:NSMutableAttributedString = NSMutableAttributedString(string: "  \(self.stops[indexPath.row])")
            
            string.addAttribute(NSFontAttributeName, value: self.lightFont, range: NSMakeRange(0, string.length))
            cell.textLabel?.attributedText = string

            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.details.count
        }
        else if section == 1 {
            return self.passengers.count
        }
        else if section == 2{
            return self.stops.count
        }
        else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Details"
        }
        else if section == 1{
            return "Passengers"
        }
        else if section == 2{
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