//
//  JoinViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class JoinViewController: UITableViewController, UIActionSheetDelegate {
    

    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    let lightFont =  UIFont(name:"FontAwesome",size:17)
    let boldFont = UIFont(name:"HelveticaNeue-Bold",size:17)
    
    var details = [ ["Driver:","Taha Dogan Gunes"], ["Time:","12.05.2014"], ["Seat Left:","1"], ["Description:","Arabamiz tupludur"]]
    
    var stops = ["Istanbul", "Izmir", "Antalya"]
    var route: Route? {
        didSet {
            self.configureTableView()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        

        self.activityIndicator.center = self.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)

     
    }
    
    func configureTableView() {

        self.details[0][1] = self.route!.driver.name!
        self.details[1][1] = "\(self.route!.getTime()!)"
        self.details[2][1] = "\(self.route!.seatLeft)"

        self.details[3][1] = "\(self.route!.details)"

        if self.route!.details == "" {
            self.details.removeLast()
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
        println("s:\(indexPath.section) r:\(indexPath.row)")
        
        
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        
        if self.route!.details == ""  && indexPath.section == 0 && indexPath.row == 4 {
            

                
                var actionSheet = UIActionSheet(title: "Contact the Driver", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Message","Send Mail","Call", "SMS" )
                
                actionSheet.showInView(self.view)
                

            
        }
        else if self.route!.details != ""  &&  indexPath.section == 0 && indexPath.row == 5 {
                
                var actionSheet = UIActionSheet(title: "Contact the Driver", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Message","Send Mail","Call", "SMS" )
                
                actionSheet.showInView(self.view)
                
            
            
            
        }


        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath:indexPath) as UITableViewCell
        if indexPath.section == 0{
            
        
            

            if indexPath.row == self.details.count {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("JoinCell", forIndexPath:indexPath) as UITableViewCell
            }
            else if indexPath.row == self.details.count+1 {
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath:indexPath) as UITableViewCell
            }
            else {
                let values:Array = self.details[indexPath.row] as Array
                
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
            return self.details.count+2
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