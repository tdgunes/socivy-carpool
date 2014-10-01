//
//  LoginViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UITableViewController, SocivyAPILoginDelegate {
    
    
    @IBOutlet weak var emailCell: TextFieldCell?
    @IBOutlet weak var passwordCell: TextFieldCell?
    
    @IBOutlet weak var loginCell:UITableViewCell?
    @IBOutlet weak var forgotPasswordCell:UITableViewCell?
    @IBOutlet weak var signupCell: UITableViewCell?
    
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailCell?.selectionStyle = .None
        passwordCell?.selectionStyle = .None
        loginCell?.selectionStyle = .None
        forgotPasswordCell?.selectionStyle = .None
        signupCell?.selectionStyle = .None
        
        SocivyAPI.sharedInstance.loginAPI?.delegate = self
        
        var tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.cancelsTouchesInView = true
        
        self.activityIndicator.center = self.navigationController!.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)
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
        }
        else {
            self.view.alpha = 1.0
            self.navigationController?.navigationBar.alpha = 1.0
            self.activityIndicator.stopAnimating()
        }
        
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == loginCell {
            println("[peek] loginCell touched")
            println("[peek] Email: \(emailCell?.textField?.text)")
            println("[peek] Password: \(passwordCell?.textField?.text)")
            
            SocivyAPI.sharedInstance.loginAPI?.authenticate("kalaomer@hotmail.com", password: "123123")
                self.applyBackgroundProcessMode(true)
            


        }
        else if selectedCell == forgotPasswordCell {
            println("[peek] forgotPasswordCell touched")
            
        }
        else if selectedCell == signupCell {
            println("[peek] signupCell touched")
        
        }
        
    }
    
    func loginDidFinish(socivyAPI:SocivyLoginAPI){
        println("[peek] login did finish")
        self.applyBackgroundProcessMode(false)
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as UIViewController
        self.presentViewController(main, animated: true, completion: nil)
    }
    func loginDidFailWithError(socivyAPI:SocivyLoginAPI, error:NSError){
        self.applyBackgroundProcessMode(false)
    
    }
    

}