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
    var drinkNameKeyString : String = "name"
    
    func entityName() -> String {
        return "Drink"
    }
}
