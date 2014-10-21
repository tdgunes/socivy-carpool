//
//  IETTViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 21/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation

import UIKit

class IETTViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    

    
    var url:String = "https://docs.google.com/spreadsheets/d/1zhzQ8bQlyiQMvM5r731jzMu697JmhK3Y3CdiqR9SV78/edit?usp=sharing"
    
    
    func loadURL(){
        //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i.wrightscs.com"]]];
        var request = NSURLRequest(URL: NSURL(string: self.url))
        self.webView.loadRequest(request)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadURL()
    }
    override func viewDidAppear(animated: Bool) {
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.loadURL()

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
