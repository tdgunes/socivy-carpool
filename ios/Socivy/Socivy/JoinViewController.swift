//
//  JoinViewController.swift
//  Socivy
//
//  Created by Taha Doğan Güneş on 12/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class JoinViewController: UITableViewController, UIActionSheetDelegate {
    

    @IBOutlet weak var driverCell: UITableViewCell!
    @IBOutlet weak var timeCell: UITableViewCell!
    @IBOutlet weak var seatLeftCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var joinCell: UITableViewCell!
    @IBOutlet weak var contactCell: UITableViewCell!
    @IBOutlet weak var mapCell: MapCell!
    
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var alert = UIAlertView()
    
    var route: Route? {
        didSet {
            self.configureTableView()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        

        self.activityIndicator.center = self.navigationController!.view.center
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.navigationController?.view.addSubview(self.activityIndicator)
    }
    
    func configureTableView() {
        
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
        
        if selectedCell == contactCell {
            var actionSheet = UIActionSheet(title: "Contact the Driver", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Send Message","Send Mail","Call", "SMS" )
            
            actionSheet.showInView(self.view)
        
        }
        else if selectedCell == joinCell {

            println("Join touched")
        }

        
        
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("Done");
            break;
        case 1:
            NSLog("Cancel");
            break;
        case 2:
            NSLog("Yes");
            break;
        case 3:
            NSLog("No");
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
 

}