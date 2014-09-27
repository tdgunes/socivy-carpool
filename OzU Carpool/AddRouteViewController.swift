//
//  AddRouteViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 27/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddRouteViewController: UITableViewController {
    
    @IBOutlet weak var segmentedCell: SegmentedControlCell!
    @IBOutlet weak var datePickerCell: DatePickerCell!
    @IBOutlet weak var specifyCell: UITableViewCell!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
