//
//  RouteCategoryDetailViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class RouteCategoryDetailViewController: UITableViewController {
    
    var routes:[String:[Route?]] = [:]
    var days:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        routes["Pazartesi"] = nil
        routes["Salı"] = nil
        routes["Çarşamba"] = nil
        routes["Perşembe"] = nil
        routes["Cuma"] = nil
        
        days = Array(routes.keys)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let day = self.days[indexPath.section]
        
        var r = self.routes[day]
        var route = r![indexPath.row]
        
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("RouteDetail") as RouteDetailViewController
        main.route = route
        self.navigationController?.pushViewController(main, animated: true)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Route", forIndexPath:indexPath) as UITableViewCell
        
        let day = self.days[indexPath.section]
        
        var r = self.routes[day]
        var route = r![indexPath.row]!

        
        return cell
        
    }
    
    
}