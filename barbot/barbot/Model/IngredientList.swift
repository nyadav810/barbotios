//
//  IngredientList.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct IngredientList: Gloss.Decodable {
    let ingredients: [Ingredient]?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.ingredients = "ingredients" <~~ json
    }
}
