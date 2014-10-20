//
//  SocivyDatePickerCell.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 11/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class SocivyDatePicker: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            self.picker.dataSource = self
            self.picker.delegate = self
            

            self.makePickerDataForToday()
            self.picker.reloadAllComponents()
            
        }
    }
    
    var pickerData = [["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","0"],
                      ["00","05","10","15","20","25","30","35","40","45","50","55",],
        ["Today","Tomorrow"]]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
    }
    
    func makePickerDataForTomorrow(){
        var index: Int
        var hours:[String] = []
        var minutes:[String] = []
        for index = 0; index < 24; ++index {
            var string:NSString = "\(index)"
            if string.length == 1 {
                string = "0\(string)"
            }
            hours.append(string)
        }
        for index = 0; index < 60; index = index + 5{
            var string:NSString = "\(index)"
            if string.length == 1 {
                string = "0\(string)"
            }
            minutes.append(string)
        }
        
        self.pickerData = [hours, minutes, ["Today","Tomorrow"]]

    }
    
    func makePickerDataForToday() {
        var currentComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: NSDate.date())
        
        var index: Int
        var hours:[String] = []
        var minutes:[String] = []

        var start_minute:Int = (currentComponents.minute - currentComponents.minute % 5)+5
        var start_hour:Int = currentComponents.hour

        if start_minute == 60 {
            start_minute = 0
            start_hour = start_hour + 1
        }
        
        for index = start_minute; index < 60; index = index + 5{
            var string:NSString = "\(index)"
            if string.length == 1 {
                string = "0\(string)"
            }
            minutes.append(string)
        }
        
        
        for index = start_hour; index < 24; ++index {
            var string:NSString = "\(index)"
            if string.length == 1 {
                string = "0\(string)"
            }
            hours.append(string)
        }
        
        self.pickerData = [hours, minutes, ["Today","Tomorrow"]]
    }
    
    
    func makePickerDataForLaterToday() {
        var currentComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: NSDate.date())
        
        var index: Int
        var hours:[String] = []
        var minutes:[String] = []
        
        var start_minute:Int = (currentComponents.minute - currentComponents.minute % 5)+5
        var start_hour:Int = currentComponents.hour
        
        if start_minute == 60 {
            start_minute = 0
            start_hour = start_hour + 1
        }
        
        for index = 0; index < 60; index = index + 5{
            var string:NSString = "\(index)"
            if string.length == 1 {
                string = "0\(string)"
            }
            minutes.append(string)
        }
        
        
        for index = start_hour; index < 24; ++index {
            var string:NSString = "\(index)"
            if string.length == 1 {
                string = "0\(string)"
            }
            hours.append(string)
        }
        
        self.pickerData = [hours, minutes, ["Today","Tomorrow"]]
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 2 {
            return 200
        }
        return 40
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 2 && row == 1 {
            self.makePickerDataForTomorrow()
        }
        else if  component == 2 && row == 0 {
            self.makePickerDataForToday()
        }
        
        
        if self.pickerView(self.picker , titleForRow: self.picker.selectedRowInComponent(2), forComponent: 2) == "Today"{
            if component == 0 && row > 0 {
                self.makePickerDataForLaterToday()
            }
            else if component == 0 && row == 0{
                self.makePickerDataForToday()
            }
        }
        
        
        self.picker.reloadAllComponents()
    }

}