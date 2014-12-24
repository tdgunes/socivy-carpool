//
//  MessagesViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 24/12/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MessagesViewController: UIViewController{
    
    @IBOutlet weak var messageBarView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        self.tabBarController?.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        
        self.addUpperBorder()
    }
    
    // http://stackoverflow.com/questions/17355280/how-to-add-a-border-just-on-the-top-side-of-a-uiview
    func addUpperBorder() {
        var upperBorder = CALayer()
        upperBorder.backgroundColor = UIColor.blackColor().CGColor
        upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.messageBarView.frame), 1.0)
        upperBorder.borderWidth = 0.1
        upperBorder.opacity = 0.1
        messageBarView.layer.addSublayer(upperBorder)
    }
}