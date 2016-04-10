//
//  Recipe.swift
//  barbot
//
//  Created by Naveen Yadav on 4/9/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

public struct Recipe: Decodable {
    
    public let name: String
    public let recipe_id: String
    
    public init?(json: JSON) {
        guard let recipe: JSON = "recipe" <~~ json
            else { return nil }
        
        guard let name: String = "name" <~~ recipe,
            recipe_id: String = "recipe_id" <~~ recipe
            else { return nil }

        self.name = name
        self.recipe_id = recipe_id
    }
}