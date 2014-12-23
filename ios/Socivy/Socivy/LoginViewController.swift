//
//  LoginViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UITableViewController, SocivyBaseLoginAPIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailCell: TextFieldCell?
    @IBOutlet weak var passwordCell: TextFieldCell?
    
    @IBOutlet weak var loginCell:UITableViewCell?
    @IBOutlet weak var forgotPasswordCell:UITableViewCell?
    @IBOutlet weak var signupCell: UITableViewCell?
    
    var userAPI = SocivyUserAPI()

    var toolAPI = SocivyToolAPI()
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if emailCell?.textField == textField {
            textField.resignFirstResponder()
            passwordCell!.textField!.becomeFirstResponder()        }
        else if passwordCell?.textField == textField {
            passwordCell?.textField!.resignFirstResponder()
            
            Logger.sharedInstance.log("loginVC", message: "loginCell touched")
            Logger.sharedInstance.log("loginVC", message: "email: \(emailCell?.textField?.text)")
            
            
            self.userAPI.authenticate(self.emailCell!.textField!.text, password: self.passwordCell!.textField!.text, completionHandler: self.authenticateDidFinish, errorHandler: self.authenticateDidFailWithError)

            self.applyBackgroundProcessMode(true)
            
        }
        
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.navigationBarHidden = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        self.toolAPI.delegate = self
        self.userAPI.delegate = self
        
        
        emailCell?.selectionStyle = .None
        passwordCell?.selectionStyle = .None
        loginCell?.selectionStyle = .None
        forgotPasswordCell?.selectionStyle = .None
        signupCell?.selectionStyle = .None
        

        

        
        self.activityIndicator.center = self.navigationController!.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)
        
   
        
        
        if SocivyAPI.sharedInstance.isUserSecretSaved()  {

            SocivyAPI.sharedInstance.loadUserSecret()
            self.userAPI.delegate = self
            self.userAPI.login(self.loginDidFinish, errorHandler: self.loginDidFailWithError, networkLibrary: nil)
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
            
            self.userAPI.delegate = self
            self.userAPI.authenticate(self.emailCell!.textField!.text, password: self.passwordCell!.textField!.text, completionHandler: self.authenticateDidFinish, errorHandler: self.authenticateDidFailWithError)
            

            self.applyBackgroundProcessMode(true)

        }
        else if selectedCell == forgotPasswordCell {
            Logger.sharedInstance.log("loginVC", message: "forgotPasswordCell touched")
        }
        else if selectedCell == signupCell {
            Logger.sharedInstance.log("loginVC", message: "signupCell touched")
        }
        
    }
    
    func storeDeviceToken() {
        if let deviceToken = socivyDeviceToken {
            self.toolAPI.storeDevice(deviceToken, completionHandler: self.storeDidFinish, errorHandler: self.storeDidFail)
        }
    }

    
    func loginDidFinish(json:JSON){
        self.applyBackgroundProcessMode(false)
        
        self.storeDeviceToken()
        
        self.showMainView()

    }
    func loginDidFailWithError(error:NSError, errorCode:NetworkLibraryErrorCode){
        self.applyBackgroundProcessMode(false)
        
        var alertView = UIAlertView()
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func authDidFail(){
        self.applyBackgroundProcessMode(false)
        var alertView = UIAlertView()
        alert.title = "Session Expired"
        alert.message = "Please enter your credentials to log in!"
        alert.addButtonWithTitle("OK")
        alert.show()
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

    
    
    func authenticateDidFinish(json:JSON){
        Logger.sharedInstance.log("loginVC", message: "login did finish")


        
        SocivyAPI.sharedInstance.saveUserSecret()
        self.applyBackgroundProcessMode(false)
        self.storeDeviceToken()
        self.showMainView()
    }
    
    func authenticateDidFailWithError( error:NSError, errorCode:NetworkLibraryErrorCode){
        SocivyAPI.sharedInstance.showError(error)
        self.applyBackgroundProcessMode(false)
    }
    
    func storeDidFinish(json:JSON){
        Logger.sharedInstance.log("loginVC", message: "storeDidFinish")

    }
    func storeDidFail(error:NSError, errorCode:NetworkLibraryErrorCode){
        Logger.sharedInstance.log("loginVC", message: "storeDidFail")
    }

}