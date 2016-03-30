//
//  ExtendedForecastTableView.swift
//  JSON Example
//
//  Created by Roland Gill on 3/18/16.
//  Copyright © 2016 Roland Gill. All rights reserved.
//

import UIKit

class ExtendedForecastTableView: UITableViewController {
    
    var extended: FiveDayForecast?
    var ip = IconPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // configure cell
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Interval")
        let cellIndex = indexPath.row
        if let xnd = extended {
            let tempLbls = xnd.allForecasts.map { "\($0.temperature)ºC, \($0.description)" } // label for temperature
            let dateDetls = xnd.listOfDates() // right detail for date

            cell.textLabel?.text = tempLbls[cellIndex]
            cell.detailTextLabel?.text = dateDetls[cellIndex]
        }
        
        if let url = NSURL(string: ip.createIcon(extended?.allForecasts[cellIndex])) {
            if let data = NSData(contentsOfURL: url) {
                cell.imageView?.image = UIImage(data: data)
            }        
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let xtnd = extended {
            return xtnd.allForecasts.count
        } else {
            return 0
        }
    }

    
    func formatHelper(date: NSDate) {
        let dateFrmtr = NSDateFormatter()
        dateFrmtr.dateFormat = "yyyy'-'MM'-'dd"
        //var prettyDate = dateFrmtr.stringFromDate(date)
    }
}
