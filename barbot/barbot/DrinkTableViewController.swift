//
//  DrinkTableViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 2/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class DrinkTableViewController : UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var drinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drinks"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return drinks.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = drinks[indexPath.row]
            
            return cell!
    }
}