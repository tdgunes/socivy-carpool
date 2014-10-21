//
//  MainTabBarController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController : UITabBarController {
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        
        if DEBUG {
            println("[peek] Main loaded")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}