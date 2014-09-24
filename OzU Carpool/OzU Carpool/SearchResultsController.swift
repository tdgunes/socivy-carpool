//
//  SearchResultsController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 25/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchResultsController: UITableViewController{
    
    var routes:[Route] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let umraniye = CLLocationCoordinate2D(latitude:41.030420 , longitude: 29.122009)
        var stop = Stop(name:"Ümraniye", location:umraniye)
        var driver = User(name: "Taha Doğan Güneş", cellphone: "05378764948")
        
        
        var example1: Route = Route(stops: [stop], timestamp: 1322486053, description: "Arabamiz tupludur, sigara icmeyin!", toOzu: true, driver: driver)
        example1.selectedStop = stop
        
        routes.append(example1)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var route = routes[indexPath.row]
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("RouteDetail") as RouteDetailViewController
        main.route = route
        self.navigationController?.pushViewController(main, animated: true)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Route", forIndexPath:indexPath) as UITableViewCell
        var route = routes[indexPath.row]
        if route.toOzu == true{
            cell.detailTextLabel?.text = "\(route.selectedStop!.name!) -> ÖzÜ, \(route.driver!.name)"
        }
        else if route.toOzu == false {
            cell.detailTextLabel?.text = "ÖzÜ -> \(route.selectedStop!.name!) \(route.driver!.name)"
            
        }
        cell.textLabel?.text = "\(route.getTime()!)"
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    

    
}