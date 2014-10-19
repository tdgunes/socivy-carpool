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
    @IBOutlet weak var specifyCell: UITableViewCell!
    @IBOutlet weak var additionalCell: TextFieldCell!
    @IBOutlet weak var socivyDatePicker: SocivyDatePicker!
    @IBOutlet weak var seatPicker: PickerCell!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue: \(segue.identifier)")

        let identifier = segue.identifier
        
        if identifier == "specifyMyStops" {
            var routeSecondController = segue.destinationViewController as AddRouteSecondViewController
            

            let hour_index = self.socivyDatePicker.picker.selectedRowInComponent(0)
            let minute_index = self.socivyDatePicker.picker.selectedRowInComponent(1)
            let action_day  = self.socivyDatePicker.picker.selectedRowInComponent(2)
            
            let action_hour = (self.socivyDatePicker.pickerView(self.socivyDatePicker.picker , titleForRow: hour_index, forComponent: 0) as NSString)
            let action_minute = (self.socivyDatePicker.pickerView(self.socivyDatePicker.picker , titleForRow: minute_index, forComponent: 1) as NSString)

            
            let index = self.seatPicker.picker.selectedRowInComponent(0)
            var available_seat = (self.seatPicker.pickerView(self.seatPicker.picker , titleForRow: index, forComponent: 0) as NSString).integerValue
            
            
            var plan = ""
            if segmentedCell.segmentedControl?.selectedSegmentIndex == 1 {
                plan = "toSchool"
            }
            else if segmentedCell.segmentedControl?.selectedSegmentIndex == 0 {
                plan = "fromSchool"
            }
            
            
            
            println("action_day: \(action_day)")
            println("action_hour: \(action_hour)")
            println("action_minute: \(action_minute)")
            println("available_seat: \(available_seat)")
            println("plan: \(plan)")
            
            var info = self.additionalCell.textField!.text
            if info == nil {
                info = ""
            }
            
            println("description: \(info)")
            
            var payload:Dictionary<String,AnyObject> = ["action_day":action_day, "action_hour":action_hour, "action_minute":action_minute,
                           "available_seat":available_seat, "plan":plan, "description":info, "points":[]]

            routeSecondController.payload = payload
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var currentComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: NSDate.date())
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
