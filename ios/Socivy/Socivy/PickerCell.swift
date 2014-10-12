//
//  PickerCell.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 11/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class PickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var picker: UIPickerView!{
        didSet {
            self.picker.dataSource = self
            self.picker.delegate = self
            self.picker.reloadAllComponents()
            self.picker.selectRow(3, inComponent: 0, animated: true)
        }
    }
    
    var pickerData = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"],["Seat(s)"]]

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.picker.dataSource = self
        self.picker.delegate = self
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1 {
            return 100
        }
        return 40
    }
    

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[component][row]
    }
}
