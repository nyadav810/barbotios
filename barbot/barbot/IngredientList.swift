//
//  IngredientList.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct IngredientList: Decodable {
    
    let ingredientList: [Ingredient]
    
    init?(json: JSON) {
        guard let ingredientList: [Ingredient] = "ingredients" <~~ json
            else { return nil }
        
        self.ingredientList = ingredientList
    }
    
    func getIngredientForIngredientId(ingredientId: String) -> Ingredient? {
        for ingredient in self.ingredientList {
            if ingredientId == ingredient.ingredientId {
                return ingredient
            }
        }
        
        return nil
    }
    
    func indexOf(ingredient: Ingredient) -> Int {
        var index: Int = 0
        for i in self.ingredientList {
            if i.ingredientId == ingredient.ingredientId {
                break
            } else {
                index += 1
            }
        }
        return index
    }
}