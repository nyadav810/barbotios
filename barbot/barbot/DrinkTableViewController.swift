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
    var drinks = [NSManagedObject]()
    
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Drinks"
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName: "Drink")
        
        //let managedContext = appDelegate.managedObjectContext
        
        do {
            let results =
            try managedObjectContext.executeFetchRequest(fetchRequest)
            drinks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewController
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        // let object : Drink = self.fetchedResultsController.
    }
    
}