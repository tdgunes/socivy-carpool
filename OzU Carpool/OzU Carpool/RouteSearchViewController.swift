//
//  RouteSearchViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

//
//  RouteCategoryViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 24/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RouteSearchViewController: UITableViewController{
    
    
    @IBOutlet weak var mapCell: MapCell?
    @IBOutlet weak var searchCell: UITableViewCell?
    @IBOutlet weak var segmentedControl: SegmentedControlCell?
    @IBOutlet weak var datePicker: DatePickerCell?
    
    var annotation:MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
        
        var recognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        recognizer.minimumPressDuration = 1.5
        self.mapCell?.mapView?.addGestureRecognizer(recognizer)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:41.030420 , longitude: 29.122009), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
            
        self.mapCell?.mapView?.setRegion(region, animated: true)

        
    
    }
    
    func handleLongPress(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizerState.Began{
            return
        }
        let touchPoint:CGPoint = gestureRecognizer.locationInView(self.mapCell?.mapView)
        let touchMapCoordinate:CLLocationCoordinate2D? = self.mapCell?.mapView?.convertPoint(touchPoint, toCoordinateFromView: self.mapCell?.mapView)
        
        if self.annotation == nil{
            
        }
        else {
            self.mapCell?.mapView?.removeAnnotation(annotation)
            
        }
        
        self.annotation = MKPointAnnotation()
        annotation!.title = "Buraya Yakın Durak"
        annotation!.setCoordinate(touchMapCoordinate!)
        
        self.mapCell?.mapView?.addAnnotation(annotation)
        self.mapCell?.mapView?.showAnnotations([annotation!], animated: true)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)
        
        let main = self.storyboard?.instantiateViewControllerWithIdentifier("CategoryDetail") as UIViewController
        

        if main == searchCell {
            println("[peek] searchCell touched")
        }
        
        
    }
    
    
}