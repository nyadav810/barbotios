//
//  Drink.swift
//  barbot
//
//  Created by Naveen Yadav on 4/26/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Drink: Decodable {
    
    let recipeId: String?
    let name: String?
    
    init(name: String) {
        self.recipeId = "custom_recipe"
        self.name = name
    }
    
    init?(json: JSON) {
        guard let recipeId: String = "id" <~~ json,
            name: String = "name" <~~ json
            else { return nil }
        
        self.recipeId = recipeId
        self.name = name
    }
}
