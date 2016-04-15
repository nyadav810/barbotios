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
    
    let recipeId: String?
    let name: String?
    var size: String?
    var shot: String?
    var steps: [Step]?
    
    init?(json: JSON) {
        guard let recipe: JSON = "recipe" <~~ json
            else { return nil }

        self.recipeId = "id" <~~ recipe
        self.name = "name" <~~ recipe
        self.size = "size" <~~ recipe
        self.shot = "shot" <~~ recipe
        self.steps = "steps" <~~ recipe
    }
}