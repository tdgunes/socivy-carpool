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
    

    var route:Route?{
        didSet {
            if DEBUG {
                println("[routecell] route set")
            }
            self.tableView?.reloadData()
        }
    }

    
    @IBOutlet weak var directionLabel: UILabel?
    @IBOutlet weak var timeLeftLabel: UILabel?
    @IBOutlet weak var driverLabel: UILabel?
    @IBOutlet weak var explicitTimeLabel: UILabel?
    @IBOutlet weak var seatLeftLabel: UILabel?
    
    let fromStopToOzuSymbol = "  "
    let fromOzuToStopSymbol = "  "
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StopCell", forIndexPath:indexPath) as UITableViewCell

        if let stop = route?.stops[indexPath.row]{
            cell.textLabel.text = " "+stop.name
        }
        var stop = route?.stops[indexPath.row]

        
        return cell
    }
    
    func configureCell() {
        
        self.explicitTimeLabel?.text = self.route?.getRight()
        self.timeLeftLabel?.text = self.route?.getLeft()
        
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
        if route == nil {
            return 0
        }
        var count = route?.stops.count
        return count!
    }
    
}