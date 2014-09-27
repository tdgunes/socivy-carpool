//
//  AddRouteSecondViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 27/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class AddRouteSecondViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView:MKMapView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureMapView()
        self.mapView?.delegate = self
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
                newPinView.image = UIImage(named: "16-car")
                newPinView.animatesDrop = false
                newPinView.canShowCallout = true
                var rightButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
                
                newPinView.rightCalloutAccessoryView = rightButton
                
                
            }
            else {
                
                
                newPinView.pinColor = MKPinAnnotationColor.Red
                newPinView.animatesDrop = false
                newPinView.canShowCallout = true
                
//                details button
                            var rightButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
                
                            newPinView.rightCalloutAccessoryView = rightButton
                
                
            }
            return newPinView
        }
        
        
        
        
    }
    
    
    func configureMapView(){
        var recognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        recognizer.minimumPressDuration = 1.5
        
        self.mapView?.addGestureRecognizer(recognizer)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:41.030420 , longitude: 29.122009), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        self.mapView?.setRegion(region, animated: true)
        
        self.mapView?.addAnnotations(LocationStorage.sharedInstance.getAll() as [Location])
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}