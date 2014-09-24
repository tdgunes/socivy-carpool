//
//  RouteDetailViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class RouteDetailViewController: UITableViewController {
    
    @IBOutlet weak var nameCell:UITableViewCell?
    @IBOutlet weak var timeDateCell:UITableViewCell?
    @IBOutlet weak var driverCell:UITableViewCell?
    @IBOutlet weak var descriptionCell:UITableViewCell?
    @IBOutlet weak var searchDriverCell:UITableViewCell?
    @IBOutlet weak var callDriverCell:UITableViewCell?
    @IBOutlet weak var mapCell: MapCell?
    
    var route: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = route?.selectedStop!.name!
        self.nameCell?.detailTextLabel?.text = route?.selectedStop!.name!
        self.timeDateCell?.detailTextLabel?.text = route!.getTime()
        self.driverCell?.detailTextLabel?.text = route?.driver?.name
        self.descriptionCell?.detailTextLabel?.text = route?.description!

        self.handleMapView()
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell == callDriverCell {
            self.callDriver()
        }
    }
    
    func handleMapView() {
        
        let loc = route?.selectedStop?.location!
        let region = MKCoordinateRegion(center: loc!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapCell?.mapView?.setRegion(region, animated: true)
    
        // point annotation
        var annotation = MKPointAnnotation()
        annotation.setCoordinate(loc!)
        annotation.title = self.route?.selectedStop?.name
        self.mapCell?.mapView?.addAnnotation(annotation)
    }
    
    func callDriver() {
        println("[peek] callDriver() ")
        UIApplication.sharedApplication().openURL(NSURL(string: "tel:\(self.route?.driver?.cellphone)"))
    }
    
    @IBAction func cancelRoute(){
        println("[peek] cancelRoute")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}