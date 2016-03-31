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
    var drinks = [NSManagedObject]()
    var managedObjectContext : NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController {
        get {
            let fetchRequest : NSFetchRequest = NSFetchRequest.init()
            let drink : Drink = Drink.init()
            
            // Edit the entity name as appropriate.
            let entity : NSEntityDescription = NSEntityDescription.entityForName(drink.entityName(), inManagedObjectContext: self.managedObjectContext)!
            
            fetchRequest.entity = entity
            fetchRequest.fetchBatchSize = 20
            
            let sortDescriptor : NSSortDescriptor = NSSortDescriptor.init(key: drink.drinkNameKeyString, ascending: true)
                //.initWithKey(Drink.drinkNameKeyString, ascending: true)
            
            let sortDescriptors : NSArray = [sortDescriptor];
            
            fetchRequest.sortDescriptors = sortDescriptors as? [NSSortDescriptor]
            
            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
            
            let aFetchedResultsController : NSFetchedResultsController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: drink.drinkNameKeyString, cacheName: drinkCacheName)
            aFetchedResultsController.delegate = self
            self.fetchedResultsController = aFetchedResultsController
            return aFetchedResultsController
        }
        set(f) {
            self.fetchedResultsController = f
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drinks"
        
        // Call DataManager to retrieve drinks
        
//        tableView.registerClass(UITableViewCell.self,
//            forCellReuseIdentifier: "Cell")
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
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object : NSManagedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.fetchedResultsController.sectionForSectionIndexTitle(title, atIndex: index)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDrink") {
            let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow!
            
            let nav = segue.destinationViewController as! UINavigationController
            let destination : DrinkViewController = nav.topViewController as! DrinkViewController
            destination.drink = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Drink
        }
    }
    
    /*
    
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
    if ([[segue identifier] isEqualToString:@"showCameraGroup"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CamerasViewController *destination = segue.destinationViewController;
    destination.cameraGroup = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    }
    }
    */
}