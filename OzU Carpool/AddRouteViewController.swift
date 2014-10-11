//
//  AddRouteViewController.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 27/09/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddRouteViewController: UITableViewController {
    
    @IBOutlet weak var segmentedCell: SegmentedControlCell!
    @IBOutlet weak var datePickerCell: DatePickerCell!
    @IBOutlet weak var specifyCell: UITableViewCell!

    @IBOutlet weak var notesCell: UITextField!
    @IBOutlet weak var seatCell: TextFieldCell!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "specifyMyStops" {
//            var routeSecondController = segue.destinationViewController as AddRouteSecondViewController
//            var selectedComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: self.datePickerCell.datePicker!.date)
//            var currentComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit, fromDate: NSDate.date())
//
//            var action_day = selectedComponents.day - currentComponents.day
//            var action_hour = selectedComponents.hour
//            var action_minute = selectedComponents.minute
//            
//            println("action_day: \(action_day)")
//            println("action_hour: \(action_hour)")
//            println("action_minute: \(action_minute)")
//            
//        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var currentComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: NSDate.date())
        

//        
//        self.configureDatePicker(currentComponents)
    }
    
    
//    func configureDatePicker(currentComponents:NSDateComponents){
//        var calendar = NSCalendar(identifier:NSGregorianCalendar)
//        var components = NSDateComponents()
//        components.year = currentComponents.year
//        components.month = currentComponents.month
//        components.day = currentComponents.day + 1
//        components.hour = 23
//        components.minute = 59
//    
//        self.datePickerCell?.datePicker?.minimumDate = NSDate.date()
//        self.datePickerCell?.datePicker?.maximumDate = calendar.dateFromComponents(components)
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
