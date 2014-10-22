//
//  WebViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 21/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class WebViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    

    
    var navTitle:String?
    
    var url:String? {
        didSet{
//            self.loadURL()
        }
    }
    
    func loadURL(){
//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i.wrightscs.com"]]];
        var request = NSURLRequest(URL: NSURL(string: self.url!)!)
        self.webView.loadRequest(request)
    }
    
    override func viewDidAppear(animated: Bool) {


    }
    @IBAction func openInSafari(sender: UIBarButtonItem){
        UIApplication.sharedApplication().openURL(NSURL(string: self.url!)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.loadURL()
        self.navigationItem.title = navTitle!
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}