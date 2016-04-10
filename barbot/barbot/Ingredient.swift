//
//  Ingredient.swift
//  barbot
//
//  Created by Naveen Yadav on 4/7/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation

class Ingredient {
    
    var name : String
    var brand : String
    var type : String
    var ingredient_id : String
    
    init(name: String, brand: String, type: String, ingredient_id: String) {
        self.name = name
        self.brand = brand
        self.type = type
        self.ingredient_id = ingredient_id
    }
    
}