//
//  RouteCategoryViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class RouteCategoryViewController: UITableViewController{
    
    @IBOutlet weak var fromOzuToStop: UITableViewCell?
    @IBOutlet weak var fromStopToOzu: UITableViewCell?
    
    
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
        
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryDetail") as UIViewController
        
        if selectedCell == fromStopToOzu {
            main.navigationItem.title = "Duraktan ÖzÜ'ye"
            self.navigationController?.pushViewController(main, animated: true)
        }
        else if selectedCell == fromOzuToStop {
            main.navigationItem.title = "ÖzÜ'den Durağa"
            self.navigationController?.pushViewController(main, animated: true)
        }
        
        
        
    }
    
    
}