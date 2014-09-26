//
//  SearchResultViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 26/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class SearchResultViewController:UITableViewController, MKMapViewDelegate {
    

    @IBOutlet weak var timeDateCell:UITableViewCell?
    @IBOutlet weak var driverCell:UITableViewCell?
    @IBOutlet weak var descriptionCell:UITableViewCell?
    @IBOutlet weak var mapCell: MapCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.mapCell?.mapView?.delegate = self
        
        self.mapCell?.mapView?.addAnnotations(LocationStorage.sharedInstance.getAll())
        
        let region = MKCoordinateRegion(center: LocationStorage.sharedInstance.getAtasehir().coordinate, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        
        self.mapCell?.mapView?.setRegion(region, animated: true)

        self.navigationItem.title = "Rota"
        
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
                
                
                newPinView.pinColor = MKPinAnnotationColor.Green
                newPinView.animatesDrop = false
                newPinView.canShowCallout = true
                
                
            }
            return newPinView
        }
        
        
        
        
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
    }
    
    
    
}