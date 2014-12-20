//
//  AccountSettingsController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit




class AccountSettingsController: UITableViewController, SocivyBaseLoginAPIDelegate, UITextFieldDelegate {
    
    var tableRefreshControl = UIRefreshControl()
    
    var settingsAPI = SocivySettingsAPI()

    
    
    @IBOutlet weak var phoneNumberCell: UITextField!
    @IBOutlet weak var nameSurnameCell: SettingCell!
    @IBOutlet weak var showPhoneCell: SegmentedControlCell!
    @IBOutlet weak var emailCell: UITextField!
    @IBOutlet weak var passwordCell: UITextField!
    @IBOutlet weak var saveSettings: UITableViewCell!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    @IBAction func cancelTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableRefreshControl.beginRefreshing()
        self.refreshControlRequest()
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameSurnameCell!.textField {
            textField.resignFirstResponder()
            passwordCell.becomeFirstResponder()

        }
        else if textField == passwordCell {
            passwordCell.resignFirstResponder()
            phoneNumberCell.becomeFirstResponder()
        }
        else if textField == phoneNumberCell{
            phoneNumberCell.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        self.settingsAPI.delegate = self

    
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.tableRefreshControl)
    }
    
    func refreshControlRequest(){
        self.settingsAPI.fetchIndex(self.fetchDidFinish, errorHandler: self.fetchDidFail)
    }

    
    func storeDidFinish(json:JSON){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.applyBackgroundProcessMode(false)
    }
    func storeDidFail(error:NSError, errorCode:NetworkLibraryErrorCode){
        self.applyBackgroundProcessMode(false)
        SocivyAPI.sharedInstance.showError(error)
    }
    
    func authDidFail() {
        // TODO, dismissView twice needed
    }
    
    func fetchDidFinish(json:JSON){
        let user = json["result"]
        var email = user["email"].asString!
        var name = user["name"].asString!
        var phone = user["information"]["phone"].asString!
        
        self.showPhoneCell.segmentedControl?.selectedSegmentIndex = 0
        if user["route_settings"]["show_phone"].asString! == "0" {
            self.showPhoneCell.segmentedControl?.selectedSegmentIndex = 1
        }
        
        self.emailCell!.text = email
        self.nameSurnameCell!.textField!.text = name
        self.phoneNumberCell!.text = phone

        
        
        self.tableRefreshControl.endRefreshing()

    }
    func fetchDidFail(error:NSError, errorCode:NetworkLibraryErrorCode){
        SocivyAPI.sharedInstance.showError(error)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == saveSettings {
            
            var showPhone: Bool = true
            
            if self.showPhoneCell.segmentedControl?.selectedSegmentIndex == 1{
                showPhone = false
            }
            
            self.settingsAPI.store(self.nameSurnameCell!.textField!.text, password: self.passwordCell!.text, phone:self.phoneNumberCell.text, showPhone: showPhone, completionHandler: self.storeDidFinish, errorHandler: self.storeDidFail)

            self.applyBackgroundProcessMode(true)
        }
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

}