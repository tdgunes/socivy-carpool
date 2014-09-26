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

class RouteSearchViewController: UITableViewController, MKMapViewDelegate{
    
    
    @IBOutlet weak var mapCell: MapCell?
    @IBOutlet weak var searchCell: UITableViewCell?
    @IBOutlet weak var segmentedControl: SegmentedControlCell?
    @IBOutlet weak var datePicker: DatePickerCell?
    
    var annotation:MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
        
        self.configureMapView()
        self.configureDatePicker()
        self.mapCell?.mapView?.delegate = self
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var optionalPinView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("pinView") as MKPinAnnotationView?
        
        if var pinView = optionalPinView {
            pinView.annotation = annotation
            return pinView
        }
        else {
            var newPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
            
            if annotation is Location{
                newPinView.pinColor = (annotation as Location).color
                newPinView.animatesDrop = false
                newPinView.canShowCallout = true
            }
            else {
                
                
                newPinView.pinColor = MKPinAnnotationColor.Red
                newPinView.animatesDrop = false
                newPinView.canShowCallout = true
                
                //details button
                //            var rightButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
                
                //            newPinView.rightCalloutAccessoryView = rightButton
                
                
            }
            return newPinView
        }
        
        
        
        
    }

    
    func configureMapView(){
        var recognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        recognizer.minimumPressDuration = 1.5
        
        self.mapCell?.mapView?.addGestureRecognizer(recognizer)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:41.030420 , longitude: 29.122009), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        self.mapCell?.mapView?.setRegion(region, animated: true)
        
        self.mapCell?.mapView?.addAnnotations(LocationStorage.sharedInstance.getAll() as [Location])
    }
    
    
    
    func configureDatePicker(){
        self.datePicker?.datePicker?.minimumDate = NSDate()
        var maximumDate = NSDate()
        maximumDate = maximumDate.dateByAddingTimeInterval(60*60*24*1)
        self.datePicker?.datePicker?.maximumDate = maximumDate
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
//        self.mapCell?.mapView?.showAnnotations([annotation!], animated: true)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell = self.tableView.cellForRowAtIndexPath(indexPath)

        if selectedCell == searchCell {
            println("[peek] searchCell touched")
            
            if let annotated = self.annotation {
                println("[peek] latitude: \(annotated.coordinate.latitude)")
                println("[peek] longitude: \(annotated.coordinate.longitude)")
                println("[peek] time&date: \(self.datePicker?.datePicker?.date)")
                
            }
            else {
                println("[peek] showAlertView here")
            }

            
        }
        
        
    }
    
    
}