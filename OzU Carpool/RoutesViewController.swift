//
//  RoutesViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class RoutesViewController: UITableViewController {
    
    var routes:[Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        let umraniye = CLLocation(latitude:41.030420 , longitude: 29.122009)
        var stop = Stop(name:"Ümraniye", location:umraniye)
        
        var route = Route(stop: stop, timestamp: 12123123123, description: "GO go go", toOzu:true)

        routes.append(route)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "RouteDetail"{
//            let vc = segue.destinationViewController as

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Route", forIndexPath:indexPath) as UITableViewCell
        var route = routes[indexPath.row]
        if route.toOzu == true{
            cell.textLabel?.text = "\(route.timestamp!) - \(route.stop!.name!) -> ÖzÜ "
        }
        else if route.toOzu == false {
            cell.textLabel?.text = "\(route.timestamp!) - ÖzÜ -> \(route.stop!.name!)  "
        }

        
        return cell
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    
}