//
//  Ingredient.swift
//  barbot
//
//  Created by Naveen Yadav on 4/7/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Ingredient: Decodable {
    
    let ingredientId: String
    let name: String
    let brand: String
    let type: String
    
    init?(json: JSON) {
        
        guard let ingredientId: String = "ingredientId" <~~ json,
            name: String = "name" <~~ json,
            brand: String = "brand" <~~ json,
            type: String = "type" <~~ json
            else { return nil }
        
        self.ingredientId = ingredientId
        self.name = name
        self.brand = brand
        self.type = type
    }
    
}