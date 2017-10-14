//
//  DrinkOrder.swift
//  BarBot iOS
//
//  Created by Naveen Yadav on 10/12/17.
//  Copyright © 2017 BarBot Inc. All rights reserved.
//

import Gloss

struct DrinkOrder: Glossy {
    var drinkOrderId: String?
    var userId: String?
    var barbotId: String?
    var recipeId: String?
    var ice: Bool?
    var garnish: Bool?
    
    init(userId: String, barbotId: String, recipeId: String, ice: Bool, garnish: Bool) {
        self.userId = userId
        self.barbotId = barbotId
        self.recipeId = recipeId
        self.ice = ice
        self.garnish = garnish
    }
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.drinkOrderId = "drink_order_id" <~~ json
    }
    
    // MARK: - Serialization
    
    func toJSON() -> JSON? {
        let ice = self.ice! ? 1 : 0
        let garnish = self.garnish! ? 1 : 0
        
        return jsonify([
            "user_id" ~~> self.userId,
            "barbot_id" ~~> self.barbotId,
            "recipe_id" ~~> self.recipeId,
            "ice" ~~> ice,
            "garnish" ~~> garnish
        ])
    }
}
