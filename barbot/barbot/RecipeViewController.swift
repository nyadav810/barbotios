//
//  RecipeViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 3/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI appearance properties
    let montserratFont: UIFont! = UIFont(name: "Montserrat-Regular", size: 16)
    let barbotBlue: UIColor! = UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    var recipeSet: RecipeSet!
    var recipe: Recipe!
    var ingredientList: IngredientList!
    var dataManager: DataManager!
    
    // UI elements
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var shotSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipe = self.recipeSet.recipes![0]
        
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
        let attributes = [NSForegroundColorAttributeName: barbotBlue, NSFontAttributeName: self.montserratFont]
        
        // set title label
        self.titleLabel.title = self.recipeSet.name
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // configure table label 'Recipe'
        self.tableLabel.font = self.montserratFont
        self.tableLabel.textColor = self.barbotBlue
        
        // configure table view
        self.automaticallyAdjustsScrollViewInsets = false
        
        // configure segmented controls
        self.shotSegmentedControl.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.sizeSegmentedControl.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        
        // configure order button
        self.orderButton.titleLabel!.font = self.montserratFont
        self.orderButton.titleLabel?.textColor = self.barbotBlue
    }
    
    @IBAction func orderDrink(sender: AnyObject) {
        // Send order to barbot web server
    }
    
    @IBAction func sizeSegmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                // 8oz, update Recipe
                if self.shotSegmentedControl.selectedSegmentIndex == 0 {
                    self.recipe = self.recipeSet.recipes![0]
                } else {
                    self.recipe = self.recipeSet.recipes![1]
                }
                break;
            case 1:
                // 16oz, update Recipe
                if self.shotSegmentedControl.selectedSegmentIndex == 0 {
                    self.recipe = self.recipeSet.recipes![2]
                } else {
                    self.recipe = self.recipeSet.recipes![3]
                }
                break;
            default:
                break;
        }
        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Fade)
    }
    
    @IBAction func shotSegmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                // single, update Recipe
                if self.sizeSegmentedControl.selectedSegmentIndex == 0 {
                    // short
                    self.recipe = self.recipeSet.recipes![0]
                } else {
                    // tall
                    self.recipe = self.recipeSet.recipes![2]
                }
                break;
            case 1:
                // double, update Recipe
                if self.sizeSegmentedControl.selectedSegmentIndex == 0 {
                    // short
                    self.recipe = self.recipeSet.recipes![1]
                } else {
                    // tall
                    self.recipe = self.recipeSet.recipes![3]
                }
                break;
            default:
                break;
            }
        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Fade)
    }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.recipe.steps?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        } else if editingStyle == .Insert {
            
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        //self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .None)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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
        
        cell.textLabel!.font = self.montserratFont
        cell.textLabel!.text = "\(indexPath.row + 1). \(object.type)"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // add ingredient name
        if object.type == "Add" {
            for ingredient: Ingredient in self.ingredientList.ingredientList! {
                if object.ingredientId == ingredient.ingredientId {
                    var stepString: String = ""
                    if ingredient.type == "alcohol" {
                        stepString = " \(object.quantity!) \(object.measurement!) \(ingredient.brand) \(ingredient.name)"
                    } else if ingredient.type == "mixer" {
                        stepString = " \(object.quantity!) \(object.measurement!) \(ingredient.name)"
                    } else {
                        stepString = " \(ingredient.name)"
                    }
                    
                    cell.textLabel!.text?.appendContentsOf(stepString)
                }
            }
        }
    }
}