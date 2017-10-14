//
//  Recipe.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct Recipe: Glossy {
    let recipeId : String
    let name : String?
    let img : String?
    var ingredients : [Ingredient]?
    
    init(name: String, img: String, ingredients: [Ingredient]) {
        self.recipeId = "custom_recipe"
        self.name = name
        self.img = img
        self.ingredients = ingredients
    }
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let recipe: [String: AnyObject] = "recipe" <~~ json else {
            return nil
        }
        
        guard let recipeId: String = "recipe_id" <~~ recipe else {
            return nil
        }
        
        self.recipeId = recipeId
        self.name = "name" <~~ recipe
        self.img = "img" <~~ recipe
        self.ingredients = "ingredients" <~~ recipe
    }
    
    // MARK: - Serialization
    
    func toJSON() -> JSON? {
        return jsonify([
            "recipe.recipe_id" ~~> self.recipeId,
            "recipe.name" ~~> self.name,
            "recipe.img" ~~> self.img,
            "recipe.ingredients" ~~> self.ingredients
        ])
    }
    
    func getVolume() -> Double {
        var volume = 0.0
        for ingredient in self.ingredients! {
            volume += ingredient.amount!
        }
        return volume
    }
}
