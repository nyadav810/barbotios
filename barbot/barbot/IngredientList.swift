//
//  IngredientList.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct IngredientList: Decodable {
    
    let ingredientList: [Ingredient]?
    let barbotId: String?
    
    init?(json: JSON) {
        guard let payload: JSON = "payload" <~~ json
            else { return nil }
        
        self.barbotId = "barbot_id" <~~ payload
        self.ingredientList = "ingredients" <~~ payload
    }
    
    func getIngredientForIngredientId(ingredientId: String) -> Ingredient? {
        for ingredient in self.ingredientList! {
            if ingredientId == ingredient.ingredientId {
                return ingredient
            }
        }
        
        return nil
    }
    
    func indexOf(ingredient: Ingredient) -> Int {
        var index: Int = 0
        for i in self.ingredientList! {
            if i.ingredientId == ingredient.ingredientId {
                break
            } else {
                index += 1
            }
        }
        return index
    }
}