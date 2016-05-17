//
//  MenuTableViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 2/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import UIKit

@objc
protocol MenuTableViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class MenuTableViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    // UI appearance properties
    let montserratFont: UIFont! = UIFont(name: "Montserrat-Regular", size: 16)
    let barbotBlue: UIColor! = UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    var delegate: MenuTableViewControllerDelegate?
    
    var dataManager: DataManager!
    var drinkList: [Drink]!
    var searchController: UISearchController!
    var filteredDrinks = [Drink]()
    weak var actionToEnable: UIAlertAction!
    
    @IBOutlet weak var slideOutBarButtomItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        // Call DataManager to retrieve recipes and ingredients
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.dataManager = appDelegate.dataManager
        
        self.drinkList = []
        
        // Initialize searchController
        self.searchController = UISearchController(searchResultsController: nil)
        
        self.searchController.searchResultsUpdater = self       // UISearchResultsUpdating
        self.searchController.delegate = self                   // UISearchControllerDelegate
        self.searchController.searchBar.delegate = self         // UISearchBarDelegate
        
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        // TODO: Finish slide out navigation
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
    }
    
    override func viewWillAppear(animated: Bool) {
        // Set UI elements
        self.title = "Barbot"
        let attributes = [NSForegroundColorAttributeName : self.barbotBlue, NSFontAttributeName: self.montserratFont]
        self.navigationController?.navigationBar.titleTextAttributes = attributes

        self.hideSearchBar(CGPointMake(0, self.searchController.searchBar.frame.size.height), animated: false)
        
        self.dataManager.requestDataFromServer("get_recipes_for_barbot", args: ["barbot_id": self.dataManager.barbotId])
        
        self.dataManager.socket.onText = { (text: String) in
            self.dataManager.parseResponseDataFromServer(text)
            self.drinkList = self.dataManager.drinkList
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    @IBAction func slideOutTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func addCustomDrink(sender: AnyObject) {
        self.showAlertController()
    }
    
    func hideSearchBar(contentOffset: CGPoint, animated: Bool) {
        self.tableView.setContentOffset(contentOffset, animated: animated)
    }
    
    // TODO: Add text field validation, max field length
    
    // Display alert popup when adding a new (custom) drink.
    // Prompts user to enter a name, and adds it to the menu.
    func showAlertController() {
        let alert: UIAlertController = UIAlertController.init(title: "Name Your Drink", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Configure text view
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            textField.addTarget(self, action: #selector(MenuTableViewController.textChanged(_:)), forControlEvents: .EditingChanged)
        }

        // OK button
        let ok: UIAlertAction = UIAlertAction.init(title: "OK", style: .Default, handler: { (action: UIAlertAction) in
            let field = alert.textFields!.first!
            let customDrink: Drink = Drink.init(name: field.text!)
            self.drinkList.append(customDrink)
            let newIndexPath: NSIndexPath = NSIndexPath(forRow:self.drinkList.count-1, inSection:0)
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
        })
        
        // Cancel button
        let cancel: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .Cancel, handler:{
            (action: UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // OK should be disable to begin
        self.actionToEnable = ok
        ok.enabled = false
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textChanged(sender:UITextField) {
        self.actionToEnable?.enabled = (sender.text! != "")
    }
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredDrinks.count
        }
        return self.drinkList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Set data and styles for tableView cells
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let drink : Drink
        
        if searchController.active && searchController.searchBar.text != "" {
            drink = self.filteredDrinks[indexPath.row]
        } else {
            drink = self.drinkList[indexPath.row]
        }
        
        cell.textLabel!.text = drink.name
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
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.tableView.setContentOffset(CGPointMake(0, self.searchController.searchBar.frame.size.height), animated: true)
        searchBar.endEditing(true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredDrinks = drinkList.filter { drink in
            return drink.name!.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDrinkScreen" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let drink: Drink
                if searchController.active && searchController.searchBar.text != "" {
                    drink = filteredDrinks[indexPath.row]
                } else {
                    drink = drinkList[indexPath.row]
                }
                
                let controller = segue.destinationViewController as! RecipeViewController
                
                if drink.recipeId == "custom_recipe" {
                    controller.recipe = Recipe.init(name: drink.name!, custom: true)
                } else {
                    self.dataManager.requestDataFromServer("get_recipe_details", args: ["recipe_id": drink.recipeId!])
                    controller.recipe = Recipe.init(name: drink.name!, custom: false)
                }
                controller.titleLabel.title = controller.recipe.name
                controller.dataManager = self.dataManager
                controller.ingredientList = self.dataManager.ingredientList
            }
        }
    }
}

extension MenuTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}