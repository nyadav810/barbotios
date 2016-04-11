//
//  IngredientList.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

struct IngredientList: Decodable {
    
    let ingredientList: [Ingredient]?
    
    init?(json: JSON) {
        self.ingredientList = "ingredients" <~~ json
    }
}