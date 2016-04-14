//
//  IngredientList.swift
//  barbot
//
//  Created by Naveen Yadav on 4/10/16.
//  Copyright © 2016 BarBot. All rights reserved.
//

import Foundation
import Gloss

struct IngredientList: Decodable {
    
    let ingredientList: [Ingredient]?
    let barbotId: String?
    
    init?(json: JSON) {
        guard let payload: JSON = "payload" <~~ json
            else { return nil }
        
        self.barbotId = "barbot_id" <~~ payload
        self.ingredientList = "ingredients" <~~ payload
    }
}