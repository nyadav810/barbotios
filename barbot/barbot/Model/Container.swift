//
//  Container.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct Container: Glossy {
    var ingredientId: String
    let number: Int
    var currentVolume: Int
    let maxVolume: Int
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        guard let ingredientId: String = "ingredient_id" <~~ json,
            let number: Int = "number" <~~ json,
            let currentVolume: Int = "current_volume" <~~ json,
            let maxVolume: Int = "max_volume" <~~ json else {
                return nil
        }
        
        self.ingredientId = ingredientId
        self.number = number
        self.currentVolume = currentVolume
        self.maxVolume = maxVolume
    }
    
    // MARK: - Serialization
    
    func toJSON() -> JSON? {
        return jsonify([
            "number" ~~> self.number,
            "ingredient_id" ~~> self.ingredientId,
            "current_volume" ~~> self.currentVolume,
            "max_volume" ~~> self.maxVolume
        ])
    }
}
