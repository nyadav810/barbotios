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
    
    // UI appearance properties
    let montserratFont: UIFont! = UIFont(name: "Montserrat-Regular", size: 16)
    let barbotBlue: UIColor! = UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    var recipe: Recipe!
    var ingredientList: IngredientList!
    
    // UI elements
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var shotSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderButton: UIButton!
    
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
        let attributes = [NSForegroundColorAttributeName: barbotBlue, NSFontAttributeName: self.montserratFont]
        
        // set title label
        self.titleLabel.title = self.recipe.name
        
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
                print("8oz")
                break;
            case 1:
                // 16oz, update Recipe
                print("16oz")
                break;
            default:
                break;
        }
    }
    
    @IBAction func shotSegmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Single, update Recipe
            print("Single")
            break;
        case 1:
            // Double, update Recipe
            print("Double")
            break;
        default:
            break;
        }
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
        cell.textLabel!.text = "\(object.step_number). \(object.type)"
        
        // add ingredient name
        if object.type == "Add" {
            for ingredient: Ingredient in self.ingredientList.ingredientList! {
                if object.ingredient_id == ingredient.ingredient_id {
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