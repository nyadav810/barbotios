//
//  RecipeList.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct RecipeList: Gloss.Decodable {
    let recipes: [Recipe]?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.recipes = "recipes" <~~ json
    }
}
