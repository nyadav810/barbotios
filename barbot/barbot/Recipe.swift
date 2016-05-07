//
//  Recipe.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Recipe: Decodable {
    
    let recipeId: String?
    let name: String?
    var size: String?
    var shot: String?
    var steps: [Step]?
    
    init?(json: JSON) {

        self.recipeId = "id" <~~ json
        self.name = "name" <~~ json
        self.size = "size" <~~ json
        self.shot = "shot" <~~ json
        self.steps = "steps" <~~ json
    }
}