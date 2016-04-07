//
//  Drink.swift
//  barbot
//
//  Created by Naveen Yadav on 3/30/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import CoreData
class Drink: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var recipe_id: String
    var drinkNameKeyString : String = "name"
    
    func entityName() -> String {
        return "Drink"
    }
    
    init(name: String, recipe_id: String, managedObjectContext: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("Drink", inManagedObjectContext: managedObjectContext)!
        super.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        self.name = name
        self.recipe_id = recipe_id
    }
}
