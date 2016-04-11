//
//  Ingredient.swift
//  barbot
//
//  Created by Naveen Yadav on 4/7/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

struct Ingredient: Decodable {
    
    let ingredient_id: String
    let name: String
    let brand: String
    let type: String
    
    init?(json: JSON) {
        guard let ingredient: JSON = "ingredient" <~~ json
            else { return nil }
        
        guard let ingredient_id: String = "ingredient_id" <~~ ingredient,
            name: String = "name" <~~ ingredient,
            brand: String = "brand" <~~ ingredient,
            type: String = "type" <~~ ingredient
            else { return nil }
        
        self.ingredient_id = ingredient_id
        self.name = name
        self.brand = brand
        self.type = type
    }
    
}