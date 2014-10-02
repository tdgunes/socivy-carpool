//
//  RouteCell.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 02/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import Foundation
import UIKit

class RouteCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView:UITableView?
    
    var route:Route?
    
    @IBOutlet weak var directionLabel: UILabel?
    @IBOutlet weak var timeLeftLabel: UILabel?
    @IBOutlet weak var driverLabel: UILabel?
    @IBOutlet weak var explicitTimeLabel: UILabel?
    @IBOutlet weak var seatLeftLabel: UILabel?
    
    let fromStopToOzuSymbol = "  "
    let fromOzuToStopSymbol = "  "
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.tableView?.dataSource = self 
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StopCell", forIndexPath:indexPath) as UITableViewCell

        var stop = route!.stops[indexPath.row]
        cell.textLabel?.text = " "+stop.name!
        
        return cell
    }
    
    func configureCell() {
        if route?.toOzu == true {
            self.directionLabel?.text = fromStopToOzuSymbol
        }
        else {
            self.directionLabel?.text = fromOzuToStopSymbol
        }
        
        self.driverLabel?.text = " \(self.route!.driver.name)"
        self.seatLeftLabel?.text = "\(self.route!.seatLeft) "
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let correctStops = route?.stops {
                return correctStops.count
        }
        return 0
    }
    
}