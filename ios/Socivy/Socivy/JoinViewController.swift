//
//  JoinViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class JoinViewController: UITableViewController, UIActionSheetDelegate, SocivyRouteRequestAPIDelegate,MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    

    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    let lightFont =  UIFont(name:"FontAwesome",size:17)
    let boldFont = UIFont(name:"HelveticaNeue-Bold",size:17)
    
    var details = [ ["Driver:","Taha Dogan Gunes"], ["Time:","12.05.2014"], ["Seat Left:","1"], ["Description:","Arabamiz tupludur"], ["Contact",""], ["Join",""]]
    
    var stops = ["Istanbul", "Izmir", "Antalya"]
    var route: Route? {
        didSet {
            self.configureTableView()
        }
    }

    weak var requestRouteAPI = SocivyAPI.sharedInstance.requestRouteAPI
    
    
    func authDidFail(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        

        self.activityIndicator.center = self.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)

        self.requestRouteAPI?.delegate = self
    }
    
    func requestDidFinish(routeRequestAPI:SocivyRouteRequestAPI){
      
        self.applyBackgroundProcessMode(false)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func requestDidFail(routeRequestAPI:SocivyRouteRequestAPI, error:NSError){
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
                self.showContactSheet(indexPath)
                
            case "Join":
                self.requestRouteAPI?.request(route!.id)
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
            case "Join":
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("JoinCell", forIndexPath:indexPath) as UITableViewCell
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
        let possibleButton = ContactSheet.fromRaw(buttonIndex)!
        
        switch possibleButton{
            
        case .Cancel:
            NSLog("Cancel")
            break
            

        case .SendMail:
            NSLog("SendMail");
            self.showEmail()
            break
            
        case .Call:
            NSLog("Call")
            self.call()
            break
            
        case .SMS:
            NSLog("SMS")
            self.sendSMS()
            break
            
        default:
            NSLog("Default")
            break
            
        }
        
    }
    
    func showContactSheet(indexPath: NSIndexPath){

        
        var actionSheet = UIActionSheet(title: "Contact \(self.route!.driver.name)", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Mail","Call", "SMS" )
        
        if self.route!.driver.isPhoneVisible == false {
            actionSheet = UIActionSheet(title: "Contact \(self.route!.driver.name)", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Mail" )
            
            
        }
        

        
        actionSheet.showInView(self.view)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            break;
            
        case MessageComposeResultFailed.value:
            //
            //                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //                [warningAlert show];
            break;
            
        case MessageComposeResultSent.value:
            break;
            
        default:
            break;
        }
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func call(){
        println("tel://\(self.route!.driver.phone)")
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(self.route!.driver.phone)"))
    }
    
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        if activityViewController.respondsToSelector("popoverPresentationController") {
            // iOS 8+
            let presentationController = activityViewController.popoverPresentationController
            presentationController?.sourceView = view
        }
        
    }
    
    @IBAction func share(sender: AnyObject) {
        let url = "\(SocivyAPI.sharedInstance.domain)/route/\(self.route!.id)"
        var destination = ""
        var stopsText = ", ".join(self.stops)
        var text = ""
        if route!.toOzu {
            text = "\(stopsText) → ÖzÜ \(self.route!.getTweetDate()) seat:\(self.route!.seatLeft) @Socivy @AntiShuttleOzu"
        }
        else {
            text = "ÖzÜ → \(stopsText) \(self.route!.getTweetDate()) seat:\(self.route!.seatLeft) @Socivy @AntiShuttleOzu"
        }
        println(text)
        var image = UIImage(named: "Socivy-Logo")
        self.shareTextImageAndURL(sharingText: text, sharingImage: image, sharingURL: NSURL(string:url))
    }
    
    
    
    func sendSMS(){
        
        var message = "Hello \(self.route!.driver.name),\n" +
        "\n\(SocivyAPI.sharedInstance.domain)/route/\(self.route!.id)"
        var toRecipents = [self.route!.driver.phone]
        
        var messageComposeVC: MFMessageComposeViewController = MFMessageComposeViewController()
        
        messageComposeVC.body = message
        messageComposeVC.recipients = toRecipents
        messageComposeVC.messageComposeDelegate = self
        
        self.presentViewController(messageComposeVC, animated: true, completion: nil)
    }
    
    func showEmail() {
        var emailTitle = "Socivy - Passenger"
        var messageBody = "Hello \(self.route!.driver.name)," +
        "</br></br>  </br></br><hr></br>Mentioned <a href='\(SocivyAPI.sharedInstance.domain)/route/\(self.route!.id)'>route</a>.</br>Send with <a href='\(SocivyAPI.sharedInstance.domain)'>Socivy.</a>"
        var toRecipents = [self.route!.driver.email]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: true)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.value:
            NSLog("Mail saved")
        case MFMailComposeResultSent.value:
            NSLog("Mail sent")
        case MFMailComposeResultFailed.value:
            NSLog("Mail sent failure: %@", [error.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}