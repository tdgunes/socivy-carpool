//
//  LoginViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UITableViewController, SocivyAuthenticateAPIDelegate, SocivyLoginAPIDelegate, SocivyDeviceStoreAPIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailCell: TextFieldCell?
    @IBOutlet weak var passwordCell: TextFieldCell?
    
    @IBOutlet weak var loginCell:UITableViewCell?
    @IBOutlet weak var forgotPasswordCell:UITableViewCell?
    @IBOutlet weak var signupCell: UITableViewCell?
    
    weak var authenticateAPI = SocivyAPI.sharedInstance.authenticateAPI
    weak var loginAPI =  SocivyAPI.sharedInstance.loginAPI
    weak var deviceStoreAPI = SocivyAPI.sharedInstance.deviceStoreAPI
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if emailCell?.textField == textField {
            textField.resignFirstResponder()
            passwordCell!.textField!.becomeFirstResponder()        }
        else if passwordCell?.textField == textField {
            passwordCell?.textField!.resignFirstResponder()
            
            if DEBUG {
                println("[peek] loginCell touched")
                println("[peek] Email: \(emailCell?.textField?.text)")
                println("[peek] Password: \(passwordCell?.textField?.text)")
            }

            
            SocivyAPI.sharedInstance.authenticateAPI?.authenticate(self.emailCell!.textField!.text, password: self.passwordCell!.textField!.text)
            self.applyBackgroundProcessMode(true)
            
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.authenticateAPI?.delegate = self
        self.loginAPI?.delegate = self
        self.deviceStoreAPI?.delegate = self

        
        
        emailCell?.selectionStyle = .None
        passwordCell?.selectionStyle = .None
        loginCell?.selectionStyle = .None
        forgotPasswordCell?.selectionStyle = .None
        signupCell?.selectionStyle = .None
        

        

        
        self.activityIndicator.center = self.navigationController!.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)
        
   
        
        
        if self.authenticateAPI!.api.isUserSecretSaved()  {
            
            self.authenticateAPI?.api.loadUserSecret()
            self.loginAPI?.login()
            self.applyBackgroundProcessMode(true)
            self.storeDeviceToken()
        }
        
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
        if selectedCell == loginCell {
            
            if DEBUG {
                println("[peek] loginCell touched")
                println("[peek] Email: \(emailCell?.textField?.text)")
                println("[peek] Password: \(passwordCell?.textField?.text)")
            }
            
            SocivyAPI.sharedInstance.authenticateAPI?.authenticate(self.emailCell!.textField!.text, password: self.passwordCell!.textField!.text)
            self.applyBackgroundProcessMode(true)

        }
        else if selectedCell == forgotPasswordCell {
            if DEBUG {
                println("[peek] forgotPasswordCell touched")
            }
        }
        else if selectedCell == signupCell {
            if DEBUG {
                println("[peek] signupCell touched")
            }
        }
        
    }
    
    func storeDeviceToken() {
        if let deviceToken = socivyDeviceToken {
            self.deviceStoreAPI?.request(deviceToken)
        }
    }

    
    func loginDidFinish(socivyAPI:SocivyLoginAPI){
        self.applyBackgroundProcessMode(false)
        
        self.storeDeviceToken()
        
        self.showMainView()

    }
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.applyBackgroundProcessMode(false)
        
        var alertView = UIAlertView()
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func authDidFail(){
        
    }

    
    func showMainView() {
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as UIViewController
        self.presentViewController(main, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lostPassword"{
            var destinationController = segue.destinationViewController as WebViewController
            destinationController.navTitle = "Lost Password"
            destinationController.url = SocivyAPI.sharedInstance.forgotPassword
        }
    }

    
    
    func authenticateDidFinish(socivyAPI:SocivyAuthenticateAPI){
        if DEBUG {
            println("[peek] login did finish")
        }

        
        self.authenticateAPI?.api.saveUserSecret()
        self.applyBackgroundProcessMode(false)
        self.storeDeviceToken()
        self.showMainView()
    }
    
    func authenticateDidFailWithError(socivyAPI:SocivyAuthenticateAPI, error:NSError){
        self.authenticateAPI?.showError(error)
        self.applyBackgroundProcessMode(false)
    }
    
    func storeDidFinish(deviceStoreAPI:SocivyDeviceStoreAPI){
        if DEBUG {
            println("[loginView] storeDidFinish")
        }
    }
    func storeDidFail(deviceStoreAPI:SocivyDeviceStoreAPI){
        
    }

}