//
//  RecipeViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 3/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import UIKit

var kAddIngredientPickerTag = 1

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Custom UITableViewCell Identifiers
    let stepCell: String = "StepCell"
    let addIngredientCell: String = "AddIngredientCell"
    
    // UI appearance properties
    let montserratFont: UIFont! = UIFont(name: "Montserrat-Regular", size: 16)
    let barbotBlue: UIColor! = UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    var recipeSet: RecipeSet!
    var recipe: Recipe!
    var ingredientList: IngredientList!
    var dataManager: DataManager!
    
    // Add Ingredient Picker
    var addIngredientPickerIndexPath: NSIndexPath?
    var pickerCellRowHeight: CGFloat!
    
    // UI elements
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var shotSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipe = self.recipeSet.recipes![0]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // get Picker View Cell height
        let pickerViewCellToCheck: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(addIngredientCell)!;
        self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
        
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
    
    // Configure UI: set label, color, text attributes, etc
    func configureView() {
        let attributes = [NSForegroundColorAttributeName: barbotBlue, NSFontAttributeName: self.montserratFont]
        
        // set title label
        self.titleLabel.title = self.recipeSet.name
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // configure table label 'Recipe'
        //self.tableLabel.font = self.montserratFont
        //self.tableLabel.textColor = self.barbotBlue
        
        // configure table view
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.allowsSelection = false
        self.tableView.allowsSelectionDuringEditing = true
        
        // configure segmented controls
        self.shotSegmentedControl.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.sizeSegmentedControl.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.shotSegmentedControl.tintColor = self.barbotBlue
        self.sizeSegmentedControl.tintColor = self.barbotBlue
        
        // configure order button
        self.orderButton.titleLabel!.font = self.montserratFont
        self.orderButton.titleLabel?.textColor = self.barbotBlue
        
        self.orderButton.layer.cornerRadius = 5.0
        self.orderButton.layer.borderColor = self.barbotBlue.CGColor
        self.orderButton.layer.borderWidth = 0.9
        self.orderButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)
    }
    
    @IBAction func orderDrink(sender: AnyObject) {
        // Send order to barbot web server
    }
    
    // MARK: - Segmented Controls
    
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
    
    // MARK: - UITableView Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        let stepNumber: Int = self.recipe.steps!.count
        
        if editing {                                    // Start editing, add New Ingredient row
            self.recipe.steps!.append(Step.init(step_number: stepNumber, type: "NewIngredient"))
            self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: stepNumber, inSection:0)], withRowAnimation: .Left)
        } else {                                        // End editing, remove New Ingredient row
            if self.addIngredientPickerIsShown() {
                self.tableView.beginUpdates()
                self.hideExistingPicker()
                self.tableView.endUpdates()
            }
            self.recipe.steps?.removeAtIndex(stepNumber-1)
            tableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: stepNumber-1, inSection:0)], withRowAnimation: .Left)
        }
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
        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .None)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forRow:(self.tableView(tableView, numberOfRowsInSection: 0) - 1), inSection:0);

        
        if indexPath.row == lastIndexPath.row {
            return .Insert;
        } else if self.addIngredientPickerIsShown() && (self.addIngredientPickerIndexPath!.row == indexPath.row || self.addIngredientPickerIndexPath!.row - 1 == indexPath.row) {
            return .None
        } else {
            return .Delete;
        }
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.addIngredientPickerIsShown() && (self.addIngredientPickerIndexPath!.row == indexPath.row || self.addIngredientPickerIndexPath!.row - 1 == indexPath.row) {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // edit ingredient, quantity
        self.tableView.beginUpdates()
        
        if self.addIngredientPickerIsShown() && self.addIngredientPickerIndexPath!.row - 1 == indexPath.row {
            self.hideExistingPicker()
        } else {
            let newPickerIndexPath: NSIndexPath = self.calculateIndexPathForNewPicker(indexPath)
            
            if self.addIngredientPickerIsShown() {
                self.hideExistingPicker()
            }
            
            self.showNewPickerAtIndex(newPickerIndexPath)
            
            self.addIngredientPickerIndexPath = NSIndexPath(forRow: newPickerIndexPath.row + 1, inSection:0)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated:true);
        
        self.tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat = self.tableView.rowHeight
        
        if self.addIngredientPickerIsShown() && self.addIngredientPickerIndexPath!.row == indexPath.row {
            rowHeight = self.pickerCellRowHeight;
        }
        
        return rowHeight
    }
    
    // MARK: UITableDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = self.recipe.steps!.count
        
        if self.addIngredientPickerIsShown() {
            numberOfRows += 1
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if self.addIngredientPickerIsShown() && self.addIngredientPickerIndexPath!.row == indexPath.row {
            cell = tableView.dequeueReusableCellWithIdentifier(addIngredientCell, forIndexPath: indexPath)
            cell = self.configureAddIngredientCell(cell, indexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(stepCell, forIndexPath: indexPath)
            cell = self.configureStepCell(cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UIPickerViewDataSource
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.ingredientList.ingredientList!.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.ingredientList.ingredientList![row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var parentCellIndexPath: NSIndexPath!
        
        if self.addIngredientPickerIsShown() {
            parentCellIndexPath = NSIndexPath(forRow:self.addIngredientPickerIndexPath!.row - 1, inSection:0)
        } else {
            return
        }
        
        let cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(parentCellIndexPath)!
        self.recipe.steps![parentCellIndexPath!.row].ingredientId = self.ingredientList.ingredientList![row].ingredientId;
        
        self.configureStepCell(cell, indexPath: parentCellIndexPath)
    }
    
    // MARK: - Inline UIPickerView methods
    
    // Add Ingredient Picker
    func addIngredientPickerIsShown() -> Bool {
        return self.addIngredientPickerIndexPath != nil
    }
    
    func hideExistingPicker() {
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:self.addIngredientPickerIndexPath!.row, inSection: 0)], withRowAnimation: .Fade)
        self.addIngredientPickerIndexPath = nil
    }
    
    func calculateIndexPathForNewPicker(indexPath: NSIndexPath) -> NSIndexPath {
        var newIndexPath: NSIndexPath
        if self.addIngredientPickerIsShown() && self.addIngredientPickerIndexPath!.row < indexPath.row {
            newIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection:0);
        } else {
            newIndexPath = NSIndexPath(forRow:indexPath.row, inSection:0);
        }
        
        return newIndexPath
    }
    
    func showNewPickerAtIndex(indexPath: NSIndexPath) {
        let indexPaths: [NSIndexPath] = [NSIndexPath(forRow:indexPath.row + 1, inSection:0)];
        
        self.tableView.insertRowsAtIndexPaths(indexPaths,
                                              withRowAnimation: .Fade);
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
    }
    
    // Add Ingredient Picker View Cell
    func configureAddIngredientCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let object: Step = self.recipe.steps![indexPath.row - 1]
        let ingredient: Ingredient = self.ingredientList.getIngredientForIngredientId(object.ingredientId!)!
        
        let indexOfIngredient = self.ingredientList.indexOf(ingredient)
        let pickerView: UIPickerView = cell.viewWithTag(kAddIngredientPickerTag) as! UIPickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(indexOfIngredient, inComponent: 0, animated: true)
        return cell
    }
    
    // Add Step Cell
    func configureStepCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        var object: Step
        if self.addIngredientPickerIsShown() && indexPath.row > self.addIngredientPickerIndexPath!.row {
            object = self.recipe.steps![indexPath.row-1]
            cell.textLabel!.text = "\(indexPath.row). \(object.type)"
        } else {
            object = self.recipe.steps![indexPath.row]
            cell.textLabel!.text = "\(indexPath.row + 1). \(object.type)"
        }
        
        
        cell.textLabel!.font = self.montserratFont
        
        // add ingredient name
        if object.type == "Add" {
            
            let ingredient: Ingredient = self.ingredientList.getIngredientForIngredientId(object.ingredientId!)!
            var stepString: String = ""
            if ingredient.type == "alcohol" {
                stepString = " \(object.quantity!) \(object.measurement!) \(ingredient.brand) \(ingredient.name)"
            } else if ingredient.type == "mixer" {
                stepString = " \(object.quantity!) \(object.measurement!) \(ingredient.name)"
            } else {
                stepString = " \(ingredient.name)"
            }
            
            cell.textLabel!.text?.appendContentsOf(stepString)
        } else if object.type == "NewIngredient" {
            cell.textLabel!.text = "Add Ingredient"
        } else {
            cell.textLabel!.text = "\(indexPath.row + 1). \(object.type)"
        }
        
        return cell
    }
}