//
//  SettingsViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit


class SettingsViewController: UITableViewController, SocivyLogoutAPIDelegate{
    
    @IBOutlet weak var logoutCell: UITableViewCell?
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    weak var logoutAPI = SocivyAPI.sharedInstance.logoutAPI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.logoutAPI?.delegate = self
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "twitter"{
            var destinationController = segue.destinationViewController as WebViewController
            destinationController.navTitle = "Twitter"
            destinationController.url = "http://twitter.com/socivy"
        }
        else if segue.identifier == "facebook"{
            var destinationController = segue.destinationViewController as WebViewController
            destinationController.navTitle = "Facebook"
            destinationController.url = "http://facebook.com/socivycom"
        }
        else if segue.identifier == "blog"{
            var destinationController = segue.destinationViewController as WebViewController
            destinationController.navTitle = "Blog"
            destinationController.url = "http://blog.socivy.com"
        }
        else if segue.identifier == "rate" {
            var destinationController = segue.destinationViewController as WebViewController
            destinationController.navTitle = "Rate Us"
            destinationController.url = "http://ios.socivy.com"
        }
        else if segue.identifier == "about" {
            var destinationController = segue.destinationViewController as WebViewController
            destinationController.navTitle = "About"
            destinationController.url = "http://socivy.com"
        }
        
    }
    
    
    func logoutDidFinish(socivyAPI:SocivyLogoutAPI){
        self.applyBackgroundProcessMode(false)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func logoutDidFailWithError(socivyAPI:SocivyLogoutAPI, error:NSError){
        self.applyBackgroundProcessMode(false)
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
        if selectedCell == logoutCell {
            println("[peek] logout touched")
            
            self.logoutAPI?.logout()
            self.applyBackgroundProcessMode(true)
            
        }

        
    }
    
    
}