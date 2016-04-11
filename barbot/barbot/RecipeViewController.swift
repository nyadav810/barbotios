//
//  RecipeViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 3/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureView()
        self.reloadInputViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    func configureView() {
        self.titleLabel.title = self.recipe.name
    }
    
    @IBAction func orderDrink(sender: AnyObject) {
        // Send order to barbot web server
    }
    
    // MARK: UITableDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipe.steps!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let object : Step = self.recipe.steps![indexPath.row]
        cell.textLabel!.text = "\(object.step_number). \(object.type)"
        cell.textLabel!.font = UIFont(name: "Montserrat-Regular", size: 16)
    }
}