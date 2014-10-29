//
//  SignupViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UITableViewController, SocivyRegisterAPIDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var registerCell:UITableViewCell?
    
    
    weak var registerAPI = SocivyAPI.sharedInstance.registerAPI
    
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerAPI?.delegate = self

        self.activityIndicator.center = self.navigationController!.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
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
            self.registerCell?.selected = false
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == registerCell {
            self.register()
        }
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.nameTextField.resignFirstResponder()
            self.emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField{
            self.emailTextField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            self.passwordTextField.resignFirstResponder()
            self.phoneTextField.becomeFirstResponder()
        }
        else if textField == phoneTextField {
            self.phoneTextField.resignFirstResponder()
            self.register()
        }
        
        return true
    }
    
    func register(){
        if DEBUG {
            println("[register] register touched")
        }

        
        self.registerAPI?.register(self.nameTextField.text, email: self.emailTextField.text, password: self.passwordTextField.text, phone: self.phoneTextField.text)
        self.applyBackgroundProcessMode(true)
        
    }
    
    func registerDidFail(error: NSError) {
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle("OK")
        alert.show()
        self.applyBackgroundProcessMode(false)
    }
    
    func registerDidFinish() {
        self.applyBackgroundProcessMode(false)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}