//
//  SignupViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UITableViewController {
    
    @IBOutlet weak var nameSurnameCell:TextFieldCell?
    @IBOutlet weak var emailCell:TextFieldCell?
    @IBOutlet weak var passwordCell:TextFieldCell?
    @IBOutlet weak var phoneNumberCell:TextFieldCell?
    @IBOutlet weak var registerCell:UITableViewCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
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
    
    func register(){
        println("[peek] register touched")
        println("[peek] name: \(nameSurnameCell?.textField?.text)")
        println("[peek] email: \(emailCell?.textField?.text)")
        println("[peek] password: \(passwordCell?.textField?.text)")
        println("[peek] phoneNumber: \(phoneNumberCell?.textField?.text)")
        
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}