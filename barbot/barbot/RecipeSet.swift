//
//  RecipeList.swift
//  barbot
//
//  Created by Naveen Yadav on 4/14/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

struct RecipeSet: Decodable {
    
    let name: String?
    let recipeId: String?
    let recipes: [Recipe]?
    
    init?(json: JSON) {
        guard let payload: JSON = "payload" <~~ json
            else { return nil }
        
        self.name = "name" <~~ payload
        self.recipeId = "id" <~~ payload
        self.recipes = "recipe_set" <~~ payload
    }
}