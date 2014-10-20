//
//  AccountSettingsController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 19/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit




class AccountSettingsController: UITableViewController, SocivySettingIndexAPIDelegate, SocivySettingStoreAPIDelegate, UITextFieldDelegate {
    
    var tableRefreshControl = UIRefreshControl()
    
    weak var settingIndexAPI = SocivyAPI.sharedInstance.settingIndexAPI
    weak var settingStoreAPI = SocivyAPI.sharedInstance.settingStoreAPI
    
    
    @IBOutlet weak var phoneNumberCell: UITextField!
    @IBOutlet weak var nameSurnameCell: SettingCell!
//    
    @IBOutlet weak var showPhoneCell: SegmentedControlCell!
    @IBOutlet weak var emailCell: UITextField!
    @IBOutlet weak var passwordCell: UITextField!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    @IBAction func cancelTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
  
    @IBOutlet weak var saveSettings: UITableViewCell!
    override func viewWillAppear(animated: Bool) {
        
        
        
    self.tableRefreshControl.beginRefreshing()

        
       self.settingIndexAPI?.fetch()
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
        self.settingIndexAPI?.delegate = self
        self.settingStoreAPI?.delegate = self
        
        self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentOffset.y-self.tableRefreshControl.frame.size.height), animated:true)
        
        
        self.tableRefreshControl.addTarget(self, action: "refreshControlRequest", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(self.tableRefreshControl)
        
        
    }
    
    
    func refreshControlRequest(){
       self.settingIndexAPI?.fetch()
    }

    
    

    
    func storeDidFinish(settingStoreAPI:SocivySettingStoreAPI){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.applyBackgroundProcessMode(false)
    }
    func storeDidFail(settingStoreAPI:SocivySettingStoreAPI, error:NSError){
        self.applyBackgroundProcessMode(false)
        self.settingStoreAPI?.showError(error)
    }
    
    func authDidFail() {
        // TODO, dismissView twice needed
    }
    
    func fetchDidFinish(settingIndexAPI:SocivySettingIndexAPI, user:JSON){
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
    func fetchDidFail(settingIndexAPI:SocivySettingIndexAPI, error:NSError){
        self.settingIndexAPI?.showError(error)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == saveSettings {
            
            var showPhone: Bool = true
            
            if self.showPhoneCell.segmentedControl?.selectedSegmentIndex == 1{
                showPhone = false
            }
            
            self.settingStoreAPI?.store(self.nameSurnameCell!.textField!.text, password: self.passwordCell!.text, phone:self.phoneNumberCell.text, showPhone: showPhone)
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