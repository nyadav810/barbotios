//
//  DrinkTableViewController.swift
//  barbot
//
//  Created by Naveen Yadav on 2/23/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DrinkTableViewController : UITableViewController, NSFetchedResultsControllerDelegate {
    
    let drinkCacheName : String = "drink"
    var managedObjectContext : NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // example drink
        let drink : Drink = Drink.init(name: "Make Your Own", recipe_id:"recipe_custom", managedObjectContext: self.managedObjectContext)
        
        // Create fetch request and set entity
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: drink.entityName())
        fetchRequest.entity = drink.entity
        
        // Sort Descriptors
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor.init(key: drink.drinkNameKeyString, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create fetched results controller
        let aFetchedResultsController : NSFetchedResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: drink.drinkNameKeyString, cacheName: "drink")
        aFetchedResultsController.delegate = self
        return aFetchedResultsController
    }()
    var dataManager : DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Barbot"
        
        // Call DataManager to retrieve drinks
        let dataManager : DataManager = DataManager.init()
        dataManager.getMenuDataFromFile()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("error fetching menu: \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UITableViewController
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo : NSFetchedResultsSectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let object : Drink = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Drink
        cell.textLabel!.text = object.name
        cell.textLabel!.font = UIFont(name: "Montserrat-Regular", size: 16)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object : NSManagedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
    }

    // Section Index functions
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        return self.fetchedResultsController.sectionIndexTitles
//    }
//    
//    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        return self.fetchedResultsController.sectionForSectionIndexTitle(title, atIndex: index)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
        
        if segue.identifier == "showDrinkScreen" {
            if let viewController = segue.destinationViewController as? DrinkViewController {
                viewController.managedObjectContext = managedObjectContext
                viewController.drink = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Drink
            }
        }
    }
}