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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.tableView?.dataSource = self 
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StopCell", forIndexPath:indexPath) as UITableViewCell

        
        cell.textLabel?.text = " Ataşehir Migros"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    
}