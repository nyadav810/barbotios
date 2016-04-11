//
//  Recipe.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

struct Recipe: Decodable {
    
    let recipe_id: String
    let name: String
    let steps: [Step]?
    
    init?(json: JSON) {
        guard let recipe: JSON = "recipe" <~~ json
            else { return nil }
        
        guard let recipe_id: String = "id" <~~ recipe,
            name: String = "name" <~~ recipe
            else { return nil }

        self.recipe_id = recipe_id
        self.name = name
        self.steps = "steps" <~~ recipe
    }
}