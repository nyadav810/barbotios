//
//  MenuTableViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 2/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewController: UITableViewController, UISearchControllerDelegate {
    
    var dataManager: DataManager!
    var recipeList: [Recipe]!
    var ingredientList: IngredientList!
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRecipes = [Recipe]()
    
    let montserratFont: UIFont! = UIFont(name: "Montserrat-Regular", size: 16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Barbot"
        let attributes = [NSForegroundColorAttributeName : UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0), NSFontAttributeName: self.montserratFont]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.reloadInputViews()
        
        // Call DataManager to retrieve drinks
        self.dataManager = DataManager.init()
        self.recipeList = dataManager.getMenuDataFromFile("menu")
        self.ingredientList = dataManager.getIngredientDataFromFile("ingredients")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Set up searchController
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.delegate = self
        
        // reload table data
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    // MARK: - UITableViewController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredRecipes.count
        }
        return self.recipeList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let recipe : Recipe
        
        if searchController.active && searchController.searchBar.text != "" {
            recipe = self.filteredRecipes[indexPath.row]
        } else {
            recipe = self.recipeList[indexPath.row]
        }
        
        cell.textLabel!.text = recipe.name
        cell.textLabel!.font = self.montserratFont
    }
    
    // MARK: - UISearchControllerDelegate
    func willPresentSearchController(searchController: UISearchController) {
        // do something before the search controller is presented
        self.navigationController!.navigationBar.translucent = true;
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationController!.navigationBar.translucent = false;
    }
    
    // MARK: - UISearchResultsUpdating
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredRecipes = recipeList.filter { recipe in
            return recipe.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                // send 'request recipe for recipe_id' message through socket to Server
//                let recipe: Recipe = self.recipeList[indexPath.row]
//                viewController.recipe = self.dataManager.getRecipeDataFromServer(recipe.recipe_id)
        
        if segue.identifier == "showDrinkScreen" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let recipe: Recipe
                if searchController.active && searchController.searchBar.text != "" {
                    recipe = filteredRecipes[indexPath.row]
                } else {
                    recipe = recipeList[indexPath.row]
                }
                let controller = segue.destinationViewController as! RecipeViewController
                controller.recipe = recipe
                controller.dataManager = self.dataManager
                controller.ingredientList = self.ingredientList
            }
        }
    }
}

extension MenuTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}