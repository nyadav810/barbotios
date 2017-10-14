//
//  Ingredient.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct Ingredient: Glossy {
    let ingredientId: String
    let name: String?
    var amount: Double?
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let ingredientId: String = "ingredient_id" <~~ json else {
            return nil
        }
        
        self.ingredientId = ingredientId
        self.name = "name" <~~ json
        self.amount = "amount" <~~ json
    }
    
    // MARK: - Serialization
    
    func toJSON() -> JSON? {
        return jsonify([
            "ingredient_id" ~~> self.ingredientId,
            "amount" ~~> self.amount
        ])
    }
}
