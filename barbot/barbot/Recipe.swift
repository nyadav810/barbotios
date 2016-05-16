//
//  Recipe.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Gloss

struct Recipe: Decodable {
    
    var name: String?
    var id: String?
    var size: String?
    var shot: String?
    var steps: [Step]
    
    init() {
        self.steps = []
    }
    
    init?(json: JSON) {
        guard let recipe: [String: AnyObject] = "recipe" <~~ json
            else { return nil }
        
        guard let steps: [Step] = "steps" <~~ recipe
            else { return nil }
        
        self.name = "name" <~~ recipe
        self.id = "id" <~~ recipe
        self.size = "size" <~~ recipe
        self.shot = "shot" <~~ recipe
        self.steps = steps
    }
    
    func getRecipeVolume() -> Double {
        var volume: Double = 0.0
        for step in self.steps {
            if step.ingredientId != "ingredient_0" {
                volume += step.quantity!
            }
        }
        return volume
    }
}