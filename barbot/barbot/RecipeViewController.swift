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
    let addIngredientPickerCell: String = "AddIngredientPickerCell"
    
    // UI appearance properties
    let montserratFont: UIFont! = UIFont(name: "Montserrat-Regular", size: 16)
    let barbotBlue: UIColor! = UIColor.init(red: 3.0/255.0, green: 101.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    var recipe: Recipe!
    var ingredientList: IngredientList!
    var dataManager: DataManager!
    
    // Array with valid oz values for an ingredient
    var quantityArray: [Double]!
    var uniqueQuantity: Bool = false
    
    // Add Ingredient Picker
    var addIngredientPickerIndexPath: NSIndexPath?
    var pickerCellRowHeight: CGFloat!
    
    // UI elements
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // initialize quantity array
        self.quantityArray = []
        
        // fill quantity array
        for index in 1...28 {
            self.quantityArray.append(0.5 * Double(index))
        }
        
        // get Picker View Cell height
        let pickerViewCellToCheck: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.addIngredientPickerCell)!;
        self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
        
        self.configureView()
        self.reloadInputViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dataManager.socket.onText = { (text: String) in
            self.dataManager.parseResponseDataFromServer(text)
            self.recipe = self.dataManager.recipe
            if self.recipe.hasIce() {
                self.iceSegmentedControl.selectedSegmentIndex = 0
            } else {
                self.iceSegmentedControl.selectedSegmentIndex = 1
            }
            self.tableView.reloadData()
            
            // load image from web server url
            if !self.recipe.custom {
                let request = NSURLRequest(URL: NSURL(string: self.recipe.imageURLString)!)
                NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                    
                    if error != nil {
                        print("Failed to load image for url: \(self.recipe.imageURLString), error: \(error?.description)")
                        return
                    }
                    
                    guard let httpResponse = response as? NSHTTPURLResponse else {
                        print("Not an NSHTTPURLResponse from loading url: \(self.recipe.imageURLString)")
                        return
                    }
                    
                    if httpResponse.statusCode != 200 {
                        print("Bad response statusCode: \(httpResponse.statusCode) while loading url: \(self.recipe.imageURLString)")
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.imageView.image = UIImage(data: data!)
                    })
                    
                }.resume()
            }
        }
        
        if self.recipe.custom {
            self.orderButton.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    // Configure UI: set label, color, text attributes, etc
    func configureView() {
        let attributes = [NSForegroundColorAttributeName: barbotBlue]//, NSFontAttributeName: self.montserratFont]
        
        self.navigationItem.rightBarButtonItem = editButtonItem()
        
        // configure table view
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.allowsSelection = false
        self.tableView.allowsSelectionDuringEditing = true
        
        // configure segmented controls
        //self.shotSegmentedControl.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        //self.shotSegmentedControl.tintColor = self.barbotBlue
        self.sizeSegmentedControl.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.sizeSegmentedControl.tintColor = self.barbotBlue
        
        // configure order button
        // self.orderButton.titleLabel!.font = self.montserratFont
        self.orderButton.titleLabel?.textColor = self.barbotBlue
        
        self.orderButton.layer.cornerRadius = 5.0
        self.orderButton.layer.borderColor = self.barbotBlue.CGColor
        self.orderButton.layer.borderWidth = 0.9
        self.orderButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)
    }
    
    // Serializes Recipe JSON to be sent to Web Server
    // If not flagged as custom, only sends recipe Id
    @IBAction func orderDrink(sender: AnyObject) {
        // Send order to barbot web server
        
        let volume: Double = self.recipe.getRecipeVolume()
        switch self.sizeSegmentedControl.selectedSegmentIndex {
            case 0:
                if volume > 8.0 {
                    return
                }
            case 1:
                if volume > 16.0 {
                    return
                }
            default:
                break
        }
        
        if recipe.custom {
            // respond to create_custom_drink
            self.dataManager.socket.onText = {(text: String) in
                
//                // respond to order_drink
                self.dataManager.socket.onText = { (text: String) in
                    self.dataManager.parseResponseDataFromServer(text)
                    self.dataManager.socket.onText = nil                // set nil to avoid loop
                }
                self.dataManager.parseResponseDataFromServer(text)
                self.recipe.id = self.dataManager.recipeId
                self.dataManager.requestDataFromServer("order_drink", args: ["barbot_id": self.dataManager.barbotId, "recipe_id": self.recipe.id])
            }
            
            self.dataManager.requestDataFromServer("create_custom_drink", args: recipe.toJSON()!)
        } else {
            // respond to order_drink
            self.dataManager.socket.onText = { (text: String) in
                self.dataManager.parseResponseDataFromServer(text)
            }
            self.dataManager.requestDataFromServer("order_drink", args: ["barbot_id": self.dataManager.barbotId, "recipe_id": self.recipe.id])
        }
    }
    
    // MARK: - Segmented Controls
    
    @IBAction func sizeSegmentedControlChanged(sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//            case 0:
//                // 8oz, update Recipe
//                if self.shotSegmentedControl.selectedSegmentIndex == 0 {
//                    self.recipe = self.recipeSet.recipes![0]
//                } else {
//                    self.recipe = self.recipeSet.recipes![1]
//                }
//                break
//            case 1:
//                // 16oz, update Recipe
//                if self.shotSegmentedControl.selectedSegmentIndex == 0 {
//                    self.recipe = self.recipeSet.recipes![2]
//                } else {
//                    self.recipe = self.recipeSet.recipes![3]
//                }
//                break
//            default:
//                break
//        }
//        
//        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Fade)
//        
//        // Add 'new ingredient row' back if editing
//        if self.tableView.editing {
//            self.tableView.beginUpdates()
//            self.showAddNewIngredientRow()
//            self.tableView.endUpdates()
//        }
    }
    
    @IBAction func iceSegmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.recipe.addIce(0)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection:0)], withRowAnimation: .Fade)
                break
            case 1:
                self.recipe.removeIce()
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: 0, inSection:0)], withRowAnimation: .Fade)
                break
            default:
                break
        }
        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Fade)
    }
//    @IBAction func shotSegmentedControlChanged(sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//            case 0:
//                // single, update Recipe
//                if self.sizeSegmentedControl.selectedSegmentIndex == 0 {
//                    // short
//                    //self.recipe = self.recipeSet.recipes![0]
//                } else {
//                    // tall
//                    //self.recipe = self.recipeSet.recipes![2]
//                }
//                break
//            case 1:
//                // double, update Recipe
//                if self.sizeSegmentedControl.selectedSegmentIndex == 0 {
//                    // short
//                    //self.recipe = self.recipeSet.recipes![1]
//                } else {
//                    // tall
//                    //self.recipe = self.recipeSet.recipes![3]
//                }
//                break
//            default:
//                break
//        }
//        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Fade)
//        
//        // Add 'new ingredient row' back if editing
//        if self.tableView.editing {
//            self.tableView.beginUpdates()
//            self.showAddNewIngredientRow()
//            self.tableView.endUpdates()
//        }
//    }
    
    // MARK: - UITableView Editing
    
    override func setEditing(editing: Bool, animated: Bool) {
        if editing {                                    // Start editing, add New Ingredient row
            self.showAddNewIngredientRow()
            self.orderButton.enabled = false
        } else {                                        // End editing, remove New Ingredient row
            if self.addIngredientPickerIsShown() {
                self.tableView.beginUpdates()
                self.hideExistingPicker()
                self.tableView.endUpdates()
            }
            self.hideAddNewIngredientRow()
            if !self.recipe.steps.isEmpty {
                self.orderButton.enabled = true
            }
        }
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    // Adds a 'Add Ingredient' cell to UITableView and Steps array
    func showAddNewIngredientRow() {
        let stepNumber: Int = self.recipe.steps.count
        self.recipe.steps.append(Step.init(step_number: stepNumber, type: 99, measurement: "oz"))
        self.tableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: stepNumber, inSection:0)], withRowAnimation: .Fade)
    }
    
    // Hides 'Add Ingredient' cell from UITableView and removes from Steps array
    func hideAddNewIngredientRow() {
        let stepNumber: Int = self.recipe.steps.count
        self.recipe.steps.removeAtIndex(stepNumber-1)
        tableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: stepNumber-1, inSection:0)], withRowAnimation: .Fade)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if self.recipe.hasIce() && indexPath.row == 0 {
                self.iceSegmentedControl.selectedSegmentIndex = 1
            }
            
            self.recipe.steps.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        let lastIndexPath: NSIndexPath = NSIndexPath(forRow:(self.tableView(tableView, numberOfRowsInSection: 0) - 1), inSection:0);

        if self.addIngredientPickerIsShown() && (self.addIngredientPickerIndexPath!.row == indexPath.row || self.addIngredientPickerIndexPath!.row - 1 == indexPath.row) {
            return .None
        } else if indexPath.row == lastIndexPath.row {
            return .Insert;
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
    
//    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        if cell.selectionStyle == .None {
//            return nil
//        }
//        return indexPath
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.recipe.hasIce() && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        // edit ingredient, quantity
        self.tableView.beginUpdates()
        
        if self.addIngredientPickerIsShown() && self.addIngredientPickerIndexPath!.row - 1 == indexPath.row {
            if rowIsAddIngredientCell(indexPath.row) {
                self.showAddNewIngredientRow()
            }
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
        
        // scroll row with open picker view to top of table view
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
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
        var numberOfRows: Int = self.recipe.steps.count
        
        if self.addIngredientPickerIsShown() {
            numberOfRows += 1
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if self.addIngredientPickerIsShown() && self.addIngredientPickerIndexPath!.row == indexPath.row {
            cell = tableView.dequeueReusableCellWithIdentifier(self.addIngredientPickerCell, forIndexPath: indexPath)
            cell = self.configureAddIngredientPickerCell(cell, indexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(stepCell, forIndexPath: indexPath)
            cell = self.configureStepCell(cell, indexPath: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UIPickerViewDataSource
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.quantityArray.count
        } else {
            return self.ingredientList.ingredientList.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(self.quantityArray![row])
        } else {
            return self.ingredientList.ingredientList[row].name
        }
    }
    
    // function called when pickerview value changes
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var parentCellIndexPath: NSIndexPath!
        
        if self.addIngredientPickerIsShown() {
            parentCellIndexPath = NSIndexPath(forRow:self.addIngredientPickerIndexPath!.row - 1, inSection:0)
        } else {
            return
        }
        
        let cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(parentCellIndexPath)!
        
        if component == 0 {
            self.recipe.steps[parentCellIndexPath.row].quantity = self.quantityArray[row]
        } else if component == 1 {
            self.recipe.steps[parentCellIndexPath!.row].ingredientId = self.ingredientList.ingredientList[row].ingredientId
        }
        
        self.recipe.custom = true
        
        self.configureStepCell(cell, indexPath: parentCellIndexPath)
    }
    
    // MARK: - Inline UIPickerView methods
    
    // Add Ingredient Picker
    func addIngredientPickerIsShown() -> Bool {
        return self.addIngredientPickerIndexPath != nil
    }
    
    func hideExistingPicker() {
        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:self.addIngredientPickerIndexPath!.row, inSection: 0)], withRowAnimation: .Middle)
        self.addIngredientPickerIndexPath = nil
        if self.uniqueQuantity {
            self.quantityArray.removeFirst()
            self.uniqueQuantity = false
        }
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
                                              withRowAnimation: .Middle);
        
        if rowIsAddIngredientCell(indexPath.row) {
            // initialize some Step fields: transition from new ingredient to added ingredient
            self.recipe.steps[indexPath.row].type = 1
            self.recipe.steps[indexPath.row].ingredientId = self.ingredientList.ingredientList.first?.ingredientId
            self.recipe.steps[indexPath.row].quantity = 0.5
            let cell: UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
            self.configureStepCell(cell, indexPath: indexPath)
        }
    }
    
    func rowIsAddIngredientCell(row: Int) -> Bool {
        return row == self.recipe.steps.count - 1
    }
    
    // Add Ingredient Picker View Cell
    func configureAddIngredientPickerCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        let object: Step = self.recipe.steps[indexPath.row - 1]
        
        let pickerView: UIPickerView = cell.viewWithTag(kAddIngredientPickerTag) as! UIPickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        // select default quantity (volume) value for new picker view
        if object.quantity != nil {
            let quantity = object.quantity
            if !self.quantityArray.contains(quantity!) {
                self.quantityArray.insert(quantity!, atIndex: 0)
                self.uniqueQuantity = true
            }
            pickerView.selectRow(self.quantityArray.indexOf(quantity!)!, inComponent: 0, animated: true)
        } else {
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        
        // select default ingredient for new picker view
        if object.ingredientId != nil {
            let ingredient: Ingredient? = self.ingredientList.getIngredientForIngredientId(object.ingredientId!)
            let indexOfIngredient: Int? = self.ingredientList.indexOf(ingredient!)
            pickerView.selectRow(indexOfIngredient!, inComponent: 1, animated: true)
        } else {
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }

        return cell
    }
    
    // Add Step Cell
    func configureStepCell(cell: UITableViewCell, indexPath: NSIndexPath) -> UITableViewCell {
        cell.textLabel!.font = self.montserratFont
        
        let stepString: String = self.configureDisplayStringForCell(cell, indexPath: indexPath)
        
        cell.textLabel!.text = stepString
        return cell
    }
    
    func configureDisplayStringForCell(cell: UITableViewCell, indexPath: NSIndexPath) -> String {
        var object: Step
        var stepString: String = ""
        
        // Configure cells that are below the shown picker view in the table view
        if self.addIngredientPickerIsShown() && indexPath.row > self.addIngredientPickerIndexPath!.row {
            object = self.recipe.steps[indexPath.row-1]
            stepString.appendContentsOf("\(indexPath.row).")
        } else {
            object = self.recipe.steps[indexPath.row]
            stepString.appendContentsOf("\(indexPath.row + 1).")
        }
        
        // add ingredient name
        switch (object.type) {
            case 1:
                let ingredient: Ingredient = self.ingredientList.getIngredientForIngredientId(object.ingredientId!)!
                stepString.appendContentsOf(" Add \(object.quantity!) \(object.measurement!) \(ingredient.name)")
            case 2:
                stepString.appendContentsOf(" Mix")
                //cell.selectionStyle = .None
            case 3:
                stepString.appendContentsOf(" Stir")
                //cell.selectionStyle = .None
            case 4:
                stepString.appendContentsOf(" Add Ice")
                //cell.selectionStyle = .None
            case 5:
                stepString.appendContentsOf(" Pour")
                //cell.selectionStyle = .None
            case 99:
                stepString = "Add Ingredient"
            default:
                break
        }
        
        return stepString
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPourScreen" {
            let controller = segue.destinationViewController as! PourViewController
            
            controller.dataManager = self.dataManager
        }
    }
    
    // Creates and shows a AlertView prompt that:
    // 1. Thanks the user
    // 2. Allows the user to tap to return to the menu
    func showAlertController() {
        var size: String = ""
        if self.sizeSegmentedControl.selectedSegmentIndex == 0 {
            size = "8oz"
        } else {
            size = "16oz"
        }
        
        let alert: UIAlertController = UIAlertController.init(title: "Drink too large", message: "Please reduce volume to \(size)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok: UIAlertAction = UIAlertAction.init(title: "OK", style: .Default, handler:{
            (action: UIAlertAction) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showPourScreen" {
            let volume: Double = self.recipe.getRecipeVolume()
            switch self.sizeSegmentedControl.selectedSegmentIndex {
            case 0:
                if volume > 8.0 {
                    showAlertController()
                    return false
                } else {
                    return true
                }
            case 1:
                if volume > 16.0 {
                    showAlertController()
                    return false
                } else {
                    return true
                }
            default:
                return true
            }
        }
        return true
    }
}