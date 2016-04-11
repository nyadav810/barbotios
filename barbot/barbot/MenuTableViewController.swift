//
//  MenuTableViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 2/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewController: UITableViewController {
    
    var recipeList: [Recipe]!
    var dataManager: DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Barbot"
        let attributes = [NSForegroundColorAttributeName : UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.reloadInputViews()
        
        // Call DataManager to retrieve drinks
        self.dataManager = DataManager.init()
        self.recipeList = dataManager.getMenuDataFromFile("menu")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    // MARK: UITableViewController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let object : Recipe = self.recipeList[indexPath.row]
        cell.textLabel!.text = object.name
        cell.textLabel!.font = UIFont(name: "Montserrat-Regular", size: 16)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        if segue.identifier == "showDrinkScreen" {
            if let viewController = segue.destinationViewController as? RecipeViewController {
                // send 'request recipe for recipe_id' message through socket to Server
//                let recipe: Recipe = self.recipeList[indexPath.row]
//                viewController.recipe = self.dataManager.getRecipeDataFromServer(recipe.recipe_id)
                
                // get response, parse using DataManager, send to DrinkViewController
                viewController.recipe = self.dataManager.getRecipeDataFromFile("recipe")
            }
        }
    }
}